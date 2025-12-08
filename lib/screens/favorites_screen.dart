import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'search_screen.dart';

class FavoritesScreen extends StatefulWidget {
  final Function(String)? onCitySelected;

  const FavoritesScreen({super.key, this.onCitySelected});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().loadFavoriteCities();
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
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isFavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final favorites = viewModel.favoriteCities;
          if (favorites.isEmpty) {
            return const Center(
              child: Text('Избранных городов пока нет'),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final City city = favorites[index];
                    return Dismissible(
                      key: Key('${city.name}_${city.country}'),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => _removeCity(viewModel, city),
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.location_city, color: Colors.blue),
                          title: Text(
                            '${city.name}, ${city.country}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            if (widget.onCitySelected != null) {
                              widget.onCitySelected!(city.name);
                            }
                            await context.read<WeatherViewModel>().loadWeatherByCity(city.name);
                            if (mounted && context.mounted) {
                              Navigator.pop(context, city);
                            }
                          },
                          onLongPress: () => _confirmDelete(viewModel, city),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_location),
                  label: const Text('Добавить новый город'),
                  onPressed: () async {
                    final city = await Navigator.push<City?>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchScreen(),
                      ),
                    );
                    if (city != null) {
                      await viewModel.addFavoriteCity(city);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeCity(WeatherViewModel viewModel, City city) async {
    await viewModel.removeFavoriteCity(city);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Город ${city.name} удалён из избранного'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _confirmDelete(WeatherViewModel viewModel, City city) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить город?'),
        content: Text('Вы действительно хотите удалить ${city.name} из избранного?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _removeCity(viewModel, city);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}