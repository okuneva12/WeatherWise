import 'package:flutter/material.dart';
import 'search_screen.dart'; // ← ВАЖНО: этот импорт должен быть

class FavoritesScreen extends StatefulWidget {
  final Function(String)? onCitySelected;

  const FavoritesScreen({super.key, this.onCitySelected});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, String>> favoriteCities = [
    {'city': 'Москва', 'temperature': '25°C', 'condition': '☀️'},
    {'city': 'Санкт-Петербург', 'temperature': '18°C', 'condition': '🌧️'},
    {'city': 'Казань', 'temperature': '22°C', 'condition': '⛅'},
    {'city': 'Сочи', 'temperature': '28°C', 'condition': '☀️'},
  ];

  void _removeCity(int index) {
    setState(() {
      final removedCity = favoriteCities[index]['city'];
      favoriteCities.removeAt(index);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Город $removedCity удалён из избранного'),
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные города'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Список избранных городов
          Expanded(
            child: ListView.builder(
              itemCount: favoriteCities.length,
              itemBuilder: (context, index) {
                final city = favoriteCities[index];
                return Dismissible(
                  key: Key(city['city']!),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _removeCity(index),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Text(city['condition']!, style: const TextStyle(fontSize: 24)),
                      title: Text(
                        city['city']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        city['temperature']!,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        if (widget.onCitySelected != null) {
                          widget.onCitySelected!(city['city']!);
                        }
                        Navigator.pop(context);
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Удалить город?'),
                            content: Text('Вы действительно хотите удалить ${city['city']} из избранного?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _removeCity(index);
                                  Navigator.pop(context);
                                },
                                child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Кнопка добавления нового города
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_location),
              label: const Text('Добавить новый город'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
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