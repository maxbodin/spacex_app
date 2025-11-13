// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchModel _$LaunchModelFromJson(Map<String, dynamic> json) => LaunchModel(
  id: json['id'] as String,
  name: json['name'] as String,
  details: json['details'] as String?,
  dateUtc: DateTime.parse(json['date_utc'] as String),
  success: json['success'] as bool?,
  links: LinksModel.fromJson(json['links'] as Map<String, dynamic>),
  failures: (json['failures'] as List<dynamic>)
      .map((e) => FailureModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  rocketId: json['rocket'] as String,
);

Map<String, dynamic> _$LaunchModelToJson(LaunchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'date_utc': instance.dateUtc.toIso8601String(),
      'success': instance.success,
      'links': instance.links,
      'failures': instance.failures,
      'rocket': instance.rocketId,
    };

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) => LinksModel(
  patch: PatchModel.fromJson(json['patch'] as Map<String, dynamic>),
  article: json['article'] as String?,
);

Map<String, dynamic> _$LinksModelToJson(LinksModel instance) =>
    <String, dynamic>{'patch': instance.patch, 'article': instance.article};

PatchModel _$PatchModelFromJson(Map<String, dynamic> json) => PatchModel(
  small: json['small'] as String?,
  large: json['large'] as String?,
);

Map<String, dynamic> _$PatchModelToJson(PatchModel instance) =>
    <String, dynamic>{'small': instance.small, 'large': instance.large};

FailureModel _$FailureModelFromJson(Map<String, dynamic> json) =>
    FailureModel(reason: json['reason'] as String);

Map<String, dynamic> _$FailureModelToJson(FailureModel instance) =>
    <String, dynamic>{'reason': instance.reason};
