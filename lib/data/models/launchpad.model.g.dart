// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launchpad.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchpadModel _$LaunchpadModelFromJson(Map<String, dynamic> json) =>
    LaunchpadModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      status: json['status'] as String,
      details: json['details'] as String,
      locality: json['locality'] as String,
      timezone: json['timezone'] as String,
      region: json['region'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      launchAttempts: (json['launch_attempts'] as num).toInt(),
      launchSuccesses: (json['launch_successes'] as num).toInt(),
      images: LaunchpadImagesModel.fromJson(
        json['images'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$LaunchpadModelToJson(LaunchpadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'full_name': instance.fullName,
      'status': instance.status,
      'details': instance.details,
      'locality': instance.locality,
      'timezone': instance.timezone,
      'region': instance.region,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'launch_attempts': instance.launchAttempts,
      'launch_successes': instance.launchSuccesses,
      'images': instance.images.toJson(),
    };

LaunchpadImagesModel _$LaunchpadImagesModelFromJson(
  Map<String, dynamic> json,
) => LaunchpadImagesModel(
  large: (json['large'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$LaunchpadImagesModelToJson(
  LaunchpadImagesModel instance,
) => <String, dynamic>{'large': instance.large};
