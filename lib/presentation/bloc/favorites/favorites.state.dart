import 'package:equatable/equatable.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<String> favoriteIds;

  const FavoritesLoaded({required this.favoriteIds});

  @override
  List<Object> get props => [favoriteIds];
}
