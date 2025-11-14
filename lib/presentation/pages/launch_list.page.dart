import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.cubit.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.state.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_grid_item.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_list_item.dart';

class LaunchListPage extends StatelessWidget {
  const LaunchListPage({super.key});

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
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favoritesState) {
          return BlocBuilder<LaunchListCubit, LaunchListState>(
            builder: (context, launchState) {
              if (launchState is LaunchListLoading ||
                  launchState is LaunchListInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              if (launchState is LaunchListError) {
                return Center(child: Text('Error: ${launchState.message}'));
              }

              if (launchState is LaunchListLoaded &&
                  favoritesState is FavoritesLoaded) {
                final allLaunches = launchState.launches.reversed.toList();

                final favoriteIds = favoritesState.favoriteIds
                    .toSet();

                final favoriteLaunches = <LaunchModel>[];
                final otherLaunches = <LaunchModel>[];

                for (final launch in allLaunches) {
                  if (favoriteIds.contains(launch.id)) {
                    favoriteLaunches.add(launch);
                  } else {
                    otherLaunches.add(launch);
                  }
                }

                final sortedLaunches = [...favoriteLaunches, ...otherLaunches];

                return _LaunchDisplay(
                  launches: sortedLaunches,
                  isGridView: launchState.isGridView,
                );
              }

              return const Center(child: Text('Something went wrong.'));
            },
          );
        },
      ),
    );
  }
}

/// Private, stateless widget to display launches in either a grid or a list.
/// This prevents code duplication in the main build method.
class _LaunchDisplay extends StatelessWidget {
  final List<LaunchModel> launches;
  final bool isGridView;

  const _LaunchDisplay({required this.launches, required this.isGridView});

  @override
  Widget build(BuildContext context) {
    if (launches.isEmpty) {
      return const Center(
        child: Text('No launches found.', style: TextStyle(color: Colors.grey)),
      );
    }

    if (isGridView) {
      return GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: launches.length,
        itemBuilder: (context, index) {
          return LaunchGridItem(launch: launches[index]);
        },
      );
    }

    return ListView.builder(
      itemCount: launches.length,
      itemBuilder: (context, index) {
        return LaunchListItem(launch: launches[index]);
      },
    );
  }
}
