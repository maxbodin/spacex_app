import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launch_search_extension.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.cubit.dart';
import 'package:spacex_app/presentation/bloc/launches/launch_list.state.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_grid_item.dart';
import 'package:spacex_app/presentation/widgets/organisms/launch_list_item.dart';

class LaunchListPage extends StatefulWidget {
  const LaunchListPage({super.key});

  @override
  State<LaunchListPage> createState() => _LaunchListPageState();
}

class _LaunchListPageState extends State<LaunchListPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
      body: Column(
        children: [
          _SearchBar(controller: _searchController),
          Expanded(
            child: BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, favoritesState) {
                return BlocBuilder<LaunchListCubit, LaunchListState>(
                  builder: (context, launchState) {
                    if (launchState is LaunchListLoading ||
                        launchState is LaunchListInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (launchState is LaunchListError) {
                      return Center(
                        child: Text('Error: ${launchState.message}'),
                      );
                    }
                    if (launchState is LaunchListLoaded &&
                        favoritesState is FavoritesLoaded) {
                      final allLaunches = launchState.launches.reversed
                          .toList();

                      final filteredLaunches = allLaunches
                          .where((launch) => launch.matchesSearch(_searchQuery))
                          .toList();

                      final favoriteIds = favoritesState.favoriteIds.toSet();
                      final favoriteLaunches = <LaunchModel>[];
                      final otherLaunches = <LaunchModel>[];

                      for (final launch in filteredLaunches) {
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
                        searchQuery: _searchQuery,
                      );
                    }
                    return const Center(child: Text('Something went wrong.'));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search by name, flight number, details...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () => controller.clear(),
                )
              : null,
          filled: true,
          fillColor: Colors.grey.shade800,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

/// Private, stateless widget to display launches in either a grid or a list.
class _LaunchDisplay extends StatelessWidget {
  final List<LaunchModel> favoriteLaunches;
  final List<LaunchModel> otherLaunches;
  final bool isGridView;
  final String searchQuery;

  const _LaunchDisplay({
    required this.favoriteLaunches,
    required this.otherLaunches,
    required this.isGridView,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    if (favoriteLaunches.isEmpty && otherLaunches.isEmpty) {
      // If there's a search query, it means no results were found.
      if (searchQuery.isNotEmpty) {
        return const Center(
          child: Text(
            'No results found.',
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      // Otherwise, the initial list itself is empty.
      return const Center(
        child: Text(
          'No launches available.',
          style: TextStyle(color: Colors.grey),
        ),
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
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
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
