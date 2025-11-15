import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/presentation/bloc/filter/filter_state.model.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit() : super(const FilterState());

  void setSortOption(SortOption option) {
    emit(state.copyWith(sortOption: option));
  }

  void setLaunchStatus(LaunchStatus? status) {
    emit(
      state.copyWith(launchStatus: status, resetLaunchStatus: status == null),
    );
  }

  void setYear(int? year) {
    emit(state.copyWith(year: year, resetYear: year == null));
  }

  void setRocket(String? rocketId) {
    emit(state.copyWith(rocketId: rocketId, resetRocket: rocketId == null));
  }

  void setLaunchpad(String? launchpadId) {
    emit(
      state.copyWith(
        launchpadId: launchpadId,
        resetLaunchpad: launchpadId == null,
      ),
    );
  }
}
