import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../state_management/state_of_todos.dart';

class ThemeSwitch {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromRGBO(225, 213, 67, 0.8),
      titleTextStyle: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(
        color: Colors.white,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.merriweather(
        color: Colors.white,
        fontSize: 18,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color.fromRGBO(54, 142, 197, 0.8),
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color.fromRGBO(225, 213, 67, 0.8),
      selectedIconTheme: IconThemeData(
        color: Colors.black,
        size: 30,
      ),
      selectedItemColor: Colors.black,
      selectedLabelStyle: GoogleFonts.merriweather(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.white,
        size: 30,
      ),
      unselectedItemColor: Colors.white10,
      unselectedLabelStyle: GoogleFonts.merriweather(
        fontSize: 13,
        color: Colors.white10,
      ),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Color.fromRGBO(8, 255, 247, 0.8),
      titleTextStyle: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      toolbarTextStyle: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      displayLarge: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 36,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.merriweather(
        color: Colors.black,
        fontSize: 18,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.yellow,
      foregroundColor: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(

      backgroundColor:Color.fromRGBO(8, 255, 247, 0.8),
      selectedIconTheme: IconThemeData(
        color: Colors.white,
        size: 30,
      ),
      selectedItemColor: Colors.black,
      selectedLabelStyle: GoogleFonts.merriweather(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: GoogleFonts.merriweather(
        fontSize: 13,
        color: Colors.black54,
      ),
    ),


  );
}
