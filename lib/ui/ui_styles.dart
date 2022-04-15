import 'package:flutter/material.dart';

class UIStyles {
  static BoxDecoration floatingBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      boxShadow: const [
        BoxShadow(
          offset: Offset(0, 6),
          blurRadius: 6,
          color: Color(0x44000000),
        )
      ]);

  static final kTheme = ThemeData(
    primarySwatch: Colors.indigo,
    primaryColor: Colors.indigoAccent[100],
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.black),
    ),
  );
}
