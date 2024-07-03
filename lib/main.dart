import 'package:aplikasi_cuaca/cubit/weather_cubit.dart';
import 'package:aplikasi_cuaca/screens/home_screen.dart';
import 'package:aplikasi_cuaca/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => WeatherCubit(WeatherService()),
        child: HomeScreen(),
      ),
    );
  }
}
