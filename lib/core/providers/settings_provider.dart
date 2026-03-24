import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/workmanager_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final NotificationService _notificationService = NotificationService();
  final WorkManagerService _workManagerService = WorkManagerService();

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

    notifyListeners();

    // Keep startup responsive: sync alarms in background without adding
    // another startup one-off WorkManager task.
    unawaited(_syncAlarmsFromSettings());
  }

  Future<void> _syncAlarmsFromSettings() async {
    await _notificationService.initialize(requestPermissions: false);
    await _updateAllAlarms();
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
    notifyListeners();

    unawaited(_updateAllAlarms());
    unawaited(
      _workManagerService.registerImmediateRescheduleTask(
        source: 'toggle_morning',
      ),
    );
  }

  Future<void> toggleEveningAlarm(bool value) async {
    _isEveningAlarmEnabled = value;
    await prefs.setBool(_eveningAlarmKey, value);
    notifyListeners();

    unawaited(_updateAllAlarms());
    unawaited(
      _workManagerService.registerImmediateRescheduleTask(
        source: 'toggle_evening',
      ),
    );
  }

  Future<void> toggleMulkAlarm(bool value) async {
    _isMulkAlarmEnabled = value;
    await prefs.setBool(_mulkAlarmKey, value);
    notifyListeners();

    unawaited(_updateAllAlarms());
    unawaited(
      _workManagerService.registerImmediateRescheduleTask(
        source: 'toggle_mulk',
      ),
    );
  }

  Future<void> toggleBaqarahAlarm(bool value) async {
    _isBaqarahAlarmEnabled = value;
    await prefs.setBool(_baqarahAlarmKey, value);
    notifyListeners();

    unawaited(_updateAllAlarms());
    unawaited(
      _workManagerService.registerImmediateRescheduleTask(
        source: 'toggle_baqarah',
      ),
    );
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

    // Save the new time
    await _notificationService.saveAlarmTime(
      type: type,
      hour: hour,
      minute: minute,
    );
    debugPrint('Saved alarm time to preferences');

    // Reschedule only the selected alarm to avoid unnecessary work.
    switch (type) {
      case 'morning':
        await _notificationService.rescheduleSingleAlarm(
          type: type,
          enabled: _isMorningAlarmEnabled,
          hour: hour,
          minute: minute,
        );
        debugPrint('Rescheduled morning adhkar alarm');
        break;
      case 'evening':
        await _notificationService.rescheduleSingleAlarm(
          type: type,
          enabled: _isEveningAlarmEnabled,
          hour: hour,
          minute: minute,
        );
        debugPrint('Rescheduled evening adhkar alarm');
        break;
      case 'mulk':
        await _notificationService.rescheduleSingleAlarm(
          type: type,
          enabled: _isMulkAlarmEnabled,
          hour: hour,
          minute: minute,
        );
        debugPrint('Rescheduled mulk alarm');
        break;
      case 'baqarah':
        await _notificationService.rescheduleSingleAlarm(
          type: type,
          enabled: _isBaqarahAlarmEnabled,
          hour: hour,
          minute: minute,
        );
        debugPrint('Rescheduled baqarah alarm');
        break;
    }

    unawaited(
      _workManagerService.registerImmediateRescheduleTask(
        source: 'set_alarm_time_$type',
      ),
    );

    notifyListeners();
    debugPrint('Alarm time set completed');
  }

  /// Get saved alarm time
  Future<Map<String, int>> getAlarmTime(String type) async {
    return await _notificationService.getAlarmTime(type);
  }
}
