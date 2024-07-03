// weather_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:aplikasi_cuaca/models/weather_model.dart';
import 'package:aplikasi_cuaca/services/weather_service.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit(this.weatherService) : super(WeatherInitial());

  void fetchWeather() async {
    emit(WeatherLoading());

    try {
      final weather = await weatherService.fetchWeather();
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError("Failed to load weather data: $e"));
    }
  }
}
