import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.cubit.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.state.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_grid_item.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_list_item.dart';

class LaunchListScreen extends StatelessWidget {
  const LaunchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpaceX Launches'),
        actions: [
          BlocBuilder<LaunchListCubit, LaunchListState>(
            builder: (context, state) {
              if (state is LaunchListLoaded) {
                return IconButton(
                  icon: Icon(
                    state.isGridView ? Icons.view_list : Icons.view_module,
                  ),
                  onPressed: () => context.read<LaunchListCubit>().toggleView(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<LaunchListCubit, LaunchListState>(
        builder: (context, state) {
          if (state is LaunchListLoading || state is LaunchListInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LaunchListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          if (state is LaunchListLoaded) {
            final launches = state.launches.reversed
                .toList(); // Show newest first
            return state.isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: launches.length,
                    itemBuilder: (context, index) {
                      return LaunchGridItem(launch: launches[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: launches.length,
                    itemBuilder: (context, index) {
                      return LaunchListItem(launch: launches[index]);
                    },
                  );
          }
          return const Center(child: Text('Something went wrong.'));
        },
      ),
    );
  }
}
