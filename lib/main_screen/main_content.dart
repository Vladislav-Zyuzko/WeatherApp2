import 'package:flutter/material.dart';
import 'package:weather_app2/requests/weather.dart';

class MainContent extends StatefulWidget {
  const MainContent(
      {super.key,
        required this.weather,
        required this.weatherLog,
        required this.iconsMap,
        required this.forecastLog,
        required this.iconUrl,
        required this.query,
      });

  final Weather weather;
  final Map<String, String> iconsMap;
  final String iconUrl;
  final Map<String, dynamic> weatherLog;
  final List<dynamic> forecastLog;
  final String query;

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          Container(
            height: 350,
            width: 0.9*MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.black87,
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.query),
                      )
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${widget.weatherLog['Температура']}°',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      widget.iconsMap[widget.weatherLog['Иконка']] ?? 'assets/weather_icons/storm.png',
                      scale: 1.3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}