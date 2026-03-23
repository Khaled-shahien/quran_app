import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final NotificationService _notificationService = NotificationService();

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

  void _loadSettings() async {
    _isMorningAlarmEnabled = prefs.getBool(_morningAlarmKey) ?? false;
    _isEveningAlarmEnabled = prefs.getBool(_eveningAlarmKey) ?? false;
    _isMulkAlarmEnabled = prefs.getBool(_mulkAlarmKey) ?? false;
    _isBaqarahAlarmEnabled = prefs.getBool(_baqarahAlarmKey) ?? false;

    // Initialize notification service and update alarms
    await _notificationService.initialize();
    await _updateAllAlarms();

    notifyListeners();
  }

  /// Update all alarms based on current settings
  Future<void> _updateAllAlarms() async {
    await _notificationService.updateAllAlarms(
      isMorningEnabled: _isMorningAlarmEnabled,
      isEveningEnabled: _isEveningAlarmEnabled,
      isMulkEnabled: _isMulkAlarmEnabled,
      isBaqarahEnabled: _isBaqarahAlarmEnabled,
    );
  }

  Future<void> toggleMorningAlarm(bool value) async {
    _isMorningAlarmEnabled = value;
    await prefs.setBool(_morningAlarmKey, value);
    await _updateAllAlarms();
    notifyListeners();
  }

  Future<void> toggleEveningAlarm(bool value) async {
    _isEveningAlarmEnabled = value;
    await prefs.setBool(_eveningAlarmKey, value);
    await _updateAllAlarms();
    notifyListeners();
  }

  Future<void> toggleMulkAlarm(bool value) async {
    _isMulkAlarmEnabled = value;
    await prefs.setBool(_mulkAlarmKey, value);
    await _updateAllAlarms();
    notifyListeners();
  }

  Future<void> toggleBaqarahAlarm(bool value) async {
    _isBaqarahAlarmEnabled = value;
    await prefs.setBool(_baqarahAlarmKey, value);
    await _updateAllAlarms();
    notifyListeners();
  }

  /// Set custom alarm time for a specific type
  Future<void> setAlarmTime({
    required String type,
    required int hour,
    required int minute,
  }) async {
    debugPrint(
      'Setting $type alarm to ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
    );

    // First, cancel all alarms to prevent any immediate trigger
    await _notificationService.cancelAllNotifications();
    debugPrint('Cancelled all notifications');

    // Small delay to ensure cancellation completes
    await Future.delayed(const Duration(milliseconds: 300));

    // Save the new time
    await _notificationService.saveAlarmTime(
      type: type,
      hour: hour,
      minute: minute,
    );
    debugPrint('Saved alarm time to preferences');

    // Reschedule the specific alarm if it's enabled
    switch (type) {
      case 'morning':
        if (_isMorningAlarmEnabled) {
          await _notificationService.scheduleMorningAdhkarAlarm(
            hour: hour,
            minute: minute,
          );
          debugPrint('Scheduled morning adhkar alarm');
        }
        break;
      case 'evening':
        if (_isEveningAlarmEnabled) {
          await _notificationService.scheduleEveningAdhkarAlarm(
            hour: hour,
            minute: minute,
          );
          debugPrint('Scheduled evening adhkar alarm');
        }
        break;
      case 'mulk':
        if (_isMulkAlarmEnabled) {
          await _notificationService.scheduleMulkAlarm(
            hour: hour,
            minute: minute,
          );
          debugPrint('Scheduled mulk alarm');
        }
        break;
      case 'baqarah':
        if (_isBaqarahAlarmEnabled) {
          await _notificationService.scheduleBaqarahAlarm(
            hour: hour,
            minute: minute,
          );
          debugPrint('Scheduled baqarah alarm');
        }
        break;
    }

    notifyListeners();
    debugPrint('Alarm time set completed');
  }

  /// Get saved alarm time
  Future<Map<String, int>> getAlarmTime(String type) async {
    return await _notificationService.getAlarmTime(type);
  }
}
