import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные города'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          // Список избранных городов
          Expanded(
            child: ListView(
              children: const [
                _FavoriteCityItem(city: 'Москва', temperature: '25°C', condition: '☀️'),
                _FavoriteCityItem(city: 'Санкт-Петербург', temperature: '18°C', condition: '🌧️'),
                _FavoriteCityItem(city: 'Казань', temperature: '22°C', condition: '⛅'),
                _FavoriteCityItem(city: 'Сочи', temperature: '28°C', condition: '☀️'),
              ],
            ),
          ),

          // Кнопка добавления нового города
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location),
              label: const Text('Добавить новый город'),
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCityItem extends StatelessWidget {
  final String city;
  final String temperature;
  final String condition;

  const _FavoriteCityItem({
    required this.city,
    required this.temperature,
    required this.condition,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Text(condition, style: const TextStyle(fontSize: 24)),
        title: Text(
          city,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          temperature,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        onTap: () {},
        onLongPress: () {},
      ),
    );
  }
}