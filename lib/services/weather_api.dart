import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:info_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

import '../consts/api_consts.dart';

class WeatherAPiServices with ChangeNotifier {
  static Future<WeatherModel> addWeatherFromLoc(
      {required String latitude, required String longitude}) async {
    try {
      var uri = Uri.https(BASEURLWEATHERURL, 'data/2.5/weather', {
        'lat': latitude,
        'lon': longitude,
        'appid': API_KEY_WEATHER,
        'units': 'metric',
      });
      var response = await http.get(uri);
      Map data = jsonDecode(response.body);

      if (data['code'] != null) {
        throw HttpException(data['code']);
      }

      List weatherTempList = [];
      weatherTempList.add(data);
      List<WeatherModel> weatherModel =
          WeatherModel.weatherFromSnapshot(weatherTempList);

      return weatherModel[0];
    } catch (e) {
      throw e.toString();
    }
  }

  static Future<List<WeatherModel>> getWeatherFromSearchScreen(
      {required String cityName}) async {
    try {
      var uri = Uri.https(BASEURLWEATHERURL, 'data/2.5/weather', {
        'q': cityName,
        'appid': API_KEY_WEATHER,
        'units': 'metric',
      });

      var response = await http.get(uri);

      Map data = jsonDecode(response.body);

      List weatherTempList = [];
      if (data['code'] != null) {
        throw HttpException(data['code']);
      }
      if (data['message'] == 'city not found') {
        throw HttpException(data['message']);
      }
      weatherTempList.add(data);

      return WeatherModel.weatherFromSnapshot(weatherTempList);
    } catch (e) {
      throw e.toString();
    }
  }
}
