import 'package:flutter/material.dart';

class ShortForecastContent extends StatefulWidget {
  const ShortForecastContent({super.key,
    required this.shortForecastLog,
    required this.iconsMap,
    required this.iconUrl});

  final List<dynamic> shortForecastLog;
  final Map<String, String> iconsMap;
  final String iconUrl;

  @override
  State<ShortForecastContent> createState() => _ShortForecastContentState();
}

class _ShortForecastContentState extends State<ShortForecastContent> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
