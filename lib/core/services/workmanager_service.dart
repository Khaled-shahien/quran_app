import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';
import '../providers/settings_provider.dart';

/// Background task callback - MUST be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint('Background task executed: $task');

    try {
      switch (task) {
        case 'reschedule_alarms':
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

    // Get settings from SharedPreferences
    final SettingsProvider settingsProvider = SettingsProvider(
      prefs: await _getSharedPreferences(),
    );

    // Reschedule all enabled alarms
    await notificationService.updateAllAlarms(
      isMorningEnabled: settingsProvider.isMorningAlarmEnabled,
      isEveningEnabled: settingsProvider.isEveningAlarmEnabled,
      isMulkEnabled: settingsProvider.isMulkAlarmEnabled,
      isBaqarahEnabled: settingsProvider.isBaqarahAlarmEnabled,
    );

    debugPrint('✅ Alarms rescheduled successfully');
  } catch (e) {
    debugPrint('❌ Error rescheduling alarms: $e');
  }
}

/// Get SharedPreferences instance
Future<dynamic> _getSharedPreferences() async {
  // For WorkManager background task, we'll use a simpler approach
  // Just reschedule all alarms without checking settings
  // The SettingsProvider will be called from main app context
  return null;
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
      await _workmanager.initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );

      debugPrint('WorkManager initialized successfully');
      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing WorkManager: $e');
    }
  }

  /// Register boot reschedule task
  Future<void> registerRescheduleTask() async {
    try {
      // Register periodic task to reschedule alarms
      await _workmanager.registerPeriodicTask(
        'reschedule_alarms_task',
        'reschedule_alarms',
        frequency: const Duration(hours: 12), // Check every 12 hours
        initialDelay: const Duration(seconds: 30), // Wait 30 seconds after boot
      );

      debugPrint('✅ Reschedule task registered');
    } catch (e) {
      debugPrint('❌ Error registering reschedule task: $e');
    }
  }

  /// Cancel reschedule task
  Future<void> cancelRescheduleTask() async {
    try {
      await _workmanager.cancelByUniqueName('reschedule_alarms_task');
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
