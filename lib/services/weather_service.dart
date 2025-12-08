import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_model.dart';

class WeatherService {
  WeatherService({required String apiKey}) : _apiKey = apiKey;

  final String _apiKey;
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getWeatherByCity(String cityName) async {
    try {
      final encodedCityName = Uri.encodeComponent(cityName);
      final uri = Uri.parse('$_baseUrl/weather?q=$encodedCityName&units=metric&lang=ru&appid=$_apiKey');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Превышено время ожидания запроса. Проверьте подключение к интернету.');
        },
      );

      if (response.statusCode == 200) {
        try {
          return WeatherData.fromJson(json.decode(response.body) as Map<String, dynamic>);
        } catch (e) {
          throw Exception('Ошибка обработки данных: $e');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Город "$cityName" не найден');
      } else {
        try {
          final errorBody = json.decode(response.body) as Map<String, dynamic>?;
          final errorMessage = errorBody?['message'] ?? 'Неизвестная ошибка';
          throw Exception('Ошибка загрузки погоды (${response.statusCode}): $errorMessage');
        } catch (e) {
          throw Exception('Ошибка загрузки погоды (${response.statusCode})');
        }
      }
    } catch (e) {
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw Exception('Нет подключения к интернету');
      }
      rethrow;
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    try {
      final uri = Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&units=metric&lang=ru&appid=$_apiKey');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Превышено время ожидания запроса. Проверьте подключение к интернету.');
        },
      );

      if (response.statusCode == 200) {
        try {
          return WeatherData.fromJson(json.decode(response.body) as Map<String, dynamic>);
        } catch (e) {
          throw Exception('Ошибка обработки данных: $e');
        }
      } else {
        try {
          final errorBody = json.decode(response.body) as Map<String, dynamic>?;
          final errorMessage = errorBody?['message'] ?? 'Неизвестная ошибка';
          throw Exception('Ошибка загрузки погоды (${response.statusCode}): $errorMessage');
        } catch (e) {
          throw Exception('Ошибка загрузки погоды (${response.statusCode})');
        }
      }
    } catch (e) {
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw Exception('Нет подключения к интернету');
      }
      rethrow;
    }
  }

  Future<List<City>> searchCities(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final uri = Uri.parse('https://api.openweathermap.org/geo/1.0/direct?q=$encodedQuery&limit=5&appid=$_apiKey');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Превышено время ожидания запроса. Проверьте подключение к интернету.');
        },
      );

      if (response.statusCode == 200) {
        try {
          final List<dynamic> data = json.decode(response.body) as List<dynamic>;
          return data.map((json) => City.fromJson(json as Map<String, dynamic>)).toList();
        } catch (e) {
          throw Exception('Ошибка обработки данных: $e');
        }
      } else {
        try {
          final errorBody = json.decode(response.body) as Map<String, dynamic>?;
          final errorMessage = errorBody?['message'] ?? 'Неизвестная ошибка';
          throw Exception('Ошибка поиска городов (${response.statusCode}): $errorMessage');
        } catch (e) {
          throw Exception('Ошибка поиска городов (${response.statusCode})');
        }
      }
    } catch (e) {
      if (e.toString().contains('timeout') || e.toString().contains('SocketException')) {
        throw Exception('Нет подключения к интернету');
      }
      rethrow;
    }
  }
}