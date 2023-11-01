import 'package:disney_ui/app_bar_widget.dart';
import 'package:disney_ui/characters_view_page.dart';
import 'package:disney_ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        fontFamily: 'LexendDeca',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          titleMedium: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.normal,
              fontSize: 14),
          titleSmall: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          labelSmall: TextStyle(fontWeight: FontWeight.normal),
        ),
        textButtonTheme: const TextButtonThemeData(
            style: ButtonStyle(
          elevation: MaterialStatePropertyAll<double>(0),
          iconColor: MaterialStatePropertyAll<Color>(Colors.black),
          textStyle: MaterialStatePropertyAll<TextStyle>(
              TextStyle(color: Colors.black)),
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
        )),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
