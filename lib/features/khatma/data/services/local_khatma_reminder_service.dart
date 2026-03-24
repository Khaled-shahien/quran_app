import '../../../../core/services/notification_service.dart';
import '../../domain/services/khatma_reminder_service.dart';

/// Bridges Khatma reminders to the app notification service.
class LocalKhatmaReminderService implements KhatmaReminderService {
  final NotificationService _notificationService;

  LocalKhatmaReminderService({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  @override
  Future<void> cancelReminder(int notificationId) async {
    await _notificationService.cancelNotification(notificationId);
  }

  @override
  Future<void> scheduleDailyReminder({
    required int notificationId,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    Map<String, dynamic>? payloadData,
  }) async {
    await _notificationService.initialize(requestPermissions: false);
    await _notificationService.cancelNotification(notificationId);
    await _notificationService.scheduleDailyNotification(
      id: notificationId,
      title: title,
      body: body,
      hour: hour,
      minute: minute,
      payload: payload,
      payloadData: payloadData,
    );
  }
}
