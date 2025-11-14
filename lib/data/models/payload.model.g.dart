// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PayloadModel _$PayloadModelFromJson(Map<String, dynamic> json) => PayloadModel(
  id: json['id'] as String,
  name: json['name'] as String,
  reused: json['reused'] as bool,
  type: json['type'] as String?,
  customers: (json['customers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  nationalities: (json['nationalities'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  manufacturers: (json['manufacturers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  massKg: (json['mass_kg'] as num?)?.toDouble(),
  massLbs: (json['mass_lbs'] as num?)?.toDouble(),
  orbit: json['orbit'] as String?,
  regime: json['regime'] as String?,
  lifespanYears: (json['lifespan_years'] as num?)?.toInt(),
  periapsisKm: (json['periapsis_km'] as num?)?.toDouble(),
  apoapsisKm: (json['apoapsis_km'] as num?)?.toDouble(),
  inclinationDeg: (json['inclination_deg'] as num?)?.toDouble(),
  dragon: DragonInfoModel.fromJson(json['dragon'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PayloadModelToJson(PayloadModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'reused': instance.reused,
      'type': instance.type,
      'customers': instance.customers,
      'nationalities': instance.nationalities,
      'manufacturers': instance.manufacturers,
      'mass_kg': instance.massKg,
      'mass_lbs': instance.massLbs,
      'orbit': instance.orbit,
      'regime': instance.regime,
      'lifespan_years': instance.lifespanYears,
      'periapsis_km': instance.periapsisKm,
      'apoapsis_km': instance.apoapsisKm,
      'inclination_deg': instance.inclinationDeg,
      'dragon': instance.dragon.toJson(),
    };

DragonInfoModel _$DragonInfoModelFromJson(Map<String, dynamic> json) =>
    DragonInfoModel(
      capsule: json['capsule'] as String?,
      massReturnedKg: (json['mass_returned_kg'] as num?)?.toDouble(),
      flightTimeSec: (json['flight_time_sec'] as num?)?.toInt(),
      manifest: json['manifest'] as String?,
      waterLanding: json['water_landing'] as bool?,
    );

Map<String, dynamic> _$DragonInfoModelToJson(DragonInfoModel instance) =>
    <String, dynamic>{
      'capsule': instance.capsule,
      'mass_returned_kg': instance.massReturnedKg,
      'flight_time_sec': instance.flightTimeSec,
      'manifest': instance.manifest,
      'water_landing': instance.waterLanding,
    };
