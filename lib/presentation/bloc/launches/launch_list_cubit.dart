import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/datasources/spacex_api_service.dart';

import 'launch_list_state.dart';

class LaunchListCubit extends Cubit<LaunchListState> {
  final SpaceXApiService apiService;

  LaunchListCubit({required this.apiService}) : super(LaunchListInitial());

  Future<void> fetchLaunches() async {
    try {
      emit(LaunchListLoading());
      final launches = await apiService.getLatestLaunches();
      emit(LaunchListLoaded(launches: launches));
    } catch (e) {
      emit(LaunchListError(message: e.toString()));
    }
  }

  void toggleView() {
    if (state is LaunchListLoaded) {
      final currentState = state as LaunchListLoaded;
      emit(currentState.copyWith(isGridView: !currentState.isGridView));
    }
  }
}
