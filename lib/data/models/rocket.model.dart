import 'package:json_annotation/json_annotation.dart';

part 'rocket.model.g.dart';

@JsonSerializable(explicitToJson: true)
class RocketModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'description')
  final String description;

  @JsonKey(name: 'active')
  final bool active;

  @JsonKey(name: 'stages')
  final int stages;

  @JsonKey(name: 'boosters')
  final int boosters;

  @JsonKey(name: 'cost_per_launch')
  final int costPerLaunch;

  @JsonKey(name: 'success_rate_pct')
  final int successRatePct;

  @JsonKey(name: 'first_flight')
  final DateTime firstFlight;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'company')
  final String company;

  @JsonKey(name: 'wikipedia')
  final String wikipedia;

  @JsonKey(name: 'height')
  final DimensionModel height;

  @JsonKey(name: 'diameter')
  final DimensionModel diameter;

  @JsonKey(name: 'mass')
  final MassModel mass;

  @JsonKey(name: 'first_stage')
  final StageModel firstStage;

  @JsonKey(name: 'second_stage')
  final StageModel secondStage;

  @JsonKey(name: 'engines')
  final EnginesModel engines;

  @JsonKey(name: 'landing_legs')
  final LandingLegsModel landingLegs;

  @JsonKey(name: 'payload_weights')
  final List<PayloadWeightModel> payloadWeights;

  @JsonKey(name: 'flickr_images')
  final List<String> flickrImages;

  RocketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.stages,
    required this.boosters,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.firstFlight,
    required this.country,
    required this.company,
    required this.wikipedia,
    required this.height,
    required this.diameter,
    required this.mass,
    required this.firstStage,
    required this.secondStage,
    required this.engines,
    required this.landingLegs,
    required this.payloadWeights,
    required this.flickrImages,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) =>
      _$RocketModelFromJson(json);

  Map<String, dynamic> toJson() => _$RocketModelToJson(this);
}

@JsonSerializable()
class DimensionModel {
  @JsonKey(name: 'meters')
  final double? meters;
  @JsonKey(name: 'feet')
  final double? feet;

  DimensionModel({this.meters, this.feet});

  factory DimensionModel.fromJson(Map<String, dynamic> json) =>
      _$DimensionModelFromJson(json);

  Map<String, dynamic> toJson() => _$DimensionModelToJson(this);
}

@JsonSerializable()
class MassModel {
  @JsonKey(name: 'kg')
  final int? kg;
  @JsonKey(name: 'lb')
  final int? lb;

  MassModel({this.kg, this.lb});

  factory MassModel.fromJson(Map<String, dynamic> json) =>
      _$MassModelFromJson(json);

  Map<String, dynamic> toJson() => _$MassModelToJson(this);
}

@JsonSerializable()
class ThrustModel {
  @JsonKey(name: 'kN')
  final double? kN;
  @JsonKey(name: 'lbf')
  final int? lbf;

  ThrustModel({this.kN, this.lbf});

  factory ThrustModel.fromJson(Map<String, dynamic> json) =>
      _$ThrustModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThrustModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class StageModel {
  @JsonKey(name: 'reusable')
  final bool reusable;
  @JsonKey(name: 'engines')
  final int engines;
  @JsonKey(name: 'fuel_amount_tons')
  final double fuelAmountTons;
  @JsonKey(name: 'burn_time_sec')
  final int? burnTimeSec;
  @JsonKey(name: 'thrust_sea_level')
  final ThrustModel? thrustSeaLevel;
  @JsonKey(name: 'thrust_vacuum')
  final ThrustModel? thrustVacuum;
  @JsonKey(name: 'thrust')
  final ThrustModel? thrust;

  StageModel({
    required this.reusable,
    required this.engines,
    required this.fuelAmountTons,
    this.burnTimeSec,
    this.thrustSeaLevel,
    this.thrustVacuum,
    this.thrust,
  });

  factory StageModel.fromJson(Map<String, dynamic> json) =>
      _$StageModelFromJson(json);

  Map<String, dynamic> toJson() => _$StageModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class EnginesModel {
  @JsonKey(name: 'number')
  final int number;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'version')
  final String version;
  @JsonKey(name: 'layout')
  final String? layout;
  @JsonKey(name: 'propellant_1')
  final String propellant1;
  @JsonKey(name: 'propellant_2')
  final String propellant2;
  @JsonKey(name: 'thrust_to_weight')
  final double? thrustToWeight;

  EnginesModel({
    required this.number,
    required this.type,
    required this.version,
    this.layout,
    required this.propellant1,
    required this.propellant2,
    this.thrustToWeight,
  });

  factory EnginesModel.fromJson(Map<String, dynamic> json) =>
      _$EnginesModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnginesModelToJson(this);
}

@JsonSerializable()
class LandingLegsModel {
  @JsonKey(name: 'number')
  final int number;
  @JsonKey(name: 'material')
  final String? material;

  LandingLegsModel({required this.number, this.material});

  factory LandingLegsModel.fromJson(Map<String, dynamic> json) =>
      _$LandingLegsModelFromJson(json);

  Map<String, dynamic> toJson() => _$LandingLegsModelToJson(this);
}

@JsonSerializable()
class PayloadWeightModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'kg')
  final int kg;
  @JsonKey(name: 'lb')
  final int lb;

  PayloadWeightModel({
    required this.id,
    required this.name,
    required this.kg,
    required this.lb,
  });

  factory PayloadWeightModel.fromJson(Map<String, dynamic> json) =>
      _$PayloadWeightModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadWeightModelToJson(this);
}
