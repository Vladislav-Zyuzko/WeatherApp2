import 'package:flutter/material.dart';
import 'package:weather_app2/pages/main_screen/main_screen.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';
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
        home: Home(imagesSearch: ImagesSearch(), weather: Weather(), userBox: userBox),
      ),
  );
}
