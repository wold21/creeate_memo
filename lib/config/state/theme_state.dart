import 'package:flutter/material.dart';
import 'package:create_author/config/color/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeState with ChangeNotifier {
  bool isThemeToggle = false;

  ThemeState() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    isThemeToggle = prefs.getBool('isThemeToggle') ?? false;
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isThemeToggle', isThemeToggle);
  }

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Maruburi',
    colorScheme: ColorScheme.light(
      primary: Color(0xff1A1918),
      secondary: Colors.grey,
      error: Colors.red,
    ),
    extensions: const [
      CustomTheme(
          colorSubGrey: Color(0xFF4D4D4D),
          colorDeepGrey: Color(0xFF5F5F5F),
          backgroundColor: Color(0xFF4A4442),
          calenderColor: Colors.teal,
          borderColor: Color(0xFFD6D1CC),
          recordCreateColor: Color(0xFFD6D1CC),
          recordTileBorderColor: Color(0xFF625B58))
    ],
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Maruburi',
    colorScheme: ColorScheme.dark(
      primary: Color(0xffF0EFEB),
      secondary: Colors.grey,
      error: Colors.red,
    ),
    extensions: const [
      CustomTheme(
          colorSubGrey: Color(0xFF4D4D4D),
          colorDeepGrey: Color(0xFF5F5F5F),
          backgroundColor: Color(0xFF272423),
          calenderColor: Colors.teal,
          borderColor: Color(0xff1A1918),
          recordCreateColor: Color(0x622D2B29),
          recordTileBorderColor: Color(0xFF272423))
    ],
  );

  ThemeData get currentTheme => isThemeToggle ? _lightTheme : _darkTheme;

  void toggleTheme() {
    isThemeToggle = !isThemeToggle;
    _saveThemePreference();
    notifyListeners();
  }
}
