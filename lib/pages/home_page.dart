import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_api_app/components/empty_location.dart';
import 'package:weather_api_app/components/highlight_weather_widget.dart';
import 'package:weather_api_app/models/weather.dart';
import 'package:weather_api_app/pages/choose_location_page.dart';
import 'package:weather_api_app/pages/find_location_page.dart';
import 'package:weather_api_app/pages/next_7_days_page.dart';
import 'package:weather_api_app/providers/location_provider.dart';
import 'package:weather_api_app/providers/theme_provider.dart';
import 'package:weather_api_app/services/weather_code_parser.dart';
import 'package:weather_api_app/services/weather_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  DateTime selecteDate = DateTime.now();
  late Future<Weather> weatherFuture;
  late ScrollController _todayScrollController;
  late ScrollController _tomorrowScrollController;
  late TabController _tabController;
  Weather? _cachedWeather;

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

  int _getSelectedDayIndex(Weather weather) {
    for (int i = 0; i < weather.daily.time.length; i++) {
      DateTime dailyDate = DateTime.parse(weather.daily.time[i]);
      if (dailyDate.year == selecteDate.year &&
          dailyDate.month == selecteDate.month &&
          dailyDate.day == selecteDate.day) {
        return i;
      }
    }
    return 0;
  }

  List<int> _getTodayHourlyIndices(Weather weather) {
    List<int> todayIndices = [];
    DateTime today = DateTime.now().add(1.days);

    for (int i = 0; i < weather.hourly.time.length; i++) {
      DateTime hourTime = DateTime.parse(weather.hourly.time[i]);
      if (hourTime.year == today.year &&
          hourTime.month == today.month &&
          hourTime.day == today.day) {
        todayIndices.add(i);
      }
    }
    return todayIndices;
  }

  List<int> _getTomorrowHourlyIndices(Weather weather) {
    List<int> tomorrowIndices = [];
    DateTime tomorrow = DateTime.now().add(Duration(days: 2));

    for (int i = 0; i < weather.hourly.time.length; i++) {
      DateTime hourTime = DateTime.parse(weather.hourly.time[i]);
      if (hourTime.year == tomorrow.year &&
          hourTime.month == tomorrow.month &&
          hourTime.day == tomorrow.day) {
        tomorrowIndices.add(i);
      }
    }
    return tomorrowIndices;
  }

  void _scrollToSelectedHour(
    Weather weather,
    List<int> hourlyIndices,
    ScrollController scrollController,
    bool isToday,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && hourlyIndices.isNotEmpty) {
        int targetHourIndex = -1;

        for (int i = 0; i < hourlyIndices.length; i++) {
          int actualIndex = hourlyIndices[i];
          DateTime itemTime = DateTime.parse(weather.hourly.time[actualIndex]);

          if (isToday && itemTime.hour == DateTime.now().hour) {
            targetHourIndex = i;
            break;
          } else if (!isToday && itemTime.hour == selecteDate.hour) {
            targetHourIndex = i;
            break;
          }
        }

        if (targetHourIndex == -1 && !isToday) {
          targetHourIndex = 0;
        }

        if (targetHourIndex != -1) {
          double itemWidth = 104.0;
          double scrollPosition = targetHourIndex * itemWidth;

          scrollController.animateTo(
            scrollPosition,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _updateTheme(Weather weather) {
    // Defer theme update to after build phase completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Get.find<ThemeProvider>();

      // Find the hourly index for selected date
      int? selectedHourIndex;
      for (int i = 0; i < weather.hourly.time.length; i++) {
        DateTime hourTime = DateTime.parse(weather.hourly.time[i]);
        if (hourTime.year == selecteDate.year &&
            hourTime.month == selecteDate.month &&
            hourTime.day == selecteDate.day &&
            hourTime.hour == selecteDate.hour) {
          selectedHourIndex = i;
          break;
        }
      }

      if (selectedHourIndex == null) return;

      int weatherCode = weather.hourly.weathercode[selectedHourIndex];
      int selectedHour = selecteDate.hour;

      bool isDay = selectedHour >= 6 && selectedHour < 20;

      bool isCloudy = weatherCode >= 2;

      ThemeType newTheme;
      if (isDay && !isCloudy) {
        newTheme = ThemeType.brightDay;
      } else if (isDay && isCloudy) {
        newTheme = ThemeType.cloudyDay;
      } else if (!isDay && !isCloudy) {
        newTheme = ThemeType.brightNight;
      } else {
        newTheme = ThemeType.cloudyNight;
      }

      themeProvider.setTheme(newTheme);
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
    _todayScrollController = ScrollController();
    _tomorrowScrollController = ScrollController();
    _initializeWeather();
    _goToRightTab();
    _addTabListerer();
  }

  @override
  void dispose() {
    _todayScrollController.dispose();
    _tomorrowScrollController.dispose();
    _tabController.dispose();
    super.dispose();
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
                location.isCurrentLocation
                    ? "Current\nLocation"
                    : "${location.name ?? "unkown"}, \n${location.country}",
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
                    _cachedWeather = weather;
                    _updateTheme(weather);
                    int selectedDayIndex = _getSelectedDayIndex(weather);
                    List<int> todayHourlyIndices = _getTodayHourlyIndices(
                      weather,
                    );
                    List<int> tomorrowHourlyIndices = _getTomorrowHourlyIndices(
                      weather,
                    );

                    _scrollToSelectedHour(
                      weather,
                      todayHourlyIndices,
                      _todayScrollController,
                      true,
                    );
                    _scrollToSelectedHour(
                      weather,
                      tomorrowHourlyIndices,
                      _tomorrowScrollController,
                      false,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text(selectedDateText()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width / 2 - 50,
                              child: Image.asset(
                                WeatherCodeParser.getImageFromCode(
                                  weather.daily.weathercode[selectedDayIndex],
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
                                        "${weather.daily.temperature_2m_max[selectedDayIndex]}",
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
                                    weather.daily.weathercode[selectedDayIndex],
                                  ),
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Hero(
                          tag: "next7transfer",
                          child: Row(
                            spacing: 16,
                            children: [
                              HighlightWeatherWidget(
                                imagePath: "assets/images/umbrella.png",
                                title: "Regenval",
                                valueAndType:
                                    "${weather.daily.precipitation_sum[selectedDayIndex]} ${weather.daily_units.precipitation_sum}",
                                hasBorder: true,
                              ),
                              HighlightWeatherWidget(
                                imagePath: "assets/images/wind.png",
                                title: "Wind",
                                valueAndType:
                                    "${weather.daily.wind_speed_10m_max[selectedDayIndex]} ${weather.daily_units.wind_speed_10m_max}",
                              ),
                              HighlightWeatherWidget(
                                imagePath: "assets/images/huminaty.png",
                                title: "Vochtigheid",
                                valueAndType:
                                    "${weather.daily.relative_humidity_2m_mean[selectedDayIndex]} ${weather.daily_units.relative_humidity_2m_mean}",
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TabBar(
                                controller: _tabController,
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
                                  controller: _tabController,
                                  children: [
                                    ListView.builder(
                                      controller: _todayScrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: todayHourlyIndices.length,
                                      itemBuilder: (context, index) {
                                        int actualIndex =
                                            todayHourlyIndices[index];
                                        bool isNow =
                                            DateTime.now().hour ==
                                            DateTime.parse(
                                              weather.hourly.time[actualIndex],
                                            ).hour;
                                        bool isSelectedTime =
                                            DateTime.parse(
                                              weather.hourly.time[actualIndex],
                                            ).hour ==
                                            selecteDate.hour;
                                        return hourListTile(
                                          weather,
                                          actualIndex,
                                          isSelectedTime,
                                          isNow,
                                        );
                                      },
                                    ),
                                    ListView.builder(
                                      controller: _tomorrowScrollController,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: tomorrowHourlyIndices.length,
                                      itemBuilder: (context, index) {
                                        int actualIndex =
                                            tomorrowHourlyIndices[index];
                                        bool isSelectedTime =
                                            DateTime.parse(
                                              weather.hourly.time[actualIndex],
                                            ).hour ==
                                            selecteDate.hour;
                                        return Row(
                                          children: [
                                            SizedBox(width: 12),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selecteDate = DateTime.parse(
                                                    weather
                                                        .hourly
                                                        .time[actualIndex],
                                                  );
                                                  _updateTheme(weather);
                                                });
                                              },
                                              child: Container(
                                                height: 160,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: isSelectedTime
                                                      ? Colors.black.withAlpha(
                                                          190,
                                                        )
                                                      : Colors.black.withAlpha(
                                                          64,
                                                        ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                          "HH:mm",
                                                        ).format(
                                                          DateTime.parse(
                                                            weather
                                                                .hourly
                                                                .time[actualIndex],
                                                          ),
                                                        ),
                                                      ),
                                                      Image.asset(
                                                        WeatherCodeParser.getImageFromCode(
                                                          weather
                                                              .hourly
                                                              .weathercode[actualIndex],
                                                          weather
                                                              .utc_offset_seconds,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${weather.hourly.temperature_2m[actualIndex].toInt()}°",
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                          ],
                                        );
                                      },
                                    ),
                                    Text("Komende 7 dagen"),
                                  ],
                                ),
                              ),
                            ],
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

  Row hourListTile(
    Weather weather,
    int actualIndex,
    bool isSelectedTime,
    bool isNow,
  ) {
    return Row(
      children: [
        SizedBox(width: 12),
        InkWell(
          onTap: () {
            setState(() {
              selecteDate = DateTime.parse(weather.hourly.time[actualIndex]);
              _updateTheme(weather);
            });
          },
          child: Container(
            height: 160,
            width: 80,
            decoration: BoxDecoration(
              color: isSelectedTime
                  ? Colors.black.withAlpha(190)
                  : Colors.black.withAlpha(64),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    isNow
                        ? "nu"
                        : DateFormat("HH:mm").format(
                            DateTime.parse(weather.hourly.time[actualIndex]),
                          ),
                  ),
                  Image.asset(
                    WeatherCodeParser.getImageFromCode(
                      weather.hourly.weathercode[actualIndex],
                      weather.utc_offset_seconds,
                    ),
                  ),
                  Text(
                    "${weather.hourly.temperature_2m[actualIndex].toInt()}°",
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
      ],
    );
  }

  String selectedDateText() {
    if (selecteDate.hour == DateTime.now().hour) {
      return DateFormat("EEEE d MMMM").format(selecteDate);
    }
    if (selecteDate.isAfter(DateTime.now().add(Duration(days: 2)))) {
      return "Morgen om ${selecteDate.hour.toString().padLeft(2, "0")}:${selecteDate.minute.toString().padLeft(2, "0")}";
    }
    if (selecteDate.isBefore(DateTime.now().add(Duration(days: 1)))) {
      return "Zojuist om ${selecteDate.hour.toString().padLeft(2, "0")}:${selecteDate.minute.toString().padLeft(2, "0")} uur";
    }
    if (selecteDate.isAfter(DateTime.now().add(Duration(days: 1)))) {
      return "Straks om ${selecteDate.hour.toString().padLeft(2, "0")}:${selecteDate.minute.toString().padLeft(2, "0")} uur";
    }
    return DateFormat("EEEE d MMMM").format(selecteDate);
  }

  void _goToRightTab() {
    if (selecteDate.day == DateTime.now().add(1.days).day) {
      _tabController.animateTo(0);
    } else if (selecteDate.day == DateTime.now().add(2.days).day) {
      _tabController.animateTo(1);
    }
  }

  void _addTabListerer() {
    _tabController.addListener(() {
      if (_tabController.index == 2 &&
          !_tabController.indexIsChanging &&
          _cachedWeather != null) {
        Get.to(
          () => Next7DaysPage(weather: _cachedWeather!),
          transition: Transition.rightToLeft,
          duration: Duration(milliseconds: 500),
        );
      }
    });
  }
}
