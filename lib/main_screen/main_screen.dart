import 'package:flutter/material.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:weather_app2/main_screen/main_content.dart';
import 'package:weather_app2/main_screen/load_content.dart';
import 'package:weather_app2/main_screen/invalid_content.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.imagesSearch, required this.weather}) : super(key: key);

  final ImagesSearch imagesSearch;
  final Weather weather;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String bodyQuery = "";
  String query = "https://kartinkin.net/uploads/posts/2022-03/1648054913_54-kartinkin-net-p-kartinki-voprosa-58.jpg";

  Map<String, String> iconsMap = <String, String>{
    '01d': 'assets/weather_icons/clear_sun.png',
    '01n': 'assets/weather_icons/clear_moon.png',
    '02d': 'assets/weather_icons/cloudy_sun.png',
    '02n': 'assets/weather_icons/cloudy_moon.png',
    '03d': 'assets/weather_icons/cloudy.png',
    '03n': 'assets/weather_icons/cloudy.png',
    '04d': 'assets/weather_icons/cloudy.png',
    '04n': 'assets/weather_icons/cloudy.png',
    '09d': 'assets/weather_icons/clear_rain.png',
    '09n': 'assets/weather_icons/clear_rain.png',
    '10d': 'assets/weather_icons/cloudy_rain.png',
    '10n': 'assets/weather_icons/cloudy_rain.png',
    '11d': 'assets/weather_icons/storm.png',
    '11n': 'assets/weather_icons/storm.png',
    '13d': 'assets/weather_icons/snow.png',
    '13n': 'assets/weather_icons/snow.png',
    '50d': 'assets/weather_icons/wind.png',
    '50n': 'assets/weather_icons/wind.png',
  };

  String iconUrl = 'assets/weather_icons/no_connect_white.png';
  Map<String, dynamic> weatherLog = <String, dynamic>{};
  List<dynamic> forecastLog = [];

  void getWeatherData() async {
    weatherLog = <String, dynamic>{};
    weatherLog = await widget.weather.getNowWeather();
    setState(() {
      iconUrl = iconsMap[weatherLog['Иконка']] ??
          'assets/weather_icons/no_connect_white.png';
    });
  }

  void getForecastData() async {
    forecastLog = [];
    forecastLog = await widget.weather.getLongForecast();
    setState(() {
      iconUrl = iconsMap[weatherLog['Иконка']] ??
          'assets/weather_icons/no_connect_white.png';
    });
  }

  dynamic returnContent() {
    if (widget.weather.getStatus()) {
      if (weatherLog.isNotEmpty) {
        return MainContent(weather: widget.weather, weatherLog: weatherLog,
            forecastLog: forecastLog, iconsMap: iconsMap, iconUrl: iconUrl, query: query);
      } else { return const LoadContent(); }
    } else {return const InvalidContent();}
  }

  void getQueryBody () async {
    String Query2 = await widget.imagesSearch.getImage(bodyQuery);
    setState(() {
      query = Query2;
    });
  }

  @override
  void initState() {
    super.initState();
    bodyQuery = 'Omsk';
    widget.weather.setCityName('Omsk');
    getWeatherData();
    getForecastData();
    getQueryBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Omsk",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black87,
        leading: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Введите тело запроса"),
                      content: TextField(
                        onChanged: (String str) {
                          setState(() {
                            bodyQuery = str;
                          });
                        },
                      ),
                      actions: [
                        ElevatedButton(onPressed: () {
                          Navigator.of(context).pop();},
                          child: Text("Принять"),
                        )
                      ],
                    );
                  }
              );
            },
            icon: const Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 40.0,
            )
        ),
      ),
      body: returnContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            getQueryBody ();
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}