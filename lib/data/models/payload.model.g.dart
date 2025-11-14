// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayloadModel _$PayloadModelFromJson(Map<String, dynamic> json) => PayloadModel(
  id: json['id'] as String,
  name: json['name'] as String,
  reused: json['reused'] as bool,
  customers: (json['customers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  manufacturers: (json['manufacturers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  nationality: json['nationality'] as String?,
  type: json['type'] as String?,
  massKg: (json['mass_kg'] as num?)?.toDouble(),
  orbit: json['orbit'] as String?,
);

Map<String, dynamic> _$PayloadModelToJson(PayloadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reused': instance.reused,
      'customers': instance.customers,
      'nationality': instance.nationality,
      'manufacturers': instance.manufacturers,
      'type': instance.type,
      'mass_kg': instance.massKg,
      'orbit': instance.orbit,
    };
