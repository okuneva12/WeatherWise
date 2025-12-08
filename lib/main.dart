import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'di/service_locator.dart';
import 'screens/home_screen.dart';
import 'viewmodels/weather_viewmodel.dart';

const String _openWeatherApiKey = '23bbfa9edfde150ae45694cdd3c25c99';

void main() {
  setupLocator(_openWeatherApiKey);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<WeatherViewModel>()..initialize(),
      child: MaterialApp(
        title: 'WeatherWise',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}