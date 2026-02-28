import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  static const String _themeModeKey = 'theme_mode';
  late ThemeMode _themeMode;

  ThemeProvider({required this.prefs}) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadThemeMode() {
    final String? themeString = prefs.getString(_themeModeKey);
    if (themeString == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (themeString == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(_themeModeKey, isDark ? 'dark' : 'light');
    notifyListeners();
  }
}
