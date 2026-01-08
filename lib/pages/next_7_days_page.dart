import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api_app/components/highlight_weather_widget.dart';
import 'package:weather_api_app/models/weather.dart';
import 'package:weather_api_app/services/weather_code_parser.dart';

class Next7DaysPage extends StatefulWidget {
  const Next7DaysPage({super.key, required this.weather});
  final Weather weather;

  @override
  State<Next7DaysPage> createState() => _Next7DaysPageState();
}

class _Next7DaysPageState extends State<Next7DaysPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Komende 7 dagen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 12,
          children: [
            Main7DaysHighlightWidget(widget: widget),
            for (int i = 1; i < widget.weather.daily.weathercode.length; i++)
              Container(
                height: 80,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(64),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat(
                        "EEEE",
                      ).format(DateTime.parse(widget.weather.daily.time[i])),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Row(
                      children: [
                        Text(
                          "${widget.weather.daily.temperature_2m_max[i].toInt()}°",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          height: 60,
                          WeatherCodeParser.getImageFromCode(
                            widget.weather.daily.weathercode[i],
                            widget.weather.utc_offset_seconds,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Main7DaysHighlightWidget extends StatelessWidget {
  const Main7DaysHighlightWidget({super.key, required this.widget});

  final Next7DaysPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(64),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Morgen",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  spacing: 12,
                  children: [
                    Text(
                      "${widget.weather.daily.temperature_2m_max.first.toInt()}°",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      height: 60,
                      WeatherCodeParser.getImageFromCode(
                        widget.weather.daily.weathercode.first,
                        widget.weather.utc_offset_seconds,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 12,
              children: [
                HighlightWeatherWidget(
                  imagePath: "assets/images/umbrella.png",
                  title: "",
                  valueAndType:
                      "${widget.weather.daily.precipitation_sum.first} ${widget.weather.daily_units.precipitation_sum}",
                  hasBorder: false,
                ),
                HighlightWeatherWidget(
                  imagePath: "assets/images/wind.png",
                  title: "",
                  valueAndType:
                      "${widget.weather.daily.wind_speed_10m_max.first} ${widget.weather.daily_units.wind_speed_10m_max}",
                  hasBorder: false,
                ),
                HighlightWeatherWidget(
                  imagePath: "assets/images/huminaty.png",
                  title: "",
                  valueAndType:
                      "${widget.weather.daily.relative_humidity_2m_mean.first} ${widget.weather.daily_units.relative_humidity_2m_mean}",
                  hasBorder: false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
