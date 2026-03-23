import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

const String kRescheduleAlarmsTaskName = 'reschedule_alarms';
const String kRescheduleAlarmsPeriodicUniqueName =
  'reschedule_alarms_periodic_task';
const String kRescheduleAlarmsOneOffUniqueName =
  'reschedule_alarms_boot_task';

/// Background task callback - MUST be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task executed: $task');

    try {
      switch (task) {
        case kRescheduleAlarmsTaskName:
          await _handleRescheduleAlarms();
          break;
        default:
          debugPrint('Unknown task: $task');
      }

      return Future.value(true);
    } catch (e) {
      debugPrint('Error in background task: $e');
      return Future.value(false);
    }
  });
}

/// Handle alarm rescheduling
Future<void> _handleRescheduleAlarms() async {
  debugPrint('Rescheduling alarms after boot/update');

  try {
    final NotificationService notificationService = NotificationService();
    await notificationService.initialize();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Reschedule only the alarms enabled in persisted settings.
    await notificationService.updateAllAlarms(
      isMorningEnabled: prefs.getBool('morning_alarm_enabled') ?? false,
      isEveningEnabled: prefs.getBool('evening_alarm_enabled') ?? false,
      isMulkEnabled: prefs.getBool('mulk_alarm_enabled') ?? false,
      isBaqarahEnabled: prefs.getBool('baqarah_alarm_enabled') ?? false,
    );

    debugPrint('✅ Alarms rescheduled successfully');
  } catch (e) {
    debugPrint('❌ Error rescheduling alarms: $e');
  }
}

/// WorkManager Service for background tasks
///
/// Handles:
/// - Boot persistence (reschedule alarms after device restart)
/// - Periodic alarm checks
/// - App update handling
class WorkManagerService {
  static final WorkManagerService _instance = WorkManagerService._internal();
  factory WorkManagerService() => _instance;
  WorkManagerService._internal();

  final Workmanager _workmanager = Workmanager();
  bool _isInitialized = false;

  /// Initialize WorkManager
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _workmanager.initialize(callbackDispatcher);

      debugPrint('WorkManager initialized successfully');
      _isInitialized = true;

      // Keep a periodic safety task registered across app runs/reboots.
      await registerRescheduleTask();
    } catch (e) {
      debugPrint('Error initializing WorkManager: $e');
    }
  }

  /// Register boot reschedule task
  Future<void> registerRescheduleTask() async {
    try {
      // Register periodic task to reschedule alarms as a fallback safety net.
      await _workmanager.registerPeriodicTask(
        kRescheduleAlarmsPeriodicUniqueName,
        kRescheduleAlarmsTaskName,
        existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
        frequency: const Duration(hours: 12),
        initialDelay: const Duration(minutes: 10),
        inputData: {'source': 'periodic'},
      );

      debugPrint('✅ Reschedule task registered');
    } catch (e) {
      debugPrint('❌ Error registering reschedule task: $e');
    }
  }

  /// Register immediate one-off reschedule task (used after boot/update).
  Future<void> registerBootRescheduleTask() async {
    try {
      await _workmanager.registerOneOffTask(
        kRescheduleAlarmsOneOffUniqueName,
        kRescheduleAlarmsTaskName,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        initialDelay: const Duration(seconds: 20),
        inputData: {'source': 'boot_or_update'},
      );
      debugPrint('✅ Boot reschedule task registered');
    } catch (e) {
      debugPrint('❌ Error registering boot reschedule task: $e');
    }
  }

  /// Cancel reschedule task
  Future<void> cancelRescheduleTask() async {
    try {
      await _workmanager.cancelByUniqueName(kRescheduleAlarmsPeriodicUniqueName);
      await _workmanager.cancelByUniqueName(kRescheduleAlarmsOneOffUniqueName);
      debugPrint('Reschedule task cancelled');
    } catch (e) {
      debugPrint('Error cancelling reschedule task: $e');
    }
  }

  /// Cancel all WorkManager tasks
  Future<void> cancelAllTasks() async {
    try {
      await _workmanager.cancelAll();
      debugPrint('All WorkManager tasks cancelled');
    } catch (e) {
      debugPrint('Error cancelling all tasks: $e');
    }
  }

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;
}
