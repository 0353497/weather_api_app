import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_api_app/models/data_location.dart';
import 'package:weather_api_app/providers/location_provider.dart';
import 'package:weather_api_app/services/geo_coding_service.dart';
import 'package:get/get.dart';

class FindLocationPage extends StatefulWidget {
  const FindLocationPage({super.key});

  @override
  State<FindLocationPage> createState() => _FindLocationPageState();
}

class _FindLocationPageState extends State<FindLocationPage> {
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;
  List<DataLocation> queryLocations = [];
  late SharedPreferences prefs;
  bool _prefsReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Zoek je locatie"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              searchBarTop(),
              Expanded(
                child: ListView.builder(
                  itemCount: queryLocations.length,
                  itemBuilder: (context, index) {
                    final DataLocation location = queryLocations[index];
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withAlpha(64),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 20,
                                  children: [
                                    ClipRRect(
                                      clipBehavior: Clip.hardEdge,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        "https://flagsapi.com/${location.country_code}/flat/64.png",
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.red,
                                              );
                                            },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          location.name ?? "unkown",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          location.admin1 ?? "unkown",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () async {
                                    if (!_prefsReady) return;
                                    await _saveLocation(location);
                                  },
                                  icon: Icon(Icons.add),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row searchBarTop() {
    return Row(
      spacing: 16,
      children: [
        Expanded(
          child: SearchBar(
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 24),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Colors.white.withAlpha(100),
            ),
            elevation: WidgetStatePropertyAll(0),
            leading: Image.asset("assets/images/search.png", height: 24),
            hintStyle: WidgetStatePropertyAll(
              TextStyle(fontStyle: FontStyle.italic),
            ),
            hintText: "Zoek op Locatie",
            onChanged: (value) {
              if (value.length < 3) return;
              _debounceTimer?.cancel();
              _debounceTimer = Timer(Duration(milliseconds: 300), () async {
                queryLocations = await GeoCodingService.findLocations(value);
                setState(() {});
              });
            },
            controller: searchController,
          ),
        ),
        IconButton(
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            ),
            backgroundColor: WidgetStatePropertyAll(
              Colors.white.withAlpha(100),
            ),
          ),
          onPressed: () async {
            try {
              final serviceEnabled =
                  await Geolocator.isLocationServiceEnabled();
              if (!serviceEnabled) {
                throw Exception("Location services are disabled");
              }

              LocationPermission permission =
                  await Geolocator.checkPermission();
              if (permission == LocationPermission.denied) {
                permission = await Geolocator.requestPermission();
                if (permission == LocationPermission.denied) {
                  throw Exception('Location permissions are denied');
                }
              }

              if (permission == LocationPermission.deniedForever) {
                throw Exception(
                  'Location permissions are permanently denied, we cannot request permissions.',
                );
              }

              final position = await Geolocator.getCurrentPosition();
              final currentLocation = DataLocation(
                isCurrentLocation: true,
                name: "Current Location",
                latitude: position.latitude,
                longitude: position.longitude,
                country_code: "",
                country: "",
                admin1: "",
              );

              if (!_prefsReady) return;

              await prefs.setString(
                "lastLocation",
                jsonEncode(currentLocation.toJson()),
              );
              final controller = Get.find<LocationProvider>();
              controller.setCurrentLocation(currentLocation);
              if (mounted) Navigator.of(context).pop();
            } catch (e) {
              print("Error getting current location: $e");
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Could not get current location: ${e.toString()}",
                    ),
                  ),
                );
              }
            }
          },
          icon: Image.asset("assets/images/near_me.png", width: 32),
        ),
      ],
    );
  }

  void _init() async {
    prefs = await SharedPreferences.getInstance();
    _prefsReady = true;
  }

  Future<void> _saveLocation(DataLocation location) async {
    const savedLocationsKey = "savedLocations";
    final List<String> cached = prefs.getStringList(savedLocationsKey) ?? [];

    final exists = cached.any((item) {
      final decoded = DataLocation.fromjson(jsonDecode(item));
      return decoded.latitude == location.latitude &&
          decoded.longitude == location.longitude;
    });

    if (!exists) {
      cached.add(jsonEncode(location.toJson()));
      await prefs.setStringList(savedLocationsKey, cached);
    }

    await prefs.setString("lastLocation", jsonEncode(location.toJson()));

    final controller = Get.find<LocationProvider>();
    controller.setCurrentLocation(location);

    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
