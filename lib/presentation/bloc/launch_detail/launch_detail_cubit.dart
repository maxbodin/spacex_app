import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/api/spacex.service.dart';
import 'package:spacex_app/data/models/launch.model.dart';
import 'package:spacex_app/presentation/bloc/launch_detail/launch_detail_state.dart';

class LaunchDetailCubit extends Cubit<LaunchDetailState> {
  final SpaceXApiService _apiService;

  LaunchDetailCubit({required SpaceXApiService apiService})
    : _apiService = apiService,
      super(LaunchDetailInitial());

  Future<void> fetchLaunchDetails(LaunchModel launch) async {
    try {
      emit(LaunchDetailLoading());

      final results = await Future.wait([
        _apiService.getRocketDetails(launch.rocketId),
        _apiService.getLaunchpadDetails(launch.launchpad),
        _apiService.getPayloadsDetails(launch.payloads),
      ]);

      emit(
        LaunchDetailLoaded(
          launch: launch,
          rocket: results[0] as dynamic,
          launchpad: results[1] as dynamic,
          payloads: results[2] as dynamic,
        ),
      );
    } catch (e) {
      emit(LaunchDetailError(message: e.toString()));
    }
  }
}
