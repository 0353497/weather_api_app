import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_api_app/models/data_location.dart';
import 'package:weather_api_app/pages/home_page.dart';
import 'package:weather_api_app/providers/location_provider.dart';

void main() {
  runApp(const MainApp());
  Get.put<LocationProvider>(LocationProvider());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool hasLastLocation = false;
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff599ADF),
        colorScheme: ColorScheme.light(
          primary: Color(0xff599ADF),
          surface: Color(0xff599ADF),
          onSurface: Colors.white,
          onPrimary: Colors.white,
        ),
        textTheme: TextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: HomePage(),
    );
  }

  void _init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    hasLastLocation = prefs.containsKey("lastLocation");

    if (!hasLastLocation) return;

    final jsonString = prefs.getString("lastLocation");
    if (jsonString == null) return;

    final DataLocation lastLocation = DataLocation.fromjson(
      jsonDecode(jsonString),
    );

    final controller = Get.find<LocationProvider>();
    controller.setCurrentLocation(lastLocation);
    setState(() {});
  }
}
