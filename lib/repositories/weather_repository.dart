import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  WeatherRepository(
    this._weatherService,
    this._storageService,
  );

  final WeatherService _weatherService;
  final StorageService _storageService;

  Future<WeatherData> getWeatherByCity(String cityName) {
    return _weatherService.getWeatherByCity(cityName);
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) {
    return _weatherService.getWeatherByLocation(lat, lon);
  }

  Future<List<City>> searchCities(String query) {
    return _weatherService.searchCities(query);
  }

  Future<List<City>> getFavoriteCities() {
    return _storageService.loadFavoriteCities();
  }

  Future<void> addFavoriteCity(City city) async {
    final favorites = await _storageService.loadFavoriteCities();
    final exists = favorites.any(
      (c) => c.name == city.name && c.country == city.country,
    );
    if (!exists) {
      favorites.add(city);
      await _storageService.saveFavoriteCities(favorites);
    }
  }

  Future<void> removeFavoriteCity(City city) async {
    final favorites = await _storageService.loadFavoriteCities();
    favorites.removeWhere(
      (c) => c.name == city.name && c.country == city.country,
    );
    await _storageService.saveFavoriteCities(favorites);
  }
}

