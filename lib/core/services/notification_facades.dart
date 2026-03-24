import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_messaging_service.dart';
import 'notification_service.dart';

/// Abstraction for local notification operations used by providers.
abstract class LocalNotificationGateway {
  Future<void> initialize({bool requestPermissions = false});

  Future<void> requestPermissions();

  Future<void> testNotification({
    required int id,
    required String title,
    required String body,
  });

  Future<void> scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  });

  Future<void> cancelNotification(int id);

  Future<void> cancelAllNotifications();

  Future<List<PendingNotificationRequest>> getPendingNotifications();

  Future<void> updateAllAlarms({
    required bool isMorningEnabled,
    required bool isEveningEnabled,
    required bool isMulkEnabled,
    required bool isBaqarahEnabled,
  });
}

class NotificationServiceGateway implements LocalNotificationGateway {
  final NotificationService _notificationService;

  NotificationServiceGateway({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  @override
  Future<void> cancelAllNotifications() {
    return _notificationService.cancelAllNotifications();
  }

  @override
  Future<void> cancelNotification(int id) {
    return _notificationService.cancelNotification(id);
  }

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() {
    return _notificationService.getPendingNotifications();
  }

  @override
  Future<void> initialize({bool requestPermissions = false}) {
    return _notificationService.initialize(
      requestPermissions: requestPermissions,
    );
  }

  @override
  Future<void> requestPermissions() {
    return _notificationService.requestPermissions();
  }

  @override
  Future<void> scheduleOneTimeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    String? payload,
  }) {
    return _notificationService.scheduleOneTimeNotification(
      id: id,
      title: title,
      body: body,
      scheduledAt: scheduledAt,
      payload: payload,
    );
  }

  @override
  Future<void> testNotification({
    required int id,
    required String title,
    required String body,
  }) {
    return _notificationService.testNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  @override
  Future<void> updateAllAlarms({
    required bool isMorningEnabled,
    required bool isEveningEnabled,
    required bool isMulkEnabled,
    required bool isBaqarahEnabled,
  }) {
    return _notificationService.updateAllAlarms(
      isMorningEnabled: isMorningEnabled,
      isEveningEnabled: isEveningEnabled,
      isMulkEnabled: isMulkEnabled,
      isBaqarahEnabled: isBaqarahEnabled,
    );
  }
}

/// Abstraction for FCM operations used by providers.
abstract class MessagingGateway {
  Future<void> initialize();

  Future<String?> getToken();

  Future<NotificationSettings> getNotificationSettings();

  Future<void> refreshToken();
}

class FirebaseMessagingGateway implements MessagingGateway {
  final FirebaseMessagingService _firebaseMessagingService;

  FirebaseMessagingGateway({FirebaseMessagingService? firebaseMessagingService})
    : _firebaseMessagingService =
          firebaseMessagingService ?? FirebaseMessagingService();

  @override
  Future<String?> getToken() {
    return _firebaseMessagingService.getToken();
  }

  @override
  Future<NotificationSettings> getNotificationSettings() {
    return _firebaseMessagingService.getNotificationSettings();
  }

  @override
  Future<void> initialize() {
    return _firebaseMessagingService.initialize();
  }

  @override
  Future<void> refreshToken() {
    return _firebaseMessagingService.refreshToken();
  }
}
