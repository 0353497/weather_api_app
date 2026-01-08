import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ThemeType { brightDay, brightNight, cloudyDay, cloudyNight }

class ThemeProvider extends GetxController {
  final _currentThemeType = ThemeType.brightDay.obs;

  ThemeData get currentTheme {
    switch (_currentThemeType.value) {
      case ThemeType.brightDay:
        return _backgroundBrightDay;
      case ThemeType.brightNight:
        return _backgroundBrightNight;
      case ThemeType.cloudyDay:
        return _backgroundCloudyDay;
      case ThemeType.cloudyNight:
        return _backgroundCloudyNight;
    }
  }

  void setTheme(ThemeType themeType) {
    _currentThemeType.value = themeType;
    update();
  }

  ThemeType get currentThemeType => _currentThemeType.value;

  final _backgroundBrightNight = ThemeData(
    scaffoldBackgroundColor: Color(0xff132671),
    colorScheme: ColorScheme.light(
      primary: Color(0xff132671),
      surface: Color(0xff132671),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    textTheme: TextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );

  final _backgroundBrightDay = ThemeData(
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
  );
  final _backgroundCloudyDay = ThemeData(
    scaffoldBackgroundColor: Color(0xff8997A5),
    colorScheme: ColorScheme.light(
      primary: Color(0xff8997A5),
      surface: Color(0xff8997A5),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    textTheme: TextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
  final _backgroundCloudyNight = ThemeData(
    scaffoldBackgroundColor: Color(0xff2B2F3F),
    colorScheme: ColorScheme.light(
      primary: Color(0xff2B2F3F),
      surface: Color(0xff2B2F3F),
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
    textTheme: TextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
