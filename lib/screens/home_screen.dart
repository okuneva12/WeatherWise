import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {  // ← Изменили на StatefulWidget!
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentCity = 'Москва (Авто)';
  String temperature = '25°C';
  String condition = 'Солнечно';

  void _updateCity(String newCity) {
    setState(() {
      currentCity = newCity;
      // Здесь будет запрос к API в ЛР6
    });
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
                  builder: (context) => FavoritesScreen(
                    onCitySelected: _updateCity,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                  Text(
                    currentCity,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 18),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      ).then((selectedCity) {
                        if (selectedCity != null) {
                          _updateCity(selectedCity as String);
                        }
                      });
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
                      temperature,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      condition,
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    const Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
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
                  _buildWeatherIndicator('Влажность', '60%', Icons.opacity),
                  _buildWeatherIndicator('Ветер', '5 м/с', Icons.air),
                  _buildWeatherIndicator('Давление', '760 мм', Icons.compress),
                ],
              ),
              const SizedBox(height: 30),

              // Прогноз на 3 дня
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
                          const SnackBar(
                            content: Text('Город добавлен в избранное'),
                            duration: Duration(seconds: 2),
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
                            builder: (context) => FavoritesScreen(
                              onCitySelected: _updateCity,
                            ),
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
      ),
    );
  }

  // Виджет для показателей погоды
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

  // Виджет для элемента прогноза
  Widget _buildForecastItem(String day, String emoji, String high, String low) {
    return Card(
      child: ListTile(
        leading: Text(emoji, style: const TextStyle(fontSize: 24)),
        title: Text(day),
        trailing: Text('$high / $low'),
      ),
    );
  }
}