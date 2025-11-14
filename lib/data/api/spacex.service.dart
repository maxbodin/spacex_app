import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launchpad.model.dart';
import 'package:spacex_app/data/models/payload.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

abstract class SpaceXApiService {
  Future<List<LaunchModel>> getAllLaunches();

  Future<RocketModel> getRocketDetails(String rocketId);

  Future<LaunchpadModel> getLaunchpadDetails(String launchpadId);

  Future<List<PayloadModel>> getPayloadsDetails(List<String> payloadIds);
}

class SpaceXApiServiceImpl implements SpaceXApiService {
  final http.Client client;
  final String _baseUrl = "https://api.spacexdata.com/v4";

  SpaceXApiServiceImpl({required this.client});

  Future<T> _fetchData<T>(
    String endpoint,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await client.get(Uri.parse('$_baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from $endpoint');
    }
  }

  @override
  Future<List<LaunchModel>> getAllLaunches() async {
    final response = await client.get(Uri.parse('$_baseUrl/launches'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LaunchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load launches');
    }
  }

  @override
  Future<RocketModel> getRocketDetails(String rocketId) {
    return _fetchData(
      'rockets/$rocketId',
      (json) => RocketModel.fromJson(json),
    );
  }

  @override
  Future<LaunchpadModel> getLaunchpadDetails(String launchpadId) {
    return _fetchData(
      'launchpads/$launchpadId',
      (json) => LaunchpadModel.fromJson(json),
    );
  }

  @override
  Future<List<PayloadModel>> getPayloadsDetails(List<String> payloadIds) async {
    if (payloadIds.isEmpty) return [];

    // Use Future.wait to fetch all payloads concurrently for better performance.
    final futures = payloadIds.map(
      (id) => _fetchData('payloads/$id', (json) => PayloadModel.fromJson(json)),
    );
    return Future.wait(futures);
  }
}
