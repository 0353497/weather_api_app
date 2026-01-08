class WeatherCodeParser {
  // ignore: non_constant_identifier_names
  static String getImageFromCode(
    int weathercode, {
    required DateTime dateTime,
  }) {
    final hour = dateTime.hour;
    final isDaytime = hour >= 6 && hour < 20;

    // WMO Weather interpretation codes
    // 0: Clear sky
    // 1, 2, 3: Mainly clear, partly cloudy, and overcast
    // 45, 48: Fog
    // 51, 53, 55: Drizzle
    // 56, 57: Freezing Drizzle
    // 61, 63, 65: Rain
    // 66, 67: Freezing Rain
    // 71, 73, 75: Snow fall
    // 77: Snow grains
    // 80, 81, 82: Rain showers
    // 85, 86: Snow showers
    // 95: Thunderstorm
    // 96, 99: Thunderstorm with hail

    switch (weathercode) {
      case 0:
        return isDaytime
            ? 'assets/images/weather-types/sun.png'
            : 'assets/images/weather-types/moon.png';

      case 1:
      case 2:
        return isDaytime
            ? 'assets/images/weather-types/sun_cloudy.png'
            : 'assets/images/weather-types/moon_cloudy.png';

      case 3:
        return 'assets/images/weather-types/cloudy.png';

      case 45:
      case 48:
        return 'assets/images/weather-types/cloudy.png';

      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
        return isDaytime
            ? 'assets/images/weather-types/sun_cloudy_rain.png'
            : 'assets/images/weather-types/moon_cloudy_rain.png';

      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return 'assets/images/weather-types/rain.png';

      case 80:
      case 81:
      case 82:
        return 'assets/images/weather-types/rain.png';

      case 95:
      case 96:
      case 99:
        return 'assets/images/weather-types/rain.png';

      default:
        return isDaytime
            ? 'assets/images/weather-types/sun.png'
            : 'assets/images/weather-types/moon.png';
    }
  }

  static String getDescriptionFromCode(int weathercode) {
    switch (weathercode) {
      case 0:
        return 'Helder';
      case 1:
        return 'Overwegend helder';
      case 2:
        return 'Gedeeltelijk bewolkt';
      case 3:
        return 'Bewolkt';
      case 45:
      case 48:
        return 'Mist';
      case 51:
      case 53:
      case 55:
        return 'Motregen';
      case 56:
      case 57:
        return 'Ijzel';
      case 61:
        return 'Lichte regen';
      case 63:
        return 'Matige regen';
      case 65:
        return 'Zware regen';
      case 66:
      case 67:
        return 'Ijzel';
      case 71:
        return 'Lichte sneeuw';
      case 73:
        return 'Matige sneeuw';
      case 75:
        return 'Zware sneeuw';
      case 77:
        return 'Sneeuwkorrels';
      case 80:
        return 'Lichte regenbuien';
      case 81:
        return 'Matige regenbuien';
      case 82:
        return 'Zware regenbuien';
      case 85:
        return 'Lichte sneeuwbuien';
      case 86:
        return 'Zware sneeuwbuien';
      case 95:
        return 'Onweer';
      case 96:
      case 99:
        return 'Onweer met hagel';
      default:
        return 'Onbekend';
    }
  }
}
