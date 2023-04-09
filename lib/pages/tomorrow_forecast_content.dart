import 'package:flutter/material.dart';

class TomorrowForecastContent extends StatefulWidget {
  const TomorrowForecastContent(
      {super.key, required this.hourlyForecastLog, required this.iconsMap});

  final List<dynamic> hourlyForecastLog;
  final Map<String, String> iconsMap;

  @override
  State<TomorrowForecastContent> createState() =>
      _TomorrowForecastContentState();
}

class _TomorrowForecastContentState extends State<TomorrowForecastContent> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          const Text(
            "Прогноз на завтра",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.deepOrange,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: widget.hourlyForecastLog[1].length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  color: Colors.black45,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(0.0),
                    textColor: Colors.white,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.hourlyForecastLog[1][index]['Температура']}°",
                          style: const TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.hourlyForecastLog[1][index]['Описание']}",
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    leading: LayoutBuilder(
                      builder: (context, containerConstraints) {
                        return Container(
                            height: containerConstraints.maxHeight,
                            width: 60.0,
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  widget.hourlyForecastLog[1][index]['Время'],
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ));
                      },
                    ),
                    trailing: Image.asset(
                      widget.iconsMap[widget.hourlyForecastLog[1][index]
                              ['Иконка']] ??
                          'assets/weather_icons/storm.png',
                      scale: 2.0,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
