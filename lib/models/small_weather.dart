// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:weather_api_app/services/weather_code_parser.dart';
part 'small_weather.g.dart';

@JsonSerializable()
class SmallWeather {
  String get imagepath =>
      WeatherCodeParser.getImageFromCode(weathercode, utc_offset_seconds);
  final int weathercode;
  final double temperature_2m_max;
  final int utc_offset_seconds;

  factory SmallWeather.fromjson(Map<String, dynamic> json) =>
      _$SmallWeatherFromJson(json);

  SmallWeather({
    required this.weathercode,
    required this.temperature_2m_max,
    required this.utc_offset_seconds,
  });

  Map<String, dynamic> toJson() => _$SmallWeatherToJson(this);
}
