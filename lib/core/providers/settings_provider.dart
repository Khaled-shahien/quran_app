import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  // Alarm keys
  static const String _morningAlarmKey = 'morning_alarm_enabled';
  static const String _eveningAlarmKey = 'evening_alarm_enabled';
  static const String _mulkAlarmKey = 'mulk_alarm_enabled';
  static const String _baqarahAlarmKey = 'baqarah_alarm_enabled';

  bool _isMorningAlarmEnabled = false;
  bool _isEveningAlarmEnabled = false;
  bool _isMulkAlarmEnabled = false;
  bool _isBaqarahAlarmEnabled = false;

  SettingsProvider({required this.prefs}) {
    _loadSettings();
  }

  bool get isMorningAlarmEnabled => _isMorningAlarmEnabled;
  bool get isEveningAlarmEnabled => _isEveningAlarmEnabled;
  bool get isMulkAlarmEnabled => _isMulkAlarmEnabled;
  bool get isBaqarahAlarmEnabled => _isBaqarahAlarmEnabled;

  void _loadSettings() {
    _isMorningAlarmEnabled = prefs.getBool(_morningAlarmKey) ?? false;
    _isEveningAlarmEnabled = prefs.getBool(_eveningAlarmKey) ?? false;
    _isMulkAlarmEnabled = prefs.getBool(_mulkAlarmKey) ?? false;
    _isBaqarahAlarmEnabled = prefs.getBool(_baqarahAlarmKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleMorningAlarm(bool value) async {
    _isMorningAlarmEnabled = value;
    await prefs.setBool(_morningAlarmKey, value);
    notifyListeners();
  }

  Future<void> toggleEveningAlarm(bool value) async {
    _isEveningAlarmEnabled = value;
    await prefs.setBool(_eveningAlarmKey, value);
    notifyListeners();
  }

  Future<void> toggleMulkAlarm(bool value) async {
    _isMulkAlarmEnabled = value;
    await prefs.setBool(_mulkAlarmKey, value);
    notifyListeners();
  }

  Future<void> toggleBaqarahAlarm(bool value) async {
    _isBaqarahAlarmEnabled = value;
    await prefs.setBool(_baqarahAlarmKey, value);
    notifyListeners();
  }
}
