import 'package:json_annotation/json_annotation.dart';

part 'launch_model.g.dart';

@JsonSerializable()
class LaunchModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'details')
  final String? details;

  @JsonKey(name: 'date_utc')
  final DateTime dateUtc;

  @JsonKey(name: 'success')
  final bool? success;

  @JsonKey(name: 'links')
  final LinksModel links;

  @JsonKey(name: 'failures')
  final List<FailureModel> failures;

  @JsonKey(name: 'rocket')
  final String rocketId;

  LaunchModel({
    required this.id,
    required this.name,
    this.details,
    required this.dateUtc,
    this.success,
    required this.links,
    required this.failures,
    required this.rocketId,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) =>
      _$LaunchModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchModelToJson(this);
}

@JsonSerializable()
class LinksModel {
  @JsonKey(name: 'patch')
  final PatchModel patch;

  @JsonKey(name: 'article')
  final String? article;

  LinksModel({required this.patch, this.article});

  factory LinksModel.fromJson(Map<String, dynamic> json) =>
      _$LinksModelFromJson(json);

  Map<String, dynamic> toJson() => _$LinksModelToJson(this);
}

@JsonSerializable()
class PatchModel {
  @JsonKey(name: 'small')
  final String? small;

  @JsonKey(name: 'large')
  final String? large;

  PatchModel({this.small, this.large});

  factory PatchModel.fromJson(Map<String, dynamic> json) =>
      _$PatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$PatchModelToJson(this);
}

@JsonSerializable()
class FailureModel {
  @JsonKey(name: 'reason')
  final String reason;

  FailureModel({required this.reason});

  factory FailureModel.fromJson(Map<String, dynamic> json) =>
      _$FailureModelFromJson(json);

  Map<String, dynamic> toJson() => _$FailureModelToJson(this);
}
