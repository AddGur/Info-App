import 'package:flutter/material.dart';

class WeatherModel with ChangeNotifier {
  Coord? coord;
  List<Weather>? weather;
  Main? main;
  Sys? sys;
  String? name;
  int? timezone;

  WeatherModel({
    this.weather,
    this.main,
    this.sys,
    this.name,
    this.timezone,
  });

  WeatherModel.fromJson(Map<String, dynamic> json) {
    coord = json['coord'] != null ? Coord.fromJson(json['coord']) : null;
    if (json['weather'] != null) {
      weather = <Weather>[];
      json['weather'].forEach((v) {
        weather!.add(Weather.fromJson(v));
      });
    }
    main = json['main'] != null ? Main.fromJson(json['main']) : null;
    sys = json['sys'] != null ? Sys.fromJson(json['sys']) : null;
    name = json['name'];
    timezone = json['timezone'];
  }

  static List<WeatherModel> weatherFromSnapshot(List weatherSnapshot) {
    return weatherSnapshot.map((json) {
      return WeatherModel.fromJson(json);
    }).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coord != null) {
      data['coord'] = coord!.toJson();
    }
    if (weather != null) {
      data['weather'] = weather!.map((v) => v.toJson()).toList();
    }
    if (main != null) {
      data['main'] = main!.toJson();
    }
    if (sys != null) {
      data['sys'] = sys!.toJson();
    }
    data['name'] = name;
    data['timezone'] = timezone;
    return data;
  }
}

class Weather {
  String? main, description, icon;
  int? id;
  Weather(this.main, this.description, this.icon, this.id);

  Weather.fromJson(Map<String, dynamic> json) {
    main = json['main'];
    description = json['description'];
    icon = json['icon'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['main'] = main;
    data['description'] = description;
    data['icon'] = icon;
    data['id'] = id;
    return data;
  }
}

class Main {
  num? temp, feelsLike, tempMin, tempMax, pressure, humidity;
  Main(this.temp, this.feelsLike, this.tempMin, this.tempMax, this.pressure,
      this.humidity);

  Main.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    feelsLike = json['feels_like'];
    tempMin = json['temp_min'];
    tempMax = json['temp_max'];
    pressure = json['pressure'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['feels_like'] = feelsLike;
    data['temp_min'] = tempMin;
    data['temp_max'] = tempMax;
    data['pressure'] = pressure;
    data['humidity'] = humidity;
    return data;
  }
}

class Sys {
  num? type, id, sunrise, sunset;
  String? country;
  Sys(this.type, this.id, this.sunrise, this.sunset, this.country);

  Sys.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['id'] = id;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['country'] = country;
    return data;
  }
}

class Coord {
  num? lon, lat;
  Coord(this.lon, this.lat);

  Coord.fromJson(Map<String, dynamic> json) {
    lon = json['lon'];
    lat = json['lat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lon'] = lon;
    data['lat'] = lat;
    return data;
  }
}
