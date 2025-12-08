import 'package:flutter/material.dart';

import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  WeatherViewModel(this._repository);

  final WeatherRepository _repository;

  WeatherData? _currentWeather;
  List<City> _favoriteCities = [];
  List<City> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  bool _isFavoritesLoading = false;
  String? _error;

  WeatherData? get currentWeather => _currentWeather;
  List<City> get favoriteCities => _favoriteCities;
  List<City> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  bool get isFavoritesLoading => _isFavoritesLoading;
  String? get error => _error;

  Future<void> initialize() async {
    await loadFavoriteCities();
  }

  Future<void> loadWeatherByCity(String cityName) async {
    _setLoading(true);
    _error = null;
    notifyListeners();
    try {
      _currentWeather = await _repository.getWeatherByCity(cityName);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _currentWeather = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _error = null;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _error = null;
    notifyListeners();

    try {
      _searchResults = await _repository.searchCities(query);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<void> loadFavoriteCities() async {
    _isFavoritesLoading = true;
    notifyListeners();
    try {
      _favoriteCities = await _repository.getFavoriteCities();
    } catch (e) {
      _error = 'Ошибка загрузки избранных: $e';
    } finally {
      _isFavoritesLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFavoriteCity(City city) async {
    await _repository.addFavoriteCity(city);
    await loadFavoriteCities();
  }

  Future<void> addCurrentWeatherToFavorites() async {
    if (_currentWeather == null) return;
    final weather = _currentWeather!;
    final city = City(
      name: weather.cityName,
      country: weather.country,
      lat: weather.lat,
      lon: weather.lon,
    );
    await addFavoriteCity(city);
  }

  Future<void> removeFavoriteCity(City city) async {
    await _repository.removeFavoriteCity(city);
    await loadFavoriteCities();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}