import 'package:equatable/equatable.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/data/models/launchpad.model.dart';
import 'package:spacex_app/data/models/payload.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

abstract class LaunchDetailState extends Equatable {
  const LaunchDetailState();

  @override
  List<Object?> get props => [];
}

class LaunchDetailInitial extends LaunchDetailState {}

class LaunchDetailLoading extends LaunchDetailState {}

class LaunchDetailLoaded extends LaunchDetailState {
  final LaunchModel launch;
  final RocketModel rocket;
  final LaunchpadModel launchpad;
  final List<PayloadModel> payloads;

  const LaunchDetailLoaded({
    required this.launch,
    required this.rocket,
    required this.launchpad,
    required this.payloads,
  });

  @override
  List<Object?> get props => [launch, rocket, launchpad, payloads];
}

class LaunchDetailError extends LaunchDetailState {
  final String message;

  const LaunchDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
