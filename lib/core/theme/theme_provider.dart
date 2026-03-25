import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  final SharedPreferences prefs;
  static const String _themeModeKey = 'theme_mode';

  ThemeProvider({required this.prefs}) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => value;

  bool get isDarkMode => value == ThemeMode.dark;

  void _loadThemeMode() {
    final String? themeString = prefs.getString(_themeModeKey);
    if (themeString == 'dark') {
      value = ThemeMode.dark;
    } else if (themeString == 'light') {
      value = ThemeMode.light;
    } else {
      value = ThemeMode.system;
    }
  }

  Future<void> toggleTheme(bool isDark) async {
    value = isDark ? ThemeMode.dark : ThemeMode.light;
    await prefs.setString(_themeModeKey, isDark ? 'dark' : 'light');
  }
}
