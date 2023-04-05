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
        required this.cityImageUrl,
      });

  final Weather weather;
  final Map<String, String> iconsMap;
  final String iconUrl;
  final Map<String, dynamic> weatherLog;
  final List<dynamic> forecastLog;
  final String cityImageUrl;

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
                        image: NetworkImage(widget.cityImageUrl),
                      )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 20.0)),
                        Text(
                          '${widget.weatherLog['Температура']}°',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 70.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.weatherLog['Описание'][0].toUpperCase() + widget.weatherLog['Описание'].substring(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          widget.iconsMap[widget.weatherLog['Иконка']] ?? 'assets/weather_icons/storm.png',
                          scale: 1.3,
                        ),
                      ],
                    )
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