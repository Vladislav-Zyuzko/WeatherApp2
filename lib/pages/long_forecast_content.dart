import 'package:flutter/material.dart';

class LongForecastContent extends StatefulWidget {
  const LongForecastContent({super.key,
    required this.forecastLog,
    required this.iconsMap,
    required this.iconUrl});

  final List<dynamic> forecastLog;
  final Map<String, String> iconsMap;
  final String iconUrl;

  @override
  State<LongForecastContent> createState() => _LongForecastContentState();
}

class _LongForecastContentState extends State<LongForecastContent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.forecastLog.length,
        itemBuilder: (BuildContext context, int index1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.only(top: 30.0)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "${widget.forecastLog[index1][0]['День']} ${widget
                      .forecastLog[index1][0]['Месяц']}",
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10.0)),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: widget.forecastLog[index1].length,
                  itemBuilder: (BuildContext context, int index2) {
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
                              "${widget
                                  .forecastLog[index1][index2]['Температура']}°",
                              style: const TextStyle(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${widget
                                  .forecastLog[index1][index2]['Описание']}",
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
                                  crossAxisAlignment: CrossAxisAlignment
                                      .center,
                                  children: [
                                    Text(
                                      widget
                                          .forecastLog[index1][index2]['Время'],
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                            );
                          },
                        ),
                        trailing: Image.asset(
                          widget.iconsMap[widget
                              .forecastLog[index1][index2]['Иконка']] ??
                              'assets/weather_icons/storm.png',
                          scale: 2.0,
                        ),
                      ),
                    );
                  }),
            ],
          );
        }
    );
  }
}
