// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';

part 'data_location.g.dart';

@JsonSerializable()
class DataLocation {
  final bool isCurrentLocation;
  final String? name;
  final double latitude;
  final double longitude;
  final String? country_code;
  final String? country;
  final String? admin1;

  DataLocation({
    this.isCurrentLocation = false,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country_code,
    required this.country,
    required this.admin1,
  });

  factory DataLocation.fromjson(Map<String, dynamic> json) =>
      _$DataLocationFromJson(json);

  Map<String, dynamic> toJson() => _$DataLocationToJson(this);
}
