import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:instaflutter/app/light_theme.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Slidy',
      theme: lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ).modular();
  }
}
