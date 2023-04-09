import 'package:flutter/material.dart';
import 'package:weather_app2/pages/main_screen/main_screen.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:weather_app2/pages/init_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  var userBox = await Hive.openBox("UserBox");

  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: userBox.isEmpty ? '/init' : '/',
        routes: {
          '/': (context) => Home(imagesSearch: ImagesSearch(), weather: Weather(), userBox: userBox),
          '/init': (context) => InitContent(userBox: userBox, weather: Weather(), imagesSearch: ImagesSearch()),
        },
    ));
}
