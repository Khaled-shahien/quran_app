import 'workmanager_service.dart';

/// Abstraction for background task scheduling triggered by settings updates.
abstract class AlarmRescheduleTaskService {
  Future<void> registerImmediateRescheduleTask({String source});
}

class WorkManagerAlarmRescheduleTaskService
    implements AlarmRescheduleTaskService {
  final WorkManagerService _workManagerService;

  WorkManagerAlarmRescheduleTaskService({
    WorkManagerService? workManagerService,
  }) : _workManagerService = workManagerService ?? WorkManagerService();

  @override
  Future<void> registerImmediateRescheduleTask({
    String source = 'manual_settings_update',
  }) {
    return _workManagerService.registerImmediateRescheduleTask(source: source);
  }
}
