import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_service.dart';
import '../services/firebase_messaging_service.dart';

/// Notification Provider for state management
///
/// Manages:
/// - Permission status
/// - FCM token
/// - Test notification controls
/// - Pending notifications list
class NotificationProvider extends ChangeNotifier {
  final SharedPreferences prefs;
  final NotificationService _notificationService = NotificationService();
  final FirebaseMessagingService _fcmService = FirebaseMessagingService();

  bool _isInitialized = false;
  final bool _isLoading = false;
  String? _fcmToken;
  String? _permissionStatus;
  List<Map<String, dynamic>> _pendingNotifications = [];
  final List<String> _debugLogs = [];

  NotificationProvider({required this.prefs});

  /// Initialize notification services
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _notificationService.initialize();
      await _fcmService.initialize();

      // Get FCM token
      _fcmToken = await _fcmService.getToken();

      // Check permission status
      await _checkPermissionStatus();

      _isInitialized = true;
      _addLog('Notification services initialized');
      notifyListeners();
    } catch (e) {
      _addLog('Error initializing: $e');
      rethrow;
    }
  }

  /// Check notification permissions
  Future<void> _checkPermissionStatus() async {
    try {
      final settings = await _fcmService.getNotificationSettings();
      _permissionStatus = settings.authorizationStatus.name;
      notifyListeners();
    } catch (e) {
      _permissionStatus = 'unknown';
      _addLog('Error checking permissions: $e');
    }
  }

  /// Request notification permissions
  Future<void> requestPermissions() async {
    try {
      await _fcmService.initialize();
      await _checkPermissionStatus();
      _addLog('Permissions requested');
    } catch (e) {
      _addLog('Error requesting permissions: $e');
    }
  }

  /// Schedule immediate test notification
  Future<void> scheduleTestNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      await _notificationService.testNotification(
        id: id,
        title: title,
        body: body,
      );
      _addLog('Test notification shown: $title');
      notifyListeners();
    } catch (e) {
      _addLog('Error showing test notification: $e');
      rethrow;
    }
  }

  /// Schedule notification in 1 minute
  Future<void> scheduleDelayedNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    try {
      final now = DateTime.now();
      final scheduledTime = now.add(const Duration(minutes: 1));

      await _notificationService.scheduleDailyNotification(
        id: id,
        title: title,
        body: body,
        hour: scheduledTime.hour,
        minute: scheduledTime.minute,
      );

      _addLog('Delayed notification scheduled for ${scheduledTime.toString()}');
      notifyListeners();
    } catch (e) {
      _addLog('Error scheduling delayed notification: $e');
      rethrow;
    }
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    try {
      await _notificationService.cancelNotification(id);
      _addLog('Notification cancelled: $id');
      notifyListeners();
    } catch (e) {
      _addLog('Error cancelling notification: $e');
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _notificationService.cancelAllNotifications();
      _addLog('All notifications cancelled');
      notifyListeners();
    } catch (e) {
      _addLog('Error cancelling all notifications: $e');
    }
  }

  /// Get pending notifications
  Future<List<Map<String, dynamic>>> getPendingNotifications() async {
    try {
      final pending = await _notificationService.getPendingNotifications();
      _pendingNotifications = pending
          .map(
            (p) => {
              'id': p.id,
              'title': p.title,
              'body': p.body,
              'payload': p.payload,
            },
          )
          .toList();

      _addLog('Pending notifications: ${_pendingNotifications.length}');
      notifyListeners();
      return _pendingNotifications;
    } catch (e) {
      _addLog('Error getting pending notifications: $e');
      return [];
    }
  }

  /// Refresh FCM token
  Future<void> refreshFCMToken() async {
    try {
      await _fcmService.refreshToken();
      _fcmToken = await _fcmService.getToken();
      _addLog('FCM token refreshed: $_fcmToken');
      notifyListeners();
    } catch (e) {
      _addLog('Error refreshing FCM token: $e');
    }
  }

  /// Copy FCM token to clipboard
  Future<void> copyFCMToken() async {
    if (_fcmToken != null) {
      _addLog('FCM Token copied: $_fcmToken');
      // Clipboard copying handled in UI
    }
  }

  /// Reschedule all alarms
  Future<void> rescheduleAllAlarms() async {
    try {
      await _notificationService.updateAllAlarms(
        isMorningEnabled: prefs.getBool('morning_alarm_enabled') ?? true,
        isEveningEnabled: prefs.getBool('evening_alarm_enabled') ?? true,
        isMulkEnabled: prefs.getBool('mulk_alarm_enabled') ?? true,
        isBaqarahEnabled: prefs.getBool('baqarah_alarm_enabled') ?? true,
      );
      _addLog('All alarms rescheduled');
      notifyListeners();
    } catch (e) {
      _addLog('Error rescheduling alarms: $e');
    }
  }

  /// Add debug log
  void _addLog(String message) {
    final timestamp = DateTime.now().toString().substring(11, 19);
    _debugLogs.insert(0, '[$timestamp] $message');
    if (_debugLogs.length > 50) {
      _debugLogs.removeLast();
    }
    notifyListeners();
  }

  /// Clear debug logs
  void clearLogs() {
    _debugLogs.clear();
    notifyListeners();
  }

  // Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String? get fcmToken => _fcmToken;
  String? get permissionStatus => _permissionStatus;
  List<Map<String, dynamic>> get pendingNotifications => _pendingNotifications;
  List<String> get debugLogs => _debugLogs;
}
