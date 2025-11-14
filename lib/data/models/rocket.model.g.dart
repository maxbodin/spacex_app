// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rocket.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RocketModel _$RocketModelFromJson(Map<String, dynamic> json) => RocketModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  active: json['active'] as bool,
  stages: (json['stages'] as num).toInt(),
  costPerLaunch: (json['cost_per_launch'] as num).toInt(),
  successRatePct: (json['success_rate_pct'] as num).toInt(),
  country: json['country'] as String,
  company: json['company'] as String,
  wikipedia: json['wikipedia'] as String,
);

Map<String, dynamic> _$RocketModelToJson(RocketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'active': instance.active,
      'stages': instance.stages,
      'cost_per_launch': instance.costPerLaunch,
      'success_rate_pct': instance.successRatePct,
      'country': instance.country,
      'company': instance.company,
      'wikipedia': instance.wikipedia,
    };
