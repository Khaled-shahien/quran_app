import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';

/// Notification Service for managing alarms and notifications
///
/// This service handles:
/// - Morning Adhkar alarm (7:00 AM)
/// - Evening Adhkar alarm (5:30 PM)
/// - Surah Al-Mulk alarm (9:00 PM)
/// - Surah Al-Baqarah alarm (8:30 PM)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Notification IDs
  static const int _morningAdhkarNotificationId = 1001;
  static const int _eveningAdhkarNotificationId = 1002;
  static const int _mulkNotificationId = 1003;
  static const int _baqarahNotificationId = 1004;

  // Alarm time keys
  static const String _morningAlarmHourKey = 'morning_alarm_hour';
  static const String _morningAlarmMinuteKey = 'morning_alarm_minute';
  static const String _eveningAlarmHourKey = 'evening_alarm_hour';
  static const String _eveningAlarmMinuteKey = 'evening_alarm_minute';
  static const String _mulkAlarmHourKey = 'mulk_alarm_hour';
  static const String _mulkAlarmMinuteKey = 'mulk_alarm_minute';
  static const String _baqarahAlarmHourKey = 'baqarah_alarm_hour';
  static const String _baqarahAlarmMinuteKey = 'baqarah_alarm_minute';

  // Default times
  static const int _defaultMorningHour = 7;
  static const int _defaultMorningMinute = 0;
  static const int _defaultEveningHour = 17; // 5 PM
  static const int _defaultEveningMinute = 30;
  static const int _defaultMulkHour = 21; // 9 PM
  static const int _defaultMulkMinute = 0;
  static const int _defaultBaqarahHour = 20; // 8 PM
  static const int _defaultBaqarahMinute = 30;

  bool _isInitialized = false;

  /// Initialize the notification service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    // Android initialization settings
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Combined initialization settings
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();

    _isInitialized = true;
    debugPrint('Notification Service initialized successfully');
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Android 13+ requires explicit permission request
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidImplementation != null) {
      final bool? granted = await androidImplementation
          .requestNotificationsPermission();
      debugPrint('Android notification permission granted: $granted');
    }

    // iOS permissions
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();

    if (iosImplementation != null) {
      await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // You can add navigation logic here based on the notification payload
  }

  /// Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'quran_app_channel',
          'Quran App Notifications',
          channelDescription: 'Notifications for Quran App reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// Schedule a daily notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // Add 2-minute buffer to prevent immediate triggering
    final twoMinutesFromNow = now.add(const Duration(minutes: 2));

    // If the time is in the past or within 2 minutes, schedule for tomorrow
    if (scheduledDate.isBefore(twoMinutesFromNow)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    debugPrint(
      'Scheduling notification $id for ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} '
      'at ${scheduledDate.toString()}',
    );
    debugPrint('Current time: ${now.toString()}');
    debugPrint('Two minutes from now: ${twoMinutesFromNow.toString()}');
    debugPrint(
      'Will appear today: ${!scheduledDate.isAfter(now.add(const Duration(days: 1)))}',
    );

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'quran_alarms_channel',
          'Quran App Alarms',
          channelDescription: 'Daily alarms for adhkar and surah reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          category: AndroidNotificationCategory.reminder,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // Use dateAndTime for exact one-time scheduling instead of recurring daily
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      payload: payload,
    );

    debugPrint('✅ Notification $id scheduled for ${scheduledDate.toString()}');
    debugPrint(
      '📅 Will trigger at: ${scheduledDate.day}/${scheduledDate.month} ${scheduledDate.hour}:${scheduledDate.minute.toString().padLeft(2, '0')}',
    );
  }

  /// Cancel a scheduled notification
  Future<void> cancelNotification(int id) async {
    if (!_isInitialized) await initialize();
    await flutterLocalNotificationsPlugin.cancel(id);
    debugPrint('Cancelled notification $id');
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    if (!_isInitialized) await initialize();
    await flutterLocalNotificationsPlugin.cancelAll();
    debugPrint('Cancelled all notifications');
  }

  // ==================== MORNING ADHKAR ALARM ====================

  /// Schedule morning adhkar alarm
  Future<void> scheduleMorningAdhkarAlarm({int? hour, int? minute}) async {
    final prefs = await SharedPreferences.getInstance();
    final h = hour ?? prefs.getInt(_morningAlarmHourKey) ?? _defaultMorningHour;
    final m =
        minute ?? prefs.getInt(_morningAlarmMinuteKey) ?? _defaultMorningMinute;

    await scheduleDailyNotification(
      id: _morningAdhkarNotificationId,
      title: '⏰ تذكير أذكار الصباح',
      body:
          'حان وقت أذكار الصباح. اللهم ما أصبح بك من نعمة أو بأحد من خلقك فمنك وحدك لا شريك لك، فلك الحمد ولك الشكر',
      hour: h,
      minute: m,
      payload: 'morning_adhkar',
    );
  }

  /// Cancel morning adhkar alarm
  Future<void> cancelMorningAdhkarAlarm() async {
    await cancelNotification(_morningAdhkarNotificationId);
  }

  // ==================== EVENING ADHKAR ALARM ====================

  /// Schedule evening adhkar alarm
  Future<void> scheduleEveningAdhkarAlarm({int? hour, int? minute}) async {
    final prefs = await SharedPreferences.getInstance();
    final h = hour ?? prefs.getInt(_eveningAlarmHourKey) ?? _defaultEveningHour;
    final m =
        minute ?? prefs.getInt(_eveningAlarmMinuteKey) ?? _defaultEveningMinute;

    await scheduleDailyNotification(
      id: _eveningAdhkarNotificationId,
      title: '⏰ تذكير أذكار المساء',
      body:
          'حان وقت أذكار المساء. أمسينا وأمسى الملك لله، والحمد لله، لا إله إلا الله وحده لا شريك له',
      hour: h,
      minute: m,
      payload: 'evening_adhkar',
    );
  }

  /// Cancel evening adhkar alarm
  Future<void> cancelEveningAdhkarAlarm() async {
    await cancelNotification(_eveningAdhkarNotificationId);
  }

  // ==================== SURAH AL-MULK ALARM ====================

  /// Schedule Surah Al-Mulk alarm
  Future<void> scheduleMulkAlarm({int? hour, int? minute}) async {
    final prefs = await SharedPreferences.getInstance();
    final h = hour ?? prefs.getInt(_mulkAlarmHourKey) ?? _defaultMulkHour;
    final m = minute ?? prefs.getInt(_mulkAlarmMinuteKey) ?? _defaultMulkMinute;

    await scheduleDailyNotification(
      id: _mulkNotificationId,
      title: '⏰ تذكير سورة الملك',
      body:
          'حان وقت قراءة سورة الملك. قال صلى الله عليه وسلم: "إن سورة من القرآن ثلاثون آية شفعت لرجل حتى غفر له: تبارك الذي بيده الملك"',
      hour: h,
      minute: m,
      payload: 'mulk_surah',
    );
  }

  /// Cancel Surah Al-Mulk alarm
  Future<void> cancelMulkAlarm() async {
    await cancelNotification(_mulkNotificationId);
  }

  // ==================== SURAH AL-BAQARAH ALARM ====================

  /// Schedule Surah Al-Baqarah alarm
  Future<void> scheduleBaqarahAlarm({int? hour, int? minute}) async {
    final prefs = await SharedPreferences.getInstance();
    final h = hour ?? prefs.getInt(_baqarahAlarmHourKey) ?? _defaultBaqarahHour;
    final m =
        minute ?? prefs.getInt(_baqarahAlarmMinuteKey) ?? _defaultBaqarahMinute;

    await scheduleDailyNotification(
      id: _baqarahNotificationId,
      title: '⏰ تذكير سورة البقرة',
      body:
          'حان وقت قراءة سورة البقرة. قال صلى الله عليه وسلم: "اقرأوا سورة البقرة، فإن أخذها بركة وتركها حسرة ولا تستطيعها البطلة"',
      hour: h,
      minute: m,
      payload: 'baqarah_surah',
    );
  }

  /// Cancel Surah Al-Baqarah alarm
  Future<void> cancelBaqarahAlarm() async {
    await cancelNotification(_baqarahNotificationId);
  }

  // ==================== UPDATE ALL ALARMS ====================

  /// Update all active alarms based on settings
  Future<void> updateAllAlarms({
    required bool isMorningEnabled,
    required bool isEveningEnabled,
    required bool isMulkEnabled,
    required bool isBaqarahEnabled,
  }) async {
    // Cancel all first
    await cancelAllNotifications();

    // Reschedule enabled alarms
    if (isMorningEnabled) {
      await scheduleMorningAdhkarAlarm();
    }
    if (isEveningEnabled) {
      await scheduleEveningAdhkarAlarm();
    }
    if (isMulkEnabled) {
      await scheduleMulkAlarm();
    }
    if (isBaqarahEnabled) {
      await scheduleBaqarahAlarm();
    }

    debugPrint(
      'Updated all alarms. Morning: $isMorningEnabled, Evening: $isEveningEnabled, Mulk: $isMulkEnabled, Baqarah: $isBaqarahEnabled',
    );
  }

  /// Save alarm time to preferences
  Future<void> saveAlarmTime({
    required String type,
    required int hour,
    required int minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case 'morning':
        await prefs.setInt(_morningAlarmHourKey, hour);
        await prefs.setInt(_morningAlarmMinuteKey, minute);
        break;
      case 'evening':
        await prefs.setInt(_eveningAlarmHourKey, hour);
        await prefs.setInt(_eveningAlarmMinuteKey, minute);
        break;
      case 'mulk':
        await prefs.setInt(_mulkAlarmHourKey, hour);
        await prefs.setInt(_mulkAlarmMinuteKey, minute);
        break;
      case 'baqarah':
        await prefs.setInt(_baqarahAlarmHourKey, hour);
        await prefs.setInt(_baqarahAlarmMinuteKey, minute);
        break;
    }

    debugPrint('Saved $type alarm time: $hour:$minute');
  }

  /// Get saved alarm time
  Future<Map<String, int>> getAlarmTime(String type) async {
    final prefs = await SharedPreferences.getInstance();
    int hour = 0;
    int minute = 0;

    switch (type) {
      case 'morning':
        hour = prefs.getInt(_morningAlarmHourKey) ?? _defaultMorningHour;
        minute = prefs.getInt(_morningAlarmMinuteKey) ?? _defaultMorningMinute;
        break;
      case 'evening':
        hour = prefs.getInt(_eveningAlarmHourKey) ?? _defaultEveningHour;
        minute = prefs.getInt(_eveningAlarmMinuteKey) ?? _defaultEveningMinute;
        break;
      case 'mulk':
        hour = prefs.getInt(_mulkAlarmHourKey) ?? _defaultMulkHour;
        minute = prefs.getInt(_mulkAlarmMinuteKey) ?? _defaultMulkMinute;
        break;
      case 'baqarah':
        hour = prefs.getInt(_baqarahAlarmHourKey) ?? _defaultBaqarahHour;
        minute = prefs.getInt(_baqarahAlarmMinuteKey) ?? _defaultBaqarahMinute;
        break;
    }

    return {'hour': hour, 'minute': minute};
  }

  /// Test notification - shows immediate notification to verify system works
  Future<void> testNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (!_isInitialized) await initialize();

    debugPrint('🧪 TEST NOTIFICATION: $title');
    debugPrint('Body: $body');

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'For testing notification system',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: 'test',
    );

    debugPrint('✅ Test notification shown successfully');
  }

  /// Check pending notifications
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    if (!_isInitialized) await initialize();

    final pending = await flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    debugPrint('📋 Pending notifications: ${pending.length}');
    for (var notification in pending) {
      debugPrint('  - ID: ${notification.id}, Title: ${notification.title}');
    }
    return pending;
  }
}
