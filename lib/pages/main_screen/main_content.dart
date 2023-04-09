import 'package:flutter/material.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:weather_icons/weather_icons.dart';

class MainContent extends StatefulWidget {
  const MainContent(
      {super.key,
        required this.weather,
        required this.weatherLog,
        required this.iconsMap,
        required this.iconUrl,
        required this.cityImageUrl,
      });

  final Weather weather;
  final Map<String, String> iconsMap;
  final String iconUrl;
  final Map<String, dynamic> weatherLog;
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
                    const Padding(padding: EdgeInsets.only(top: 20.0)),
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
                ),
                Text(
                  widget.weatherLog['Описание'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 30.0)),
          Container(
            width: 0.9 * MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 0.4*MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Icon(
                            Icons.water_drop_outlined,
                            size: 40.0,
                            color: Colors.lightBlue,
                          ),
                          Text(
                            "${widget.weatherLog['Влажность']}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 0.1 * MediaQuery.of(context).size.width)),
                    Container(
                      width: 0.4*MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: const Icon(
                              WeatherIcons.wind_beaufort_1,
                              size: 40.0,
                              color: Colors.lightBlue,
                            ),
                          ),
                          Text(
                            "${widget.weatherLog['Скорость ветра']}м/с",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.only(top: 15.0),),
                Row(
                  children: [
                    Container(
                      width: 0.5*MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: const Icon(
                              WeatherIcons.barometer,
                              size: 40.0,
                              color: Colors.lightBlue,
                            ),
                          ),
                          Text(
                            "${widget.weatherLog['Давление']}мм.",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 0.1 * MediaQuery.of(context).size.width)),
                    Container(
                      width: 0.3*MediaQuery.of(context).size.width,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          WindIcon(
                            color: Colors.lightBlue,
                            degree: widget.weatherLog['Угол ветра'] ?? 90,
                            size: 40.0,
                          ),
                          Text(
                            "${widget.weatherLog['Направление ветра']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}