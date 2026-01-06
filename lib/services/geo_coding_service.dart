import 'dart:convert';

import 'package:weather_api_app/models/data_location.dart';
import 'package:http/http.dart' as http;

class GeoCodingService {
  static Future<List<DataLocation>> findLocations(String query) async {
    final List<DataLocation> locations = [];
    final response = await http.get(
      Uri.parse(
        "https://geocoding-api.open-meteo.com/v1/search?name=${query}&count=5&language=nl ",
      ),
    );
    final data = await jsonDecode(response.body);
    final List results = data["results"];
    for (var datalocation in results) {
      locations.add(DataLocation.fromjson(datalocation));
    }
    print(locations);
    return locations;
  }
}
