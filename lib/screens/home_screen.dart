import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherWise'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Навигация будет в ЛР5
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
              const Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Москва (Авто)',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Основная информация о погоде
              Center(
                child: Column(
                  children: [
                    const Text(
                      '25°C',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Text(
                      'Солнечно',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    Icon(Icons.wb_sunny, size: 100, color: Colors.orange),
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
                      onPressed: () {},
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
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