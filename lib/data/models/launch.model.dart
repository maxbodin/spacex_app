import 'package:json_annotation/json_annotation.dart';

part 'launch.model.g.dart';

@JsonSerializable(explicitToJson: true)
class LaunchModel {
  @JsonKey(name: 'id')
  final String id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'flight_number')
  final int flightNumber;

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

  @JsonKey(name: 'crew')
  final List<String> crew;

  @JsonKey(name: 'ships')
  final List<String> ships;

  @JsonKey(name: 'capsules')
  final List<String> capsules;

  @JsonKey(name: 'payloads')
  final List<String> payloads;

  @JsonKey(name: 'launchpad')
  final String launchpad;

  @JsonKey(name: 'cores')
  final List<CoreModel> cores;

  LaunchModel({
    required this.id,
    required this.name,
    required this.flightNumber,
    this.details,
    required this.dateUtc,
    this.success,
    required this.links,
    required this.failures,
    required this.rocketId,
    required this.crew,
    required this.ships,
    required this.capsules,
    required this.payloads,
    required this.launchpad,
    required this.cores,
  });

  factory LaunchModel.fromJson(Map<String, dynamic> json) =>
      _$LaunchModelFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LinksModel {
  @JsonKey(name: 'patch')
  final PatchModel patch;

  @JsonKey(name: 'reddit')
  final RedditModel reddit;

  @JsonKey(name: 'flickr')
  final FlickrModel flickr;

  @JsonKey(name: 'webcast')
  final String? webcast;

  @JsonKey(name: 'article')
  final String? article;

  @JsonKey(name: 'wikipedia')
  final String? wikipedia;

  LinksModel({
    required this.patch,
    required this.reddit,
    required this.flickr,
    this.webcast,
    this.article,
    this.wikipedia,
  });

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
class RedditModel {
  @JsonKey(name: 'campaign')
  final String? campaign;

  @JsonKey(name: 'launch')
  final String? launch;

  @JsonKey(name: 'media')
  final String? media;

  @JsonKey(name: 'recovery')
  final String? recovery;

  RedditModel({this.campaign, this.launch, this.media, this.recovery});

  factory RedditModel.fromJson(Map<String, dynamic> json) =>
      _$RedditModelFromJson(json);

  Map<String, dynamic> toJson() => _$RedditModelToJson(this);
}

@JsonSerializable()
class FlickrModel {
  @JsonKey(name: 'small')
  final List<String> small;

  @JsonKey(name: 'original')
  final List<String> original;

  FlickrModel({required this.small, required this.original});

  factory FlickrModel.fromJson(Map<String, dynamic> json) =>
      _$FlickrModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlickrModelToJson(this);
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

@JsonSerializable()
class CoreModel {
  @JsonKey(name: 'core')
  final String? core;

  @JsonKey(name: 'flight')
  final int? flight;

  @JsonKey(name: 'gridfins')
  final bool? gridfins;

  @JsonKey(name: 'legs')
  final bool? legs;

  @JsonKey(name: 'reused')
  final bool? reused;

  @JsonKey(name: 'landing_attempt')
  final bool? landingAttempt;

  @JsonKey(name: 'landing_success')
  final bool? landingSuccess;

  @JsonKey(name: 'landing_type')
  final String? landingType;

  @JsonKey(name: 'landpad')
  final String? landpad;

  CoreModel({
    this.core,
    this.flight,
    this.gridfins,
    this.legs,
    this.reused,
    this.landingAttempt,
    this.landingSuccess,
    this.landingType,
    this.landpad,
  });

  factory CoreModel.fromJson(Map<String, dynamic> json) =>
      _$CoreModelFromJson(json);

  Map<String, dynamic> toJson() => _$CoreModelToJson(this);
}
