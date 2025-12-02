import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import './favorites_screen.dart';  
import './search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Загружаем погоду для Москвы при запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<WeatherProvider>(context, listen: false);
      provider.fetchWeatherByCity('Moscow');
    });
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherWise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка: ${provider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.fetchWeatherByCity('Moscow'),
                    child: const Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          final weather = provider.currentWeather;
          if (weather == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Данные о погоде не загружены',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => provider.fetchWeatherByCity('Moscow'),
                    child: const Text('Загрузить погоду'),
                  ),
                ],
              ),
            );
          }

          return _buildWeatherContent(weather, context, provider);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCitySearchDialog(context);
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildWeatherContent(
      WeatherData weather,
      BuildContext context,
      WeatherProvider provider
      ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок с городом
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    weather.cityName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () {
                    provider.fetchWeatherByCity(weather.cityName);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Обновление данных...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Основная информация о погоде
            Center(
              child: Column(
                children: [
                  Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    weather.description,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
                    width: 100,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.cloud, size: 100, color: Colors.grey);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Дополнительные показатели
            const Text(
              'Дополнительные показатели',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherIndicator('Влажность', '${weather.humidity}%', Icons.opacity),
                _buildWeatherIndicator('Ветер', '${weather.windSpeed} м/с', Icons.air),
                _buildWeatherIndicator('Давление', '${weather.pressure} мм', Icons.compress),
              ],
            ),
            const SizedBox(height: 30),

            // Прогноз на 3 дня (заглушка)
            const Text(
              'Прогноз на 3 дня',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildForecastItem('Сегодня', '☀️', '25°C', '18°C'),
                _buildForecastItem('Завтра', '🌧️', '22°C', '16°C'),
                _buildForecastItem('Послезавтра', '⛅', '24°C', '17°C'),
              ],
            ),
            const SizedBox(height: 30),

            // Кнопки действий
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Добавить в избранное'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${weather.cityName} добавлен в избранное'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritesScreen(),
                        ),
                      );
                    },
                    child: const Text('Перейти к избранным'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIndicator(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildForecastItem(String day, String emoji, String high, String low) {
    return Card(
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 24)),
        title: Text(day),
        trailing: Text('$high / $low'),
      ),
    );
  }

  void _showCitySearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Поиск города'),
          content: TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              hintText: 'Введите название города',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final city = _cityController.text.trim();
                if (city.isNotEmpty) {
                  final provider = Provider.of<WeatherProvider>(context, listen: false);
                  provider.fetchWeatherByCity(city);
                  Navigator.pop(context);
                  _cityController.clear();
                }
              },
              child: const Text('Поиск'),
            ),
          ],
        );
      },
    );
  }
}