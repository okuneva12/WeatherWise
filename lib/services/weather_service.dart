import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'YOUR_API_KEY'; // Замени на свой ключ
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getWeatherByCity(String cityName) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$cityName&units=metric&lang=ru&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&lang=ru&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<City>> searchCities(String query) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => City.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search cities');
    }
  }
}