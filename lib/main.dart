import 'package:flutter/material.dart';
import 'package:weather_app2/main_screen/main_screen.dart';
import 'package:weather_app2/requests/images_search.dart';
import 'package:weather_app2/requests/weather.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(imagesSearch: ImagesSearch(), weather: Weather()),
      ),
  );
}
