import 'package:flutter/material.dart';
import 'package:weather_app2/requests/weather.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app2/requests/images_search.dart';

class InitContent extends StatefulWidget {
  const InitContent({super.key, required this.weather, required this.imagesSearch, required this.userBox});

  final Weather weather;
  final Box userBox;
  final ImagesSearch imagesSearch;

  @override
  State<InitContent> createState() => _InitContentState();
}

class _InitContentState extends State<InitContent> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          'Like Weather 2',
          style: TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.deepOrange.shade900,
            ],
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            const Padding(padding: EdgeInsets.only(top: 200)),
            Container(
              padding: const EdgeInsets.all(15),
              width: 320,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                "Добро пожаловать в Like Weather 2!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Введите населенный пункт"),
                        content: TextField(
                          onChanged: (String str) async {
                            String newImageURL = await widget.imagesSearch.getImage(str);
                            setState(() {
                              widget.userBox.put('cityImageURL', newImageURL);
                              widget.imagesSearch.setCityImageURL(newImageURL);
                              widget.userBox.put('city', str);
                              widget.weather.setCityName(str);
                            });
                          },
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              Navigator.pushReplacementNamed(context, '/');
                            },
                            child: const Text("Принять"),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text("Получить прогноз", style: TextStyle(
                  fontSize: 20,
                ),)
            )
          ]),
        ]),
      ),
    );
  }
}