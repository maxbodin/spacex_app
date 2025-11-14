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
  boosters: (json['boosters'] as num).toInt(),
  costPerLaunch: (json['cost_per_launch'] as num).toInt(),
  successRatePct: (json['success_rate_pct'] as num).toInt(),
  firstFlight: DateTime.parse(json['first_flight'] as String),
  country: json['country'] as String,
  company: json['company'] as String,
  wikipedia: json['wikipedia'] as String,
  height: DimensionModel.fromJson(json['height'] as Map<String, dynamic>),
  diameter: DimensionModel.fromJson(json['diameter'] as Map<String, dynamic>),
  mass: MassModel.fromJson(json['mass'] as Map<String, dynamic>),
  firstStage: StageModel.fromJson(json['first_stage'] as Map<String, dynamic>),
  secondStage: StageModel.fromJson(
    json['second_stage'] as Map<String, dynamic>,
  ),
  engines: EnginesModel.fromJson(json['engines'] as Map<String, dynamic>),
  landingLegs: LandingLegsModel.fromJson(
    json['landing_legs'] as Map<String, dynamic>,
  ),
  payloadWeights: (json['payload_weights'] as List<dynamic>)
      .map((e) => PayloadWeightModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  flickrImages: (json['flickr_images'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$RocketModelToJson(
  RocketModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'active': instance.active,
  'stages': instance.stages,
  'boosters': instance.boosters,
  'cost_per_launch': instance.costPerLaunch,
  'success_rate_pct': instance.successRatePct,
  'first_flight': instance.firstFlight.toIso8601String(),
  'country': instance.country,
  'company': instance.company,
  'wikipedia': instance.wikipedia,
  'height': instance.height.toJson(),
  'diameter': instance.diameter.toJson(),
  'mass': instance.mass.toJson(),
  'first_stage': instance.firstStage.toJson(),
  'second_stage': instance.secondStage.toJson(),
  'engines': instance.engines.toJson(),
  'landing_legs': instance.landingLegs.toJson(),
  'payload_weights': instance.payloadWeights.map((e) => e.toJson()).toList(),
  'flickr_images': instance.flickrImages,
};

DimensionModel _$DimensionModelFromJson(Map<String, dynamic> json) =>
    DimensionModel(
      meters: (json['meters'] as num?)?.toDouble(),
      feet: (json['feet'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DimensionModelToJson(DimensionModel instance) =>
    <String, dynamic>{'meters': instance.meters, 'feet': instance.feet};

MassModel _$MassModelFromJson(Map<String, dynamic> json) => MassModel(
  kg: (json['kg'] as num?)?.toInt(),
  lb: (json['lb'] as num?)?.toInt(),
);

Map<String, dynamic> _$MassModelToJson(MassModel instance) => <String, dynamic>{
  'kg': instance.kg,
  'lb': instance.lb,
};

ThrustModel _$ThrustModelFromJson(Map<String, dynamic> json) => ThrustModel(
  kN: (json['kN'] as num?)?.toDouble(),
  lbf: (json['lbf'] as num?)?.toInt(),
);

Map<String, dynamic> _$ThrustModelToJson(ThrustModel instance) =>
    <String, dynamic>{'kN': instance.kN, 'lbf': instance.lbf};

StageModel _$StageModelFromJson(Map<String, dynamic> json) => StageModel(
  reusable: json['reusable'] as bool,
  engines: (json['engines'] as num).toInt(),
  fuelAmountTons: (json['fuel_amount_tons'] as num).toDouble(),
  burnTimeSec: (json['burn_time_sec'] as num?)?.toInt(),
  thrustSeaLevel: json['thrust_sea_level'] == null
      ? null
      : ThrustModel.fromJson(json['thrust_sea_level'] as Map<String, dynamic>),
  thrustVacuum: json['thrust_vacuum'] == null
      ? null
      : ThrustModel.fromJson(json['thrust_vacuum'] as Map<String, dynamic>),
  thrust: json['thrust'] == null
      ? null
      : ThrustModel.fromJson(json['thrust'] as Map<String, dynamic>),
);

Map<String, dynamic> _$StageModelToJson(StageModel instance) =>
    <String, dynamic>{
      'reusable': instance.reusable,
      'engines': instance.engines,
      'fuel_amount_tons': instance.fuelAmountTons,
      'burn_time_sec': instance.burnTimeSec,
      'thrust_sea_level': instance.thrustSeaLevel?.toJson(),
      'thrust_vacuum': instance.thrustVacuum?.toJson(),
      'thrust': instance.thrust?.toJson(),
    };

EnginesModel _$EnginesModelFromJson(Map<String, dynamic> json) => EnginesModel(
  number: (json['number'] as num).toInt(),
  type: json['type'] as String,
  version: json['version'] as String,
  layout: json['layout'] as String?,
  propellant1: json['propellant_1'] as String,
  propellant2: json['propellant_2'] as String,
  thrustToWeight: (json['thrust_to_weight'] as num?)?.toDouble(),
);

Map<String, dynamic> _$EnginesModelToJson(EnginesModel instance) =>
    <String, dynamic>{
      'number': instance.number,
      'type': instance.type,
      'version': instance.version,
      'layout': instance.layout,
      'propellant_1': instance.propellant1,
      'propellant_2': instance.propellant2,
      'thrust_to_weight': instance.thrustToWeight,
    };

LandingLegsModel _$LandingLegsModelFromJson(Map<String, dynamic> json) =>
    LandingLegsModel(
      number: (json['number'] as num).toInt(),
      material: json['material'] as String?,
    );

Map<String, dynamic> _$LandingLegsModelToJson(LandingLegsModel instance) =>
    <String, dynamic>{'number': instance.number, 'material': instance.material};

PayloadWeightModel _$PayloadWeightModelFromJson(Map<String, dynamic> json) =>
    PayloadWeightModel(
      id: json['id'] as String,
      name: json['name'] as String,
      kg: (json['kg'] as num).toInt(),
      lb: (json['lb'] as num).toInt(),
    );

Map<String, dynamic> _$PayloadWeightModelToJson(PayloadWeightModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kg': instance.kg,
      'lb': instance.lb,
    };
