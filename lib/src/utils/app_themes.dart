import 'package:flutter/material.dart';

class AppThemes {
  static const Map<int, Color> primaryColor = {
    50: Color(0xffdbebf8),
    100: Color(0xffd4e7f6),
    200: Color(0xffcde3f5),
    300: Color(0xffc6dff3),
    400: Color(0xffbfdbf2),
    500: Color(0xffb8d7f1),
    600: Color(0xffa3cbed),
    700: Color(0xff19946f),
    800: Color(0xff8dbfe9),
    900: Color(0xff78b3e4),
  };

  static const Map<int, Color> secundaryColor = {
    50: Color(0xfff3cf9c),
    100: Color(0xffeaab52),
    200: Color(0xfff7ab3f),
    300: Color(0xfff6a027),
    400: Color(0xfff5950e),
    500: Color(0xffffa000),
    600: Color(0xffc87808),
    700: Color(0xffb06a07),
    800: Color(0xff975b06),
    900: Color(0xff704304),
  };

  static const appBarTheme = const AppBarTheme(
    brightness: Brightness.light,
    textTheme: TextTheme(
      title: TextStyle(color: Colors.black, fontSize: 20),
    ),
    color: Color(0xffb8d7f1),
    iconTheme: IconThemeData(color: Colors.black),
  );

  static const tabBarTheme = const TabBarTheme(
    labelColor: Color(0xffe18709),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Color(0xffe18709), width: 2),
    ),
    unselectedLabelColor: Color(0xffe18709),
    labelPadding: EdgeInsets.all(0),
  );
}
