import 'package:get/get.dart';
import 'package:weather_api_app/models/data_location.dart';

class LocationProvider extends GetxController {
  final Rx<DataLocation?> _currentLocation = DataLocation(
    name: "Example",
    latitude: 0.0,
    longitude: 0.0,
    country_code: "XX",
    country: "Example country",
    admin1: "example provance",
  ).obs;

  DataLocation? get currentlocation => _currentLocation.value;

  setCurrentLocation(DataLocation newLocation) {
    _currentLocation.value = newLocation;
  }
}
