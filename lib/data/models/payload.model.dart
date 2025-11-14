import 'package:json_annotation/json_annotation.dart';

part 'payload.model.g.dart';

@JsonSerializable()
class PayloadModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'reused')
  final bool reused;

  @JsonKey(name: 'customers')
  final List<String> customers;

  @JsonKey(name: 'nationality')
  final String? nationality;

  @JsonKey(name: 'manufacturers')
  final List<String> manufacturers;

  @JsonKey(name: 'type')
  final String? type;

  @JsonKey(name: 'mass_kg')
  final double? massKg;

  @JsonKey(name: 'orbit')
  final String? orbit;

  PayloadModel({
    required this.id,
    required this.name,
    required this.reused,
    required this.customers,
    required this.manufacturers,
    this.nationality,
    this.type,
    this.massKg,
    this.orbit,
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) =>
      _$PayloadModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayloadModelToJson(this);
}
