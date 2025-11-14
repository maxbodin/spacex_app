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
                final favoriteIds = favoritesState.favoriteIds.toSet();

                final favoriteLaunches = <LaunchModel>[];
                final otherLaunches = <LaunchModel>[];

                for (final launch in allLaunches) {
                  if (favoriteIds.contains(launch.id)) {
                    favoriteLaunches.add(launch);
                  } else {
                    otherLaunches.add(launch);
                  }
                }

                return _LaunchDisplay(
                  favoriteLaunches: favoriteLaunches,
                  otherLaunches: otherLaunches,
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
class _LaunchDisplay extends StatelessWidget {
  final List<LaunchModel> favoriteLaunches;
  final List<LaunchModel> otherLaunches;
  final bool isGridView;

  const _LaunchDisplay({
    required this.favoriteLaunches,
    required this.otherLaunches,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteLaunches.isEmpty && otherLaunches.isEmpty) {
      return const Center(
        child: Text('No launches found.', style: TextStyle(color: Colors.grey)),
      );
    }

    return CustomScrollView(
      slivers: [
        // FAVORITES SECTION
        // Only show this section if there are favorites.
        if (favoriteLaunches.isNotEmpty) ...[
          const _SectionHeader(title: 'Favorites'),
          _buildSliverContent(favoriteLaunches),
        ],

        // OTHER LAUNCHES SECTION
        if (otherLaunches.isNotEmpty) ...[
          const _SectionHeader(title: 'All Launches'),
          _buildSliverContent(otherLaunches),
        ],
      ],
    );
  }

  Widget _buildSliverContent(List<LaunchModel> launches) {
    if (isGridView) {
      return SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => LaunchGridItem(launch: launches[index]),
            childCount: launches.length,
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => LaunchListItem(launch: launches[index]),
          childCount: launches.length,
        ),
      );
    }
  }
}

/// Widget for displaying section headers.
class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent.shade100,
          ),
        ),
      ),
    );
  }
}
