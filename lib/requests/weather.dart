import 'package:dio/dio.dart';

class Weather {
  int _timezone = 0;

  double _lat = 55;
  double _lon = 73.4;

  String _cityName = "Омск";

  bool _status = true;

  final _appid = '69856b5b43fc307c7b50ccafb0b06dbf';
  final _units = 'metric';

  final Map<int, String> _monthsMap = <int, String>{
    1: 'Января',
    2: 'Февраля',
    3: 'Марта',
    4: 'Апреля',
    5: 'Мая',
    6: 'Июня',
    7: 'Июля',
    8: 'Августа',
    9: 'Сентября',
    10: 'Октября',
    11: 'Ноября',
    12: 'Декабря',
  };

  BaseOptions options = BaseOptions(
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  );

  String _windDirection(int deg) {
    if (deg >= 22.5 && deg < 67.5) {
      return "СВ";
    } else if (deg >= 67.5 && deg < 112.5) {
      return "Вос.";
    } else if (deg >= 112.5 && deg < 157.5) {
      return "ЮВ";
    } else if (deg >= 157.5 && deg < 202.5) {
      return "Юж.";
    } else if (deg >= 202.5 && deg < 247.5) {
      return "ЮЗ";
    } else if (deg >= 247.5 && deg < 292.5) {
      return "Зап.";
    } else if (deg >= 292.5 && deg < 337.5) {
      return "СЗ";
    } else {
      return "Cев.";
    }
  }

  String _getLocalTime(int dt) {
    return "${DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000, isUtc: true).hour}:00";
  }

  int _getLocalDay(int dt) {
    return DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000,
            isUtc: true)
        .day;
  }

  int _getLocalMonth(int dt) {
    return DateTime.fromMillisecondsSinceEpoch((dt + _timezone) * 1000,
            isUtc: true)
        .month;
  }

  Map<String, String> _queryParameters(Map<String, String> newParameter) {
    final parameters = <String, String>{
      'units': _units,
      'lang': 'ru',
      'APPID': _appid,
    };
    parameters.addAll(newParameter);
    return parameters;
  }

  bool getStatus() {
    return _status;
  }

  String getCityName() {
    return _cityName;
  }

  void setCityName(String cityName) {
    _cityName = cityName;
  }

  Future<Map<String, dynamic>> getNowWeather() async {
    final weatherMap = <String, dynamic>{};
    Dio dio = Dio(options);

    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/weather',
        options: Options(method: 'GET'),
        queryParameters: _queryParameters(<String, String>{"q": _cityName}),
      );
      weatherMap['Описание'] =
          response.data['weather'][0]['description'][0].toUpperCase() +
              response.data['weather'][0]['description'].substring(1);
      weatherMap['Иконка'] = response.data['weather'][0]['icon'];
      weatherMap['Температура'] = response.data['main']['temp'].round();
      weatherMap['Давление'] = response.data['main']['pressure'];
      weatherMap['Влажность'] = response.data['main']['humidity'];
      weatherMap['Скорость ветра'] = response.data['wind']['speed'];
      weatherMap['Направление ветра'] =
          _windDirection(response.data['wind']['deg']);
      weatherMap['Угол ветра'] = response.data['wind']['deg'];
      _status = true;
      return weatherMap;
    } on DioError {
      _status = false;
      return weatherMap;
    }
  }

  void getCoordinates(String city) async {
    Dio dio = Dio(options);
    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/find',
        options: Options(method: 'GET'),
        queryParameters: <String, String>{
          'q': city,
          'units': _units,
          'APPID': _appid,
        },
      );
      _lat = response.data['list'][0]['coord']['lat'].toDouble();
      _lon = response.data['list'][0]['coord']['lon'].toDouble();
    } on DioError {
      _status = false;
    }
  }

  Future<List<dynamic>> getHourlyForecast() async {
    final forecastList = [];
    int currentDay = 0;
    int index = -1;
    Dio dio = Dio(options);
    try {
      Response response = await dio.request(
        'https://api.openweathermap.org/data/2.5/onecall',
        options: Options(method: 'GET'),
        queryParameters: _queryParameters(<String, String>{
          'lat': _lat.toString(),
          'lon': _lon.toString(),
        }),
      );
      print(response.data['hourly'][0]);
      for (var i in response.data['hourly']) {
        Map weatherMap = <String, dynamic>{};
        weatherMap['День'] = _getLocalDay(i['dt']);
        weatherMap['Месяц'] = _monthsMap[_getLocalMonth(i['dt'])];
        weatherMap['Время'] = _getLocalTime(i['dt']);
        weatherMap['Описание'] =
            i['weather'][0]['description'][0].toUpperCase() +
                i['weather'][0]['description'].substring(1);
        weatherMap['Иконка'] = i['weather'][0]['icon'];
        weatherMap['Температура'] = i['temp'].round();
        weatherMap['Скорость ветра'] = i['wind_speed'];
        weatherMap['Направление ветра'] = _windDirection(i['wind_deg']);
        if (weatherMap['День'] != currentDay) {
          currentDay = weatherMap['День'];
          forecastList.add([weatherMap]);
          index += 1;
        } else {
          forecastList[index].add(weatherMap);
        }
      }
      _status = true;
      return forecastList;
    } on DioError {
      _status = false;
      return forecastList;
    }
  }

  Future<List<dynamic>> getLongForecast() async {
    final forecastList = [];
    int currentDay = 0;
    int index = -1;
    Dio dio = Dio(options);

    try {
      Response response = await dio.request(
        'http://api.openweathermap.org/data/2.5/forecast',
        options: Options(method: 'GET'),
        queryParameters: _queryParameters(<String, String>{"q": _cityName}),
      );
      _timezone = response.data['city']['timezone'];
      for (var i in response.data['list']) {
        Map weatherMap = <String, dynamic>{};
        weatherMap['День'] = _getLocalDay(i['dt']);
        weatherMap['Месяц'] = _monthsMap[_getLocalMonth(i['dt'])];
        weatherMap['Время'] = _getLocalTime(i['dt']);
        weatherMap['Описание'] =
            i['weather'][0]['description'][0].toUpperCase() +
                i['weather'][0]['description'].substring(1);
        weatherMap['Иконка'] = i['weather'][0]['icon'];
        weatherMap['Температура'] = i['main']['temp'].round();
        weatherMap['Скорость ветра'] = i['wind']['speed'];
        weatherMap['Направление ветра'] = _windDirection(i['wind']['deg']);
        if (weatherMap['День'] != currentDay) {
          currentDay = weatherMap['День'];
          forecastList.add([weatherMap]);
          index += 1;
        } else {
          forecastList[index].add(weatherMap);
        }
      }
      _status = true;
      return forecastList;
    } on DioError {
      _status = false;
      return forecastList;
    }
  }
}
