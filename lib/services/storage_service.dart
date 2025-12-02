import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_cities';

  Future<void> saveFavoriteCities(List<City> cities) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = cities.map((city) => city.toJson()).toList();
    await prefs.setString(_favoritesKey, json.encode(jsonList));
  }

  Future<List<City>> loadFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_favoritesKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => City.fromJson(json)).toList();
    }

    return [];
  }

  Future<void> addFavoriteCity(City city) async {
    final cities = await loadFavoriteCities();
    cities.add(city);
    await saveFavoriteCities(cities);
  }

  Future<void> removeFavoriteCity(City city) async {
    final cities = await loadFavoriteCities();
    cities.removeWhere((c) => c.name == city.name && c.country == city.country);
    await saveFavoriteCities(cities);
  }
}