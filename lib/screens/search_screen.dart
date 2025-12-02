import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск города'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Поле поиска
            TextField(
              decoration: InputDecoration(
                hintText: 'Введите название города...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                // Поиск будет в ЛР6
              },
            ),
            const SizedBox(height: 20),

            // Кнопка поиска
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Поиск будет в ЛР6
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Поиск города... (функция в ЛР6)'),
                    ),
                  );
                },
                child: const Text('Найти'),
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              'Примеры городов:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Список примеров городов
            Expanded(
              child: ListView(
                children: const [
                  _CityResultItem(city: 'Москва', country: 'Россия'),
                  _CityResultItem(city: 'Санкт-Петербург', country: 'Россия'),
                  _CityResultItem(city: 'Казань', country: 'Россия'),
                  _CityResultItem(city: 'Сочи', country: 'Россия'),
                  _CityResultItem(city: 'Лондон', country: 'Великобритания'),
                  _CityResultItem(city: 'Париж', country: 'Франция'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityResultItem extends StatelessWidget {
  final String city;
  final String country;

  const _CityResultItem({
    required this.city,
    required this.country,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.location_city, color: Colors.blue),
        title: Text(city),
        subtitle: Text(country),
        trailing: IconButton(
          icon: const Icon(Icons.add, color: Colors.green),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Город $city добавлен в избранное'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
        onTap: () {
          Navigator.pop(context, city); // Возвращаем выбранный город
        },
      ),
    );
  }
}