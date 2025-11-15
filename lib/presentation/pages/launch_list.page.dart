import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/core/extensions/string.extension.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launch_search_extension.dart';
import 'package:spacex_app/presentation/bloc/data_assets/data_assets_cubit.dart';
import 'package:spacex_app/presentation/bloc/data_assets/data_assets_state.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.cubit.dart';
import 'package:spacex_app/presentation/bloc/favorites/favorites.state.dart';
import 'package:spacex_app/presentation/bloc/filter/filter_cubit.dart';
import 'package:spacex_app/presentation/bloc/filter/filter_state.model.dart';
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
          // Sort Menu Button
          BlocBuilder<LaunchListCubit, LaunchListState>(
            builder: (context, launchState) {
              if (launchState is! LaunchListLoaded) {
                return const SizedBox.shrink();
              }
              return BlocBuilder<FilterCubit, FilterState>(
                builder: (context, filterState) {
                  return PopupMenuButton<SortOption>(
                    icon: const Icon(Icons.sort),
                    onSelected: (option) =>
                        context.read<FilterCubit>().setSortOption(option),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: SortOption.dateNewestFirst,
                        child: Text("Newest First"),
                      ),
                      const PopupMenuItem(
                        value: SortOption.dateOldestFirst,
                        child: Text("Oldest First"),
                      ),
                      const PopupMenuItem(
                        value: SortOption.flightNumber,
                        child: Text("By Flight Number"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // View Toggle Button
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
      body: BlocBuilder<DataAssetsCubit, DataAssetsState>(
        builder: (context, dataAssetsState) {
          if (dataAssetsState is DataAssetsLoading ||
              dataAssetsState is DataAssetsInitial) {
            return const Center(child: Text("Preparing mission data..."));
          }
          if (dataAssetsState is DataAssetsError) {
            return Center(
              child: Text(
                'Could not load app data: ${dataAssetsState.message}',
              ),
            );
          }
          if (dataAssetsState is DataAssetsLoaded) {
            return BlocBuilder<LaunchListCubit, LaunchListState>(
              builder: (context, launchState) {
                if (launchState is LaunchListLoading ||
                    launchState is LaunchListInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (launchState is LaunchListError) {
                  return Center(child: Text('Error: ${launchState.message}'));
                }
                if (launchState is LaunchListLoaded) {
                  final years =
                      launchState.launches
                          .map((l) => l.dateUtc.year)
                          .toSet()
                          .toList()
                        ..sort((a, b) => b.compareTo(a));
                  final rockets = {
                    for (var r in dataAssetsState.rockets) r.id: r.name,
                  };
                  final launchpads = {
                    for (var p in dataAssetsState.launchpads) p.id: p.fullName,
                  };
                  final filterOptions = FilterOptions(
                    years: years,
                    rockets: rockets,
                    launchpads: launchpads,
                  );

                  return Column(
                    children: [
                      _SearchBar(controller: _searchController),
                      _FilterBar(options: filterOptions),
                      Expanded(
                        child: BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, favoritesState) {
                            return BlocBuilder<FilterCubit, FilterState>(
                              builder: (context, filterState) {
                                if (favoritesState is FavoritesLoaded) {
                                  List<LaunchModel> processedLaunches =
                                      List.from(launchState.launches);
                                  processedLaunches = processedLaunches.where((
                                    launch,
                                  ) {
                                    final bool statusFilter;
                                    switch (filterState.launchStatus) {
                                      case LaunchStatus.success:
                                        statusFilter = launch.success ?? false;
                                        break;
                                      case LaunchStatus.failure:
                                        statusFilter =
                                            !(launch.success ?? false);
                                        break;
                                      case null:
                                        statusFilter = true;
                                        break;
                                    }
                                    final yearFilter =
                                        filterState.year == null ||
                                        launch.dateUtc.year == filterState.year;
                                    final rocketFilter =
                                        filterState.rocketId == null ||
                                        launch.rocketId == filterState.rocketId;
                                    final launchpadFilter =
                                        filterState.launchpadId == null ||
                                        launch.launchpad ==
                                            filterState.launchpadId;
                                    return statusFilter &&
                                        yearFilter &&
                                        rocketFilter &&
                                        launchpadFilter;
                                  }).toList();
                                  processedLaunches.sort((a, b) {
                                    switch (filterState.sortOption) {
                                      case SortOption.dateOldestFirst:
                                        return a.dateUtc.compareTo(b.dateUtc);
                                      case SortOption.flightNumber:
                                        return a.flightNumber.compareTo(
                                          b.flightNumber,
                                        );
                                      case SortOption.dateNewestFirst:
                                        return b.dateUtc.compareTo(a.dateUtc);
                                    }
                                  });
                                  final searchedLaunches = processedLaunches
                                      .where(
                                        (launch) =>
                                            launch.matchesSearch(_searchQuery),
                                      )
                                      .toList();
                                  final favoriteIds = favoritesState.favoriteIds
                                      .toSet();
                                  final favoriteLaunches = <LaunchModel>[];
                                  final otherLaunches = <LaunchModel>[];
                                  for (final launch in searchedLaunches) {
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
                                return const Center(
                                  child: Text("Loading favorites..."),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: Text('Something went wrong.'));
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final FilterOptions options;

  const _FilterBar({required this.options});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterState>(
      builder: (context, state) {
        final rocketLabel = state.rocketId == null
            ? "All Rockets"
            : options.rockets[state.rocketId] ?? "Unknown Rocket";

        final launchpadLabel = state.launchpadId == null
            ? "All Pads"
            : options.launchpads[state.launchpadId] ?? "Unknown Pad";

        final statusLabel = state.launchStatus == null
            ? "All Statuses"
            : "Status: ${state.launchStatus!.name.capitalize()}";

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: Row(
            children: [
              // Status Filter
              _FilterChip(
                label: statusLabel,
                allText: "All Statuses",
                options: {for (var v in LaunchStatus.values) v.name: v},
                isEnumMap: true,
                onSelected: (status) => context
                    .read<FilterCubit>()
                    .setLaunchStatus(status as LaunchStatus?),
              ),

              // Year Filter
              _FilterChip(
                label: state.year == null ? "All Years" : "Year: ${state.year}",
                allText: "All Years",
                options: {for (var y in options.years) y.toString(): y},
                onSelected: (year) =>
                    context.read<FilterCubit>().setYear(year as int?),
              ),

              // Rocket Filter
              _FilterChip(
                label: rocketLabel,
                allText: "All Rockets",
                options: options.rockets,
                onSelected: (id) =>
                    context.read<FilterCubit>().setRocket(id as String?),
              ),

              // Launchpad Filter
              _FilterChip(
                label: launchpadLabel,
                allText: "All Pads",
                options: options.launchpads,
                onSelected: (id) =>
                    context.read<FilterCubit>().setLaunchpad(id as String?),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final Map<String, dynamic> options;
  final Function(dynamic) onSelected;
  final String? allText;
  final bool isEnumMap;

  const _FilterChip({
    required this.label,
    required this.options,
    required this.onSelected,
    this.allText,
    this.isEnumMap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ActionChip(
        label: Text(label),
        avatar: const Icon(Icons.arrow_drop_down, size: 18),
        onPressed: () async {
          final RenderBox button = context.findRenderObject()! as RenderBox;
          final RenderBox overlay =
              Overlay.of(context).context.findRenderObject()! as RenderBox;
          final position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(Offset.zero, ancestor: overlay),
              button.localToGlobal(
                button.size.bottomRight(Offset.zero),
                ancestor: overlay,
              ),
            ),
            Offset.zero & overlay.size,
          );

          final selectedValue = await showMenu(
            context: context,
            position: position,
            items: [
              if (allText != null)
                PopupMenuItem(value: null, child: Text(allText!)),
              ...options.entries.map((entry) {
                final String displayText = isEnumMap
                    ? entry.key
                    : entry.value.toString();

                return PopupMenuItem(
                  value: isEnumMap ? entry.value : entry.key,
                  child: Text(displayText.capitalize()),
                );
              }),
            ],
          );

          if (selectedValue != null || allText != null) {
            // For the year filter, the selectedValue is the key (a String).
            // We need to look up the corresponding integer value.
            if (!isEnumMap &&
                selectedValue is String &&
                options[selectedValue] is int) {
              onSelected(options[selectedValue]);
            } else {
              onSelected(selectedValue);
            }
          }
        },
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
