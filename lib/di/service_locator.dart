import 'package:get_it/get_it.dart';

import '../repositories/weather_repository.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';
import '../viewmodels/weather_viewmodel.dart';

final getIt = GetIt.instance;

void setupLocator(String apiKey) {
  if (getIt.isRegistered<WeatherService>()) {
    return;
  }

  getIt
    ..registerLazySingleton(() => WeatherService(apiKey: apiKey))
    ..registerLazySingleton(() => StorageService())
    ..registerLazySingleton(
      () => WeatherRepository(
        getIt<WeatherService>(),
        getIt<StorageService>(),
      ),
    )
    ..registerFactory(
      () => WeatherViewModel(
        getIt<WeatherRepository>(),
      ),
    );
}

