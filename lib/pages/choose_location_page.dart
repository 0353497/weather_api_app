import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_api_app/models/data_location.dart';
import 'package:weather_api_app/providers/location_provider.dart';
import 'package:weather_api_app/services/weather_service.dart';

class ChooseLocationPage extends StatefulWidget {
  const ChooseLocationPage({super.key});

  @override
  State<ChooseLocationPage> createState() => _ChooseLocationPageState();
}

class _ChooseLocationPageState extends State<ChooseLocationPage> {
  final SearchController searchController = SearchController();
  late SharedPreferences prefs;
  List<DataLocation> savedLocations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Kies je locatie"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              searchBarTop(),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (_loading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (savedLocations.isEmpty) {
                      return Center(
                        child: Text(
                          "Geen opgeslagen locaties",
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: savedLocations.length,
                      itemBuilder: (context, index) {
                        final location = savedLocations[index];
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withAlpha(64),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => _selectLocation(location),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        spacing: 20,
                                        children: [
                                          ClipRRect(
                                            clipBehavior: Clip.hardEdge,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            child: Image.network(
                                              "https://flagsapi.com/${location.country_code}/flat/64.png",
                                              height: 40,
                                              width: 40,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      height: 40,
                                                      width: 40,
                                                      color: Colors.grey,
                                                    );
                                                  },
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                location.name ?? "Onbekend",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                location.admin1 ?? "",
                                                style: TextStyle(fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      FutureBuilder(
                                        future:
                                            WeatherService.getSmallWeatherOverView(
                                              location.latitude,
                                              location.longitude,
                                            ),
                                        builder: (context, asyncSnapshot) {
                                          if (asyncSnapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }
                                          if (!asyncSnapshot.hasData) {
                                            return Icon(Icons.chevron_right);
                                          }
                                          return Row(
                                            children: [
                                              Text(
                                                "${asyncSnapshot.data!.temperature_2m_max}°",
                                              ),
                                              Image.asset(
                                                asyncSnapshot.data!.imagepath,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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

  Future<void> _loadSavedLocations() async {
    prefs = await SharedPreferences.getInstance();
    const savedLocationsKey = "savedLocations";
    final List<String> cached = prefs.getStringList(savedLocationsKey) ?? [];

    final List<DataLocation> parsed = [];
    for (final item in cached) {
      try {
        parsed.add(DataLocation.fromjson(jsonDecode(item)));
      } catch (_) {}
    }

    setState(() {
      savedLocations = parsed;
      _loading = false;
    });
  }

  Future<void> _selectLocation(DataLocation location) async {
    await prefs.setString("lastLocation", jsonEncode(location.toJson()));
    final controller = Get.find<LocationProvider>();
    controller.setCurrentLocation(location);
    if (!mounted) return;
    Navigator.of(context).pop();
  }
}
