import 'package:flutter/material.dart';
import 'ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'buscador de gifs',
    home: HomePage(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent)),
        hintStyle: TextStyle(color: Colors.amber),
      ),
    ),
  ));
}
