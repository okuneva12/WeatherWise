import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/weather_model.dart';
import '../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
        child: Consumer<WeatherViewModel>(
          builder: (context, viewModel, _) {
            return Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Введите название города...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onSubmitted: (_) => _performSearch(viewModel),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.isSearching ? null : () => _performSearch(viewModel),
                    child: viewModel.isSearching
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Найти'),
                  ),
                ),
                if (viewModel.error != null && !viewModel.isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.error!,
                              style: TextStyle(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Expanded(
                  child: viewModel.isSearching
                      ? const Center(child: CircularProgressIndicator())
                      : viewModel.error != null && viewModel.searchResults.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text(
                                    'Не удалось найти города',
                                    style: TextStyle(fontSize: 18, color: Colors.grey),
                                  ),
                                ],
                              ),
                            )
                          : viewModel.searchResults.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Введите запрос для поиска города',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: viewModel.searchResults.length,
                                  itemBuilder: (context, index) {
                                    final City city = viewModel.searchResults[index];
                                    return Card(
                                      child: ListTile(
                                        leading: const Icon(Icons.location_city, color: Colors.blue),
                                        title: Text('${city.name}, ${city.country}'),
                                        subtitle: Text('Координаты: ${city.lat.toStringAsFixed(2)}, ${city.lon.toStringAsFixed(2)}'),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.add, color: Colors.green),
                                          onPressed: () async {
                                            await viewModel.addFavoriteCity(city);
                                            if (mounted && context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Город ${city.name} добавлен в избранное'),
                                                  duration: const Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                onTap: () {
                                  if (context.mounted) {
                                    Navigator.pop(context, city);
                                  }
                                },
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _performSearch(WeatherViewModel viewModel) {
    final query = _controller.text.trim();
    viewModel.searchCities(query);
  }
}