import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData theme = ThemeData(
      bottomAppBarColor: Colors.amber[700],
      brightness: Brightness.light,
      backgroundColor: Colors.grey[100],
      primaryColor: Colors.blue[100],
      accentColor: Colors.amber[700],
      primaryColorDark: Color(0xff8aacc8),
      primaryColorLight: Color(0xFFeeffff),
      buttonTheme: buttonTheme,
      inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.amber[700]))));

  static final ButtonThemeData buttonTheme = ButtonThemeData(
      buttonColor: Colors.amber[700], textTheme: ButtonTextTheme.accent);

  static const appBarTheme = const AppBarTheme(
    brightness: Brightness.light,
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.black, fontSize: 20),
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
