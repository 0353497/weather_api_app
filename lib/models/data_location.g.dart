// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataLocation _$DataLocationFromJson(Map<String, dynamic> json) => DataLocation(
  isCurrentLocation: json['isCurrentLocation'] as bool? ?? false,
  name: json['name'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  country_code: json['country_code'] as String?,
  country: json['country'] as String?,
  admin1: json['admin1'] as String?,
);

Map<String, dynamic> _$DataLocationToJson(DataLocation instance) =>
    <String, dynamic>{
      'isCurrentLocation': instance.isCurrentLocation,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'country_code': instance.country_code,
      'country': instance.country,
      'admin1': instance.admin1,
    };
