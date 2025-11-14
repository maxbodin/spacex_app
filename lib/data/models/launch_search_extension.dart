import 'package:spacex_app/data/models/launch.model.dart';

extension LaunchSearch on LaunchModel {
  /// Checks if the launch matches a given search query.
  /// The search is case-insensitive and checks against the most pertinent fields.
  bool matchesSearch(String query) {
    if (query.isEmpty) {
      return true; // If query is empty, everything matches.
    }

    final lowerCaseQuery = query.toLowerCase();

    if (name.toLowerCase().contains(lowerCaseQuery)) {
      return true;
    }

    if (flightNumber.toString().contains(lowerCaseQuery)) {
      return true;
    }

    if (details != null && details!.toLowerCase().contains(lowerCaseQuery)) {
      return true;
    }

    if (rocketId.toLowerCase().contains(lowerCaseQuery)) {
      return true;
    }

    return false; // No match found.
  }
}
