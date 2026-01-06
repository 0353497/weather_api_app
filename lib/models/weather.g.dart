// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  generationtime_ms: (json['generationtime_ms'] as num).toDouble(),
  utc_offset_seconds: (json['utc_offset_seconds'] as num).toInt(),
  timezone: json['timezone'] as String,
  timezone_abbreviation: json['timezone_abbreviation'] as String,
  elevation: (json['elevation'] as num).toDouble(),
  hourly_units: HourlyUnits.fromJson(
    json['hourly_units'] as Map<String, dynamic>,
  ),
  hourly: Hourly.fromJson(json['hourly'] as Map<String, dynamic>),
  daily_units: DailyUnits.fromJson(json['daily_units'] as Map<String, dynamic>),
  daily: Daily.fromJson(json['daily'] as Map<String, dynamic>),
);

Map<String, dynamic> _$WeatherToJson(Weather instance) => <String, dynamic>{
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'generationtime_ms': instance.generationtime_ms,
  'utc_offset_seconds': instance.utc_offset_seconds,
  'timezone': instance.timezone,
  'timezone_abbreviation': instance.timezone_abbreviation,
  'elevation': instance.elevation,
  'hourly_units': instance.hourly_units,
  'hourly': instance.hourly,
  'daily_units': instance.daily_units,
  'daily': instance.daily,
};

HourlyUnits _$HourlyUnitsFromJson(Map<String, dynamic> json) => HourlyUnits(
  time: json['time'] as String,
  temperature_2m: json['temperature_2m'] as String,
  weathercode: json['weathercode'] as String,
  precipitation: json['precipitation'] as String,
  wind_speed_10m: json['wind_speed_10m'] as String,
  relative_humidity_2m: json['relative_humidity_2m'] as String,
);

Map<String, dynamic> _$HourlyUnitsToJson(HourlyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m': instance.temperature_2m,
      'weathercode': instance.weathercode,
      'precipitation': instance.precipitation,
      'wind_speed_10m': instance.wind_speed_10m,
      'relative_humidity_2m': instance.relative_humidity_2m,
    };

Hourly _$HourlyFromJson(Map<String, dynamic> json) => Hourly(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature_2m: (json['temperature_2m'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  weathercode: (json['weathercode'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  precipitation: (json['precipitation'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  wind_speed_10m: (json['wind_speed_10m'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  relative_humidity_2m: (json['relative_humidity_2m'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
);

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
  'time': instance.time,
  'temperature_2m': instance.temperature_2m,
  'weathercode': instance.weathercode,
  'precipitation': instance.precipitation,
  'wind_speed_10m': instance.wind_speed_10m,
  'relative_humidity_2m': instance.relative_humidity_2m,
};

DailyUnits _$DailyUnitsFromJson(Map<String, dynamic> json) => DailyUnits(
  time: json['time'] as String,
  temperature_2m_max: json['temperature_2m_max'] as String,
  weathercode: json['weathercode'] as String,
  precipitation_sum: json['precipitation_sum'] as String,
  wind_speed_10m_max: json['wind_speed_10m_max'] as String,
  relative_humidity_2m_mean: json['relative_humidity_2m_mean'] as String,
);

Map<String, dynamic> _$DailyUnitsToJson(DailyUnits instance) =>
    <String, dynamic>{
      'time': instance.time,
      'temperature_2m_max': instance.temperature_2m_max,
      'weathercode': instance.weathercode,
      'precipitation_sum': instance.precipitation_sum,
      'wind_speed_10m_max': instance.wind_speed_10m_max,
      'relative_humidity_2m_mean': instance.relative_humidity_2m_mean,
    };

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
  time: (json['time'] as List<dynamic>).map((e) => e as String).toList(),
  temperature_2m_max: (json['temperature_2m_max'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  weathercode: (json['weathercode'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  precipitation_sum: (json['precipitation_sum'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  wind_speed_10m_max: (json['wind_speed_10m_max'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  relative_humidity_2m_mean:
      (json['relative_humidity_2m_mean'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
);

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
  'time': instance.time,
  'temperature_2m_max': instance.temperature_2m_max,
  'weathercode': instance.weathercode,
  'precipitation_sum': instance.precipitation_sum,
  'wind_speed_10m_max': instance.wind_speed_10m_max,
  'relative_humidity_2m_mean': instance.relative_humidity_2m_mean,
};
