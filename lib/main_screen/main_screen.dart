import 'package:flutter/material.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:weather_app2/main_screen/main_content.dart';
import 'package:weather_app2/main_screen/load_content.dart';
import 'package:weather_app2/main_screen/invalid_content.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.imagesSearch, required this.weather, required this.userBox})
      : super(key: key);

  final ImagesSearch imagesSearch;
  final Weather weather;
  final Box userBox;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool dir = true;

  String cityImageUrl =
      "https://kartinkin.net/uploads/posts/2022-03/1648054913_54-kartinkin-net-p-kartinki-voprosa-58.jpg";

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
        return MainContent(
            weather: widget.weather,
            weatherLog: weatherLog,
            forecastLog: forecastLog,
            iconsMap: iconsMap,
            iconUrl: iconUrl,
            cityImageUrl: cityImageUrl);
      } else {
        return const LoadContent();
      }
    } else {
      return const InvalidContent();
    }
  }

  Widget returnAppBar() {
    if (dir) {
      return TextButton(
        onPressed: () {
        changeStateAnimationButton();
      },
        child: Text(
          widget.weather.getCityName(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return TextField(
          controller: TextEditingController(
            text: widget.weather.getCityName(),
          ),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hoverColor: Colors.white,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
                width: 1.0,
              ),
            ),
          ),
          onSubmitted: (String str) {
            widget.weather.setCityName(str);
            widget.userBox.put('city', str);
            loadData();
            setState(() {
              changeStateAnimationButton();
            });
          }
      );
    }
  }

  void getQueryBody() async {
    String newCityImageUrl = await widget.imagesSearch.getImage(widget.weather.getCityName());
    setState(() {
      cityImageUrl = newCityImageUrl;
    });
  }

  void changeStateAnimationButton() {
    _controller.forward(from: 0);
    setState(() {
      _animation = Tween<double>(begin: dir ? 0 : -0.25, end: dir ? -0.25 : 0)
          .animate(_controller);
      dir = !dir;
    });
  }

  void loadData() {
    getWeatherData();
    getForecastData();
    getQueryBody();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = Tween<double>(begin: dir ? 0 : -0.25, end: dir ? -0.25 : 0)
        .animate(_controller);
    if (widget.userBox.isNotEmpty) {widget.weather.setCityName(widget.userBox.get('city'));}
    widget.weather.setCityName('Omsk');
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: returnAppBar(),
        backgroundColor: Colors.black87,
        leading: RotationTransition(
          turns: _animation,
          child: IconButton(
            icon: const Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.white,
              size: 40.0,
            ),
            onPressed: () {
              changeStateAnimationButton();
            },
          ),
        ),
        /*leading: IconButton(
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
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Принять"),
                        )
                      ],
                    );
                  }
                );
            },
            icon: const Icon(
              Icons.arrow_drop_down_sharp,
              color: Colors.white,
              size: 40.0,
            ),
        ),*/
      ),
      body: returnContent(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            )),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.today,
                  color: Colors.white,
                ),
                label: 'Сегодня',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.today,
                  color: Colors.white,
                ),
                label: 'Сегодня',
              ),
            ],
            backgroundColor: Colors.black87,
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
