import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spacex_app/data/models/launch_model.dart';

abstract class SpaceXApiService {
  Future<List<LaunchModel>> getLatestLaunches();
}

class SpaceXApiServiceImpl implements SpaceXApiService {
  final http.Client client;
  final String _baseUrl = "https://api.spacexdata.com/v4";

  SpaceXApiServiceImpl({required this.client});

  @override
  Future<List<LaunchModel>> getLatestLaunches() async {
    final response = await client.get(Uri.parse('$_baseUrl/launches'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => LaunchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load launches');
    }
  }
}
