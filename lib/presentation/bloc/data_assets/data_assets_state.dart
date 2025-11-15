import 'package:equatable/equatable.dart';
import 'package:spacex_app/data/models/launchpad.model.dart';
import 'package:spacex_app/data/models/rocket.model.dart';

abstract class DataAssetsState extends Equatable {
  const DataAssetsState();

  @override
  List<Object> get props => [];
}

class DataAssetsInitial extends DataAssetsState {}

class DataAssetsLoading extends DataAssetsState {}

class DataAssetsLoaded extends DataAssetsState {
  final List<RocketModel> rockets;
  final List<LaunchpadModel> launchpads;

  const DataAssetsLoaded({required this.rockets, required this.launchpads});

  @override
  List<Object> get props => [rockets, launchpads];
}

class DataAssetsError extends DataAssetsState {
  final String message;

  const DataAssetsError({required this.message});

  @override
  List<Object> get props => [message];
}
