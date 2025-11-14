import 'package:json_annotation/json_annotation.dart';

part 'launchpad.model.g.dart';

@JsonSerializable(explicitToJson: true)
class LaunchpadModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'full_name')
  final String fullName;

  @JsonKey(name: 'status')
  final String status;

  @JsonKey(name: 'details')
  final String details;

  @JsonKey(name: 'locality')
  final String locality;

  @JsonKey(name: 'timezone')
  final String timezone;

  @JsonKey(name: 'region')
  final String region;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'launch_attempts')
  final int launchAttempts;

  @JsonKey(name: 'launch_successes')
  final int launchSuccesses;

  @JsonKey(name: 'images')
  final LaunchpadImagesModel images;

  LaunchpadModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.status,
    required this.details,
    required this.locality,
    required this.timezone,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.launchAttempts,
    required this.launchSuccesses,
    required this.images,
  });

  factory LaunchpadModel.fromJson(Map<String, dynamic> json) =>
      _$LaunchpadModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchpadModelToJson(this);
}

@JsonSerializable()
class LaunchpadImagesModel {
  @JsonKey(name: 'large')
  final List<String> large;

  LaunchpadImagesModel({required this.large});

  factory LaunchpadImagesModel.fromJson(Map<String, dynamic> json) =>
      _$LaunchpadImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchpadImagesModelToJson(this);
}
