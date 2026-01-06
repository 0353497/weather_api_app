// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'small_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmallWeather _$SmallWeatherFromJson(Map<String, dynamic> json) => SmallWeather(
  weathercode: (json['weathercode'] as num).toInt(),
  temperature_2m_max: (json['temperature_2m_max'] as num).toDouble(),
  utc_offset_seconds: (json['utc_offset_seconds'] as num).toInt(),
);

Map<String, dynamic> _$SmallWeatherToJson(SmallWeather instance) =>
    <String, dynamic>{
      'weathercode': instance.weathercode,
      'temperature_2m_max': instance.temperature_2m_max,
      'utc_offset_seconds': instance.utc_offset_seconds,
    };
