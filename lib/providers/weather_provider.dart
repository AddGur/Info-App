import 'package:flutter/cupertino.dart';
import 'package:info_app/models/weather_model.dart';
import 'package:info_app/services/weather_api.dart';

class WeatherProvider with ChangeNotifier {
  List<WeatherModel> weatherList = [];

  List<WeatherModel> get getWeatherModel {
    return weatherList;
  }

  Future<List<WeatherModel>> fetchWeather() async {
    return weatherList;
  }

  Future<void> addWeatcherFromLoc({
    required String latitude,
    required String longitude,
  }) async {
    weatherList.add(await WeatherAPiServices.addWeatherFromLoc(
        latitude: latitude, longitude: longitude));
  }
}
