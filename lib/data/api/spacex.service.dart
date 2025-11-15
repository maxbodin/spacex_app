import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launchpad.model.dart';
import 'package:spacex_app/data/models/payload.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

/// Abstract interface for a service that retrieves data from the SpaceX API.
abstract class SpaceXApiService {
  Future<List<LaunchModel>> getAllLaunches();

  Future<List<RocketModel>> getAllRockets();

  Future<List<LaunchpadModel>> getAllLaunchpads();

  Future<RocketModel> getRocketDetails(String rocketId);

  Future<LaunchpadModel> getLaunchpadDetails(String launchpadId);

  Future<List<PayloadModel>> getPayloadsDetails(List<String> payloadIds);
}

/// Implementation of [SpaceXApiService].
///
/// This class handles the HTTP requests and JSON parsing required to communicate
/// with the official SpaceX v4 API.
class SpaceXApiServiceImpl implements SpaceXApiService {
  final http.Client client;
  static const String _baseUrl = "https://api.spacexdata.com/v4";

  SpaceXApiServiceImpl({required this.client});

  /// A generic helper method to fetch and decode a JSON object from an endpoint.
  ///
  /// - [T] is the type of the model to be returned (e.g., [RocketModel]).
  /// - [endpoint] is the API path (e.g., 'rockets/rocketId').
  /// - [fromJson] is the factory constructor of the model (e.g., `RocketModel.fromJson`).
  Future<T> _fetchObject<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception(
        'Failed to load data from $endpoint. Status code: ${response.statusCode}',
      );
    }
  }

  /// A generic helper method to fetch and decode a list of JSON objects from an endpoint.
  ///
  /// This centralizes the logic for fetching lists, avoiding code duplication.
  /// - [T] is the type of the model in the list (e.g., [LaunchModel]).
  /// - [endpoint] is the API path (e.g., 'launches').
  /// - [fromJson] is the factory constructor of the model (e.g., `LaunchModel.fromJson`).
  Future<List<T>> _fetchList<T>(
    String endpoint,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final uri = Uri.parse('$_baseUrl/$endpoint');
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Failed to load list from $endpoint. Status code: ${response.statusCode}',
      );
    }
  }

  @override
  Future<List<LaunchModel>> getAllLaunches() {
    return _fetchList('launches', LaunchModel.fromJson);
  }

  @override
  Future<List<RocketModel>> getAllRockets() {
    return _fetchList('rockets', RocketModel.fromJson);
  }

  @override
  Future<List<LaunchpadModel>> getAllLaunchpads() {
    return _fetchList('launchpads', LaunchpadModel.fromJson);
  }

  @override
  Future<RocketModel> getRocketDetails(String rocketId) {
    return _fetchObject('rockets/$rocketId', RocketModel.fromJson);
  }

  @override
  Future<LaunchpadModel> getLaunchpadDetails(String launchpadId) {
    return _fetchObject('launchpads/$launchpadId', LaunchpadModel.fromJson);
  }

  @override
  Future<List<PayloadModel>> getPayloadsDetails(List<String> payloadIds) {
    if (payloadIds.isEmpty) {
      return Future.value([]);
    }

    // Use Future.wait to fetch all payloads concurrently for better performance.
    final futures = payloadIds.map(
      (id) => _fetchObject('payloads/$id', PayloadModel.fromJson),
    );

    return Future.wait(futures);
  }
}
