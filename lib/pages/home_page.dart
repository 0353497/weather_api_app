import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:weather_api_app/components/empty_location.dart';
import 'package:weather_api_app/components/highlight_weather_widget.dart';
import 'package:weather_api_app/models/weather.dart';
import 'package:weather_api_app/pages/choose_location_page.dart';
import 'package:weather_api_app/pages/find_location_page.dart';
import 'package:weather_api_app/providers/location_provider.dart';
import 'package:weather_api_app/services/weather_code_parser.dart';
import 'package:weather_api_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selecteDate = DateTime.now();
  late Future<Weather> weatherFuture;

  void _initializeWeather() {
    final controller = Get.find<LocationProvider>();
    final location = controller.currentlocation;
    if (location != null && location.name != "Example") {
      weatherFuture = WeatherService.getWeatherOverView(
        location.latitude,
        location.longitude,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FindLocationPage());
            },
            icon: Image.asset("assets/images/search.png", height: 24),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => ChooseLocationPage());
            },
            icon: Image.asset("assets/images/menu.png", height: 24),
          ),
        ],
      ),
      body: Obx(() {
        final controller = Get.find<LocationProvider>();
        final location = controller.currentlocation;

        if (location == null || location.name == "Example") {
          return EmptyLocation();
        }

        _initializeWeather();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                "${location.name ?? "unkown"}, \n${location.country}",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
              ),
              Expanded(
                child: FutureBuilder(
                  future: weatherFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return Center(child: Text("no data"));
                    }
                    final Weather weather = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text(DateFormat("EEEE d MMMM").format(selecteDate)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width / 2 - 50,
                              child: Image.asset(
                                WeatherCodeParser.getImageFromCode(
                                  weather.daily.weathercode.first,
                                  weather.utc_offset_seconds,
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                        "${weather.daily.temperature_2m_max.first}",
                                        style: TextStyle(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Text(
                                        "°C",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  WeatherCodeParser.getDescriptionFromCode(
                                    weather.daily.weathercode.first,
                                  ),
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          spacing: 16,
                          children: [
                            HighlightWeatherWidget(
                              imagePath: "assets/images/umbrella.png",
                              title: "Regenval",
                              valueAndType:
                                  "${weather.daily.precipitation_sum.first} ${weather.daily_units.precipitation_sum}",
                            ),
                            HighlightWeatherWidget(
                              imagePath: "assets/images/wind.png",
                              title: "Wind",
                              valueAndType:
                                  "${weather.daily.wind_speed_10m_max.first} ${weather.daily_units.wind_speed_10m_max}",
                            ),
                            HighlightWeatherWidget(
                              imagePath: "assets/images/huminaty.png",
                              title: "Vochtigheid",
                              valueAndType:
                                  "${weather.daily.relative_humidity_2m_mean.first} ${weather.daily_units.relative_humidity_2m_mean}",
                            ),
                          ],
                        ),
                        Expanded(
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                TabBar(
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                  indicatorColor: Colors.white,
                                  labelColor: Colors.white,
                                  dividerColor: Colors.white,
                                  tabs: [
                                    Tab(text: "Vandaag"),
                                    Tab(text: "Morgen"),
                                    Tab(text: "Komende 7 dagen"),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      Text("vandaag"),
                                      Text("morgen"),
                                      Text("Komende 7 dagen"),
                                    ],
                                  ),
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
        );
      }),
    );
  }
}
