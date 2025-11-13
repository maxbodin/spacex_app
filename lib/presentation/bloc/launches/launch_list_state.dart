import 'package:equatable/equatable.dart';
import 'package:spacex_app/data/models/launch_model.dart';

abstract class LaunchListState extends Equatable {
  const LaunchListState();

  @override
  List<Object> get props => [];
}

class LaunchListInitial extends LaunchListState {}

class LaunchListLoading extends LaunchListState {}

class LaunchListLoaded extends LaunchListState {
  final List<LaunchModel> launches;
  final bool isGridView;

  const LaunchListLoaded({required this.launches, this.isGridView = false});

  LaunchListLoaded copyWith({List<LaunchModel>? launches, bool? isGridView}) {
    return LaunchListLoaded(
      launches: launches ?? this.launches,
      isGridView: isGridView ?? this.isGridView,
    );
  }

  @override
  List<Object> get props => [launches, isGridView];
}

class LaunchListError extends LaunchListState {
  final String message;

  const LaunchListError({required this.message});

  @override
  List<Object> get props => [message];
}
