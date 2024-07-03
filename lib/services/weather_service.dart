// weather_service.dart
import 'package:dio/dio.dart';
import 'package:aplikasi_cuaca/models/weather_model.dart';

class WeatherService {
  Future<Cuaca> fetchWeather() async {
    final dio = Dio();

    try {
      final response = await dio.get(
          "https://api.weatherapi.com/v1/forecast.json?q=-6.316107%2C106.690166&days=1&key=7e777576beba43359e1163127242203");
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return Cuaca.fromJson(response.data);
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (e) {
      print('asu ${e.toString()}');
      throw Exception("Failed to load weather data: $e");
    }
  }
}
