// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchModel _$LaunchModelFromJson(Map<String, dynamic> json) => LaunchModel(
  id: json['id'] as String,
  name: json['name'] as String,
  flightNumber: (json['flight_number'] as num).toInt(),
  details: json['details'] as String?,
  dateUtc: DateTime.parse(json['date_utc'] as String),
  success: json['success'] as bool?,
  links: LinksModel.fromJson(json['links'] as Map<String, dynamic>),
  failures: (json['failures'] as List<dynamic>)
      .map((e) => FailureModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  rocketId: json['rocket'] as String,
  crew: (json['crew'] as List<dynamic>).map((e) => e as String).toList(),
  ships: (json['ships'] as List<dynamic>).map((e) => e as String).toList(),
  capsules: (json['capsules'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  payloads: (json['payloads'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  launchpad: json['launchpad'] as String,
  cores: (json['cores'] as List<dynamic>)
      .map((e) => CoreModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$LaunchModelToJson(LaunchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'flight_number': instance.flightNumber,
      'details': instance.details,
      'date_utc': instance.dateUtc.toIso8601String(),
      'success': instance.success,
      'links': instance.links.toJson(),
      'failures': instance.failures.map((e) => e.toJson()).toList(),
      'rocket': instance.rocketId,
      'crew': instance.crew,
      'ships': instance.ships,
      'capsules': instance.capsules,
      'payloads': instance.payloads,
      'launchpad': instance.launchpad,
      'cores': instance.cores.map((e) => e.toJson()).toList(),
    };

LinksModel _$LinksModelFromJson(Map<String, dynamic> json) => LinksModel(
  patch: PatchModel.fromJson(json['patch'] as Map<String, dynamic>),
  reddit: RedditModel.fromJson(json['reddit'] as Map<String, dynamic>),
  flickr: FlickrModel.fromJson(json['flickr'] as Map<String, dynamic>),
  webcast: json['webcast'] as String?,
  article: json['article'] as String?,
  wikipedia: json['wikipedia'] as String?,
);

Map<String, dynamic> _$LinksModelToJson(LinksModel instance) =>
    <String, dynamic>{
      'patch': instance.patch.toJson(),
      'reddit': instance.reddit.toJson(),
      'flickr': instance.flickr.toJson(),
      'webcast': instance.webcast,
      'article': instance.article,
      'wikipedia': instance.wikipedia,
    };

PatchModel _$PatchModelFromJson(Map<String, dynamic> json) => PatchModel(
  small: json['small'] as String?,
  large: json['large'] as String?,
);

Map<String, dynamic> _$PatchModelToJson(PatchModel instance) =>
    <String, dynamic>{'small': instance.small, 'large': instance.large};

RedditModel _$RedditModelFromJson(Map<String, dynamic> json) => RedditModel(
  campaign: json['campaign'] as String?,
  launch: json['launch'] as String?,
  media: json['media'] as String?,
  recovery: json['recovery'] as String?,
);

Map<String, dynamic> _$RedditModelToJson(RedditModel instance) =>
    <String, dynamic>{
      'campaign': instance.campaign,
      'launch': instance.launch,
      'media': instance.media,
      'recovery': instance.recovery,
    };

FlickrModel _$FlickrModelFromJson(Map<String, dynamic> json) => FlickrModel(
  small: (json['small'] as List<dynamic>).map((e) => e as String).toList(),
  original: (json['original'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$FlickrModelToJson(FlickrModel instance) =>
    <String, dynamic>{'small': instance.small, 'original': instance.original};

FailureModel _$FailureModelFromJson(Map<String, dynamic> json) =>
    FailureModel(reason: json['reason'] as String);

Map<String, dynamic> _$FailureModelToJson(FailureModel instance) =>
    <String, dynamic>{'reason': instance.reason};

CoreModel _$CoreModelFromJson(Map<String, dynamic> json) => CoreModel(
  core: json['core'] as String?,
  flight: (json['flight'] as num?)?.toInt(),
  gridfins: json['gridfins'] as bool?,
  legs: json['legs'] as bool?,
  reused: json['reused'] as bool?,
  landingAttempt: json['landing_attempt'] as bool?,
  landingSuccess: json['landing_success'] as bool?,
  landingType: json['landing_type'] as String?,
  landpad: json['landpad'] as String?,
);

Map<String, dynamic> _$CoreModelToJson(CoreModel instance) => <String, dynamic>{
  'core': instance.core,
  'flight': instance.flight,
  'gridfins': instance.gridfins,
  'legs': instance.legs,
  'reused': instance.reused,
  'landing_attempt': instance.landingAttempt,
  'landing_success': instance.landingSuccess,
  'landing_type': instance.landingType,
  'landpad': instance.landpad,
};
