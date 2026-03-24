/// Provides reminder operations for the Khatma plan.
///
/// This abstraction keeps notification plugins out of providers so domain
/// behavior can be tested without platform channels.
abstract class KhatmaReminderService {
  /// Schedules a repeating daily reminder.
  Future<void> scheduleDailyReminder({
    required int notificationId,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
    Map<String, dynamic>? payloadData,
  });

  /// Cancels a previously scheduled reminder.
  Future<void> cancelReminder(int notificationId);
}
