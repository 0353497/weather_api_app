import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_api_app/models/small_weather.dart';
import 'package:weather_api_app/models/weather.dart';

class WeatherService {
  static Future<SmallWeather> getSmallWeatherOverView(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=temperature_2m_max,weathercode&timezone=auto",
      ),
    );
    final data = await jsonDecode(response.body);

    final daily = data['daily'] as Map<String, dynamic>;
    final List weathercodes = daily['weathercode'] as List;
    final List temps = daily['temperature_2m_max'] as List;

    return SmallWeather(
      weathercode: (weathercodes.first as num).toInt(),
      temperature_2m_max: (temps.first as num).toDouble(),
      utc_offset_seconds: (data['utc_offset_seconds'] as num).toInt(),
    );
  }

  static Future<Weather> getWeatherOverView(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&hourly=temperature_2m,weathercode,precipitation,wind_speed_10m,relative_humidity_2m&daily=temperature_2m_max,weathercode,precipitation_sum,wind_speed_10m_max,relative_humidity_2m_mean&timezone=auto",
      ),
    );
    final data = await jsonDecode(response.body);

    return Weather.fromJson(data);
  }
}
