import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/data/api/spacex.service.dart';
import 'package:spacex_app/presentation/bloc/data_assets/data_assets_state.dart';

class DataAssetsCubit extends Cubit<DataAssetsState> {
  final SpaceXApiService _apiService;

  DataAssetsCubit({required SpaceXApiService apiService})
    : _apiService = apiService,
      super(DataAssetsInitial());

  Future<void> fetchDataAssets() async {
    try {
      emit(DataAssetsLoading());

      final results = await Future.wait([
        _apiService.getAllRockets(),
        _apiService.getAllLaunchpads(),
      ]);
      emit(
        DataAssetsLoaded(
          rockets: results[0] as dynamic,
          launchpads: results[1] as dynamic,
        ),
      );
    } catch (e) {
      emit(DataAssetsError(message: e.toString()));
    }
  }
}
