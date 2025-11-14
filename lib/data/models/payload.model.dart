import 'package:json_annotation/json_annotation.dart';

part 'payload.model.g.dart';

@JsonSerializable(explicitToJson: true)
class PayloadModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'reused')
  final bool reused;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'customers')
  final List<String> customers;

  @JsonKey(name: 'nationalities')
  final List<String> nationalities;

  @JsonKey(name: 'manufacturers')
  final List<String> manufacturers;

  @JsonKey(name: 'mass_kg')
  final double? massKg;

  @JsonKey(name: 'mass_lbs')
  final double? massLbs;

  @JsonKey(name: 'orbit')
  final String? orbit;

  @JsonKey(name: 'regime')
  final String? regime;

  @JsonKey(name: 'lifespan_years')
  final int? lifespanYears;

  @JsonKey(name: 'periapsis_km')
  final double? periapsisKm;

  @JsonKey(name: 'apoapsis_km')
  final double? apoapsisKm;

  @JsonKey(name: 'inclination_deg')
  final double? inclinationDeg;

  @JsonKey(name: 'dragon')
  final DragonInfoModel dragon;

  PayloadModel({
    required this.id,
    required this.name,
    required this.reused,
    required this.type,
    required this.customers,
    required this.nationalities,
    required this.manufacturers,
    this.massKg,
    this.massLbs,
    this.orbit,
    this.regime,
    this.lifespanYears,
    this.periapsisKm,
    this.apoapsisKm,
    this.inclinationDeg,
    required this.dragon,
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) =>
      _$PayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadModelToJson(this);
}

@JsonSerializable()
class DragonInfoModel {
  @JsonKey(name: 'capsule')
  final String? capsule;

  @JsonKey(name: 'mass_returned_kg')
  final double? massReturnedKg;

  @JsonKey(name: 'flight_time_sec')
  final int? flightTimeSec;

  @JsonKey(name: 'manifest')
  final String? manifest;

  @JsonKey(name: 'water_landing')
  final bool? waterLanding;

  DragonInfoModel({
    this.capsule,
    this.massReturnedKg,
    this.flightTimeSec,
    this.manifest,
    this.waterLanding,
  });

  factory DragonInfoModel.fromJson(Map<String, dynamic> json) =>
      _$DragonInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$DragonInfoModelToJson(this);
}
