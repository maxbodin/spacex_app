import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  static const _favoritesKey = 'favoriteLaunches';

  FavoritesCubit() : super(FavoritesInitial());

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    emit(FavoritesLoaded(favoriteIds: List.from(favoriteIds)));
  }

  Future<void> toggleFavorite(String launchId) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      final currentFavorites = List<String>.from(currentState.favoriteIds);

      if (currentFavorites.contains(launchId)) {
        currentFavorites.remove(launchId);
      } else {
        currentFavorites.add(launchId);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_favoritesKey, currentFavorites);
      emit(FavoritesLoaded(favoriteIds: currentFavorites));
    }
  }
}
