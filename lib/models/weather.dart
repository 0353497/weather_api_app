// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable()
class Weather {
  final double latitude;
  final double longitude;
  final double generationtime_ms;
  final int utc_offset_seconds;
  final String timezone;
  final String timezone_abbreviation;
  final double elevation;
  final HourlyUnits hourly_units;
  final Hourly hourly;
  final DailyUnits daily_units;
  final Daily daily;

  Weather({
    required this.latitude,
    required this.longitude,
    required this.generationtime_ms,
    required this.utc_offset_seconds,
    required this.timezone,
    required this.timezone_abbreviation,
    required this.elevation,
    required this.hourly_units,
    required this.hourly,
    required this.daily_units,
    required this.daily,
  });

  factory Weather.fromJson(Map<String, dynamic> json) =>
      _$WeatherFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable()
class HourlyUnits {
  final String time;
  final String temperature_2m;
  final String weathercode;
  final String precipitation;
  final String wind_speed_10m;
  final String relative_humidity_2m;

  HourlyUnits({
    required this.time,
    required this.temperature_2m,
    required this.weathercode,
    required this.precipitation,
    required this.wind_speed_10m,
    required this.relative_humidity_2m,
  });

  factory HourlyUnits.fromJson(Map<String, dynamic> json) =>
      _$HourlyUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyUnitsToJson(this);
}

@JsonSerializable()
class Hourly {
  final List<String> time;
  final List<double> temperature_2m;
  final List<int> weathercode;
  final List<double> precipitation;
  final List<double> wind_speed_10m;
  final List<int> relative_humidity_2m;

  Hourly({
    required this.time,
    required this.temperature_2m,
    required this.weathercode,
    required this.precipitation,
    required this.wind_speed_10m,
    required this.relative_humidity_2m,
  });

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}

@JsonSerializable()
class DailyUnits {
  final String time;
  final String temperature_2m_max;
  final String weathercode;
  final String precipitation_sum;
  final String wind_speed_10m_max;
  final String relative_humidity_2m_mean;

  DailyUnits({
    required this.time,
    required this.temperature_2m_max,
    required this.weathercode,
    required this.precipitation_sum,
    required this.wind_speed_10m_max,
    required this.relative_humidity_2m_mean,
  });

  factory DailyUnits.fromJson(Map<String, dynamic> json) =>
      _$DailyUnitsFromJson(json);

  Map<String, dynamic> toJson() => _$DailyUnitsToJson(this);
}

@JsonSerializable()
class Daily {
  final List<String> time;
  final List<double> temperature_2m_max;
  final List<int> weathercode;
  final List<double> precipitation_sum;
  final List<double> wind_speed_10m_max;
  final List<int> relative_humidity_2m_mean;

  Daily({
    required this.time,
    required this.temperature_2m_max,
    required this.weathercode,
    required this.precipitation_sum,
    required this.wind_speed_10m_max,
    required this.relative_humidity_2m_mean,
  });

  factory Daily.fromJson(Map<String, dynamic> json) => _$DailyFromJson(json);

  Map<String, dynamic> toJson() => _$DailyToJson(this);
}
