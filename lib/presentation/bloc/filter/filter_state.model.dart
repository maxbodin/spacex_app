import 'package:equatable/equatable.dart';
import 'package:spacex_app/data/models/launch.model.dart';

enum SortOption { dateNewestFirst, dateOldestFirst, flightNumber }

enum LaunchStatus { success, failure }

class FilterState extends Equatable {
  final SortOption sortOption;
  final LaunchStatus? launchStatus;
  final int? year;
  final String? rocketId;
  final String? launchpadId;

  const FilterState({
    this.sortOption = SortOption.dateNewestFirst,
    this.launchStatus,
    this.year,
    this.rocketId,
    this.launchpadId,
  });

  FilterState copyWith({
    SortOption? sortOption,
    LaunchStatus? launchStatus,
    int? year,
    String? rocketId,
    String? launchpadId,
    bool resetYear = false,
    bool resetRocket = false,
    bool resetLaunchpad = false,
    bool resetLaunchStatus = false,
  }) {
    return FilterState(
      sortOption: sortOption ?? this.sortOption,
      launchStatus: resetLaunchStatus
          ? null
          : launchStatus ?? this.launchStatus,
      year: resetYear ? null : year ?? this.year,
      rocketId: resetRocket ? null : rocketId ?? this.rocketId,
      launchpadId: resetLaunchpad ? null : launchpadId ?? this.launchpadId,
    );
  }

  @override
  List<Object?> get props => [
    sortOption,
    launchStatus,
    year,
    rocketId,
    launchpadId,
  ];
}

class FilterOptions {
  final List<int> years;
  final Map<String, String> rockets;
  final Map<String, String> launchpads;

  const FilterOptions({
    required this.years,
    required this.rockets,
    required this.launchpads,
  });

  factory FilterOptions.fromLaunches(List<LaunchModel> launches) {
    final years = launches.map((l) => l.dateUtc.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    final rockets = {
      for (var l in launches)
        l.rocketId: 'Rocket ID: ${l.rocketId.substring(0, 8)}...',
    };
    final launchpads = {
      for (var l in launches)
        l.launchpad: 'Pad ID: ${l.launchpad.substring(0, 8)}...',
    };

    return FilterOptions(
      years: years,
      rockets: rockets,
      launchpads: launchpads,
    );
  }
}
