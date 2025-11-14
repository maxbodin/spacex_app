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

  @JsonKey(name: 'cost_per_launch')
  final int costPerLaunch;

  @JsonKey(name: 'success_rate_pct')
  final int successRatePct;

  @JsonKey(name: 'country')
  final String country;

  @JsonKey(name: 'company')
  final String company;

  @JsonKey(name: 'wikipedia')
  final String wikipedia;

  RocketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.active,
    required this.stages,
    required this.costPerLaunch,
    required this.successRatePct,
    required this.country,
    required this.company,
    required this.wikipedia,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) =>
      _$RocketModelFromJson(json);

  Map<String, dynamic> toJson() => _$RocketModelToJson(this);
}
