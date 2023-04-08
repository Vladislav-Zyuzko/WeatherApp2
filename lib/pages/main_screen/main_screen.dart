import 'package:flutter/material.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:weather_app2/pages/main_screen/main_content.dart';
import 'package:weather_app2/pages/load_content.dart';
import 'package:weather_app2/pages/invalid_content.dart';
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
            cityImageUrl: widget.imagesSearch.getCityImageURL());
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
            setNewCityImageURL();
            loadData();
            setState(() {
              changeStateAnimationButton();
            });
          }
      );
    }
  }

  void setNewCityImageURL() async {
    String newCityImageURL = await widget.imagesSearch.getImage(widget.weather.getCityName());
    setState(() {
      widget.userBox.put('cityImageURL', newCityImageURL);
      widget.imagesSearch.setCityImageURL(newCityImageURL);
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
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = Tween<double>(begin: dir ? 0 : -0.25, end: dir ? -0.25 : 0)
        .animate(_controller);
    if (widget.userBox.isNotEmpty) {widget.weather.setCityName(widget.userBox.get('city'));}
    if (widget.userBox.isNotEmpty) {widget.imagesSearch.setCityImageURL(widget.userBox.get('cityImageURL'));}
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
      resizeToAvoidBottomInset: false,
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
      ),
      body: returnContent(),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.white,
          selectedFontSize: 15.0,
          unselectedItemColor: Colors.grey,
          unselectedFontSize: 15.0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.access_time_sharp,
              ),
              label: 'Сегодня',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.today,
              ),
              label: 'Завтра',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.date_range,
              ),
              label: 'На 5 дней',
            )

          ],
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
