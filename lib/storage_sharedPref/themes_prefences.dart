import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences extends ChangeNotifier{
ThemePreferences(){
  loadThemeState();
}
  bool checkTheme = false;

  void checkThemes(bool value) {
    checkTheme = value;
    saveThemeState();
    notifyListeners();
  }
  Future<void> saveThemeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ThemeState', checkTheme);
  }
  Future<void> loadThemeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    checkTheme = prefs.getBool('ThemeState') ?? false;
    notifyListeners();
  }
}