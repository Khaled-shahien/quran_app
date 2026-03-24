import 'package:flutter/material.dart';
import '../../domain/models/khatma_model.dart';
import '../../data/repositories/khatma_repository.dart';
import '../../domain/services/khatma_reminder_service.dart';
import '../../data/services/local_khatma_reminder_service.dart';

class KhatmaProvider extends ChangeNotifier {
  static const int _khatmaReminderNotificationId = 1205;

  final KhatmaRepository repository;
  final KhatmaReminderService _reminderService;
  KhatmaModel? _activeKhatma;

  KhatmaProvider({
    required this.repository,
    KhatmaReminderService? reminderService,
  }) : _reminderService = reminderService ?? LocalKhatmaReminderService() {
    _loadActiveKhatma();
  }

  KhatmaModel? get activeKhatma => _activeKhatma;
  bool get hasActiveKhatma => _activeKhatma != null;

  double get progressValue => _activeKhatma?.progress ?? 0;

  KhatmaReportSummary? get weeklySummary => _activeKhatma?.summaryForDays(7);

  KhatmaReportSummary? get monthlySummary => _activeKhatma?.summaryForDays(30);

  void _loadActiveKhatma() {
    _activeKhatma = repository.getActiveKhatma();
    notifyListeners();
  }

  Future<void> startNewKhatma(KhatmaModel khatma) async {
    await repository.saveKhatma(khatma);
    _activeKhatma = khatma;
    await _scheduleKhatmaReminder(khatma);
    notifyListeners();
  }

  Future<void> markCurrentWirdAsFinished() async {
    if (_activeKhatma == null) return;

    final KhatmaModel current = _activeKhatma!;
    final double readUnits = current.recommendedDailyTarget < 1
        ? 1
        : current.recommendedDailyTarget;
    final int completedFrom = current.todayFromUnit;
    final int completedTo = current.todayToUnit;

    final double nextCompleted = (current.completedUnits + readUnits).clamp(
      0,
      current.plannedUnits.toDouble(),
    );

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final List<KhatmaDailyLog> nextLogs = List<KhatmaDailyLog>.from(
      current.dailyLogs,
    );

    final int existingIndex = nextLogs.indexWhere(
      (log) =>
          log.date.year == today.year &&
          log.date.month == today.month &&
          log.date.day == today.day,
    );

    if (existingIndex >= 0) {
      final KhatmaDailyLog existing = nextLogs[existingIndex];
      nextLogs[existingIndex] = KhatmaDailyLog(
        date: existing.date,
        unitsRead: existing.unitsRead + readUnits,
      );
    } else {
      nextLogs.add(KhatmaDailyLog(date: now, unitsRead: readUnits));
    }

    final List<KhatmaCompletedWird> nextCompletedWirds =
        List<KhatmaCompletedWird>.from(current.completedWirds)..add(
          KhatmaCompletedWird(
            fromUnit: completedFrom,
            toUnit: completedTo,
            completedAt: now,
          ),
        );

    final bool completed = nextCompleted >= current.plannedUnits;
    final KhatmaModel updatedKhatma = current.copyWith(
      completedUnits: nextCompleted,
      isCompleted: completed,
      dailyLogs: nextLogs,
      completedWirds: nextCompletedWirds,
    );

    await repository.saveKhatma(updatedKhatma);
    _activeKhatma = updatedKhatma;

    if (completed) {
      await _reminderService.cancelReminder(_khatmaReminderNotificationId);
    }

    notifyListeners();
  }

  Future<void> completeKhatma() async {
    if (_activeKhatma != null) {
      final updatedKhatma = _activeKhatma!.copyWith(
        isCompleted: true,
        completedUnits: _activeKhatma!.plannedUnits.toDouble(),
      );
      await repository.saveKhatma(updatedKhatma);
      await _reminderService.cancelReminder(_khatmaReminderNotificationId);
      _activeKhatma = updatedKhatma;
      notifyListeners();
    }
  }

  Future<void> updateDailyTarget(double targetUnits) async {
    if (_activeKhatma == null) return;
    final KhatmaModel updatedKhatma = _activeKhatma!.copyWith(
      dailyTargetUnits: targetUnits.clamp(1, 2000),
      goalType: KhatmaGoalType.byDailyAmount,
    );
    await repository.saveKhatma(updatedKhatma);
    _activeKhatma = updatedKhatma;
    await _scheduleKhatmaReminder(updatedKhatma);
    notifyListeners();
  }

  Future<void> updateReminderTime(TimeOfDay reminder) async {
    if (_activeKhatma == null) return;
    final KhatmaModel updatedKhatma = _activeKhatma!.copyWith(
      reminderHour: reminder.hour,
      reminderMinute: reminder.minute,
    );
    await repository.saveKhatma(updatedKhatma);
    _activeKhatma = updatedKhatma;
    await _scheduleKhatmaReminder(updatedKhatma);
    notifyListeners();
  }

  Future<void> resumeAfterGap() async {
    if (_activeKhatma == null) return;
    final KhatmaModel current = _activeKhatma!;
    if (current.goalType != KhatmaGoalType.byDuration || current.isCompleted) {
      return;
    }

    final DateTime now = DateTime.now();
    final int daysPassed =
        DateTime(now.year, now.month, now.day)
            .difference(
              DateTime(
                current.startDate.year,
                current.startDate.month,
                current.startDate.day,
              ),
            )
            .inDays +
        1;

    final int daysLeft = (current.plannedDurationDays - (daysPassed - 1)).clamp(
      1,
      3650,
    );
    final double recalculatedTarget = current.remainingUnits / daysLeft;

    final KhatmaModel updatedKhatma = current.copyWith(
      dailyTargetUnits: recalculatedTarget,
    );
    await repository.saveKhatma(updatedKhatma);
    _activeKhatma = updatedKhatma;
    await _scheduleKhatmaReminder(updatedKhatma);
    notifyListeners();
  }

  Future<void> cancelKhatma() async {
    await _reminderService.cancelReminder(_khatmaReminderNotificationId);
    await repository.deleteActiveKhatma();
    _activeKhatma = null;
    notifyListeners();
  }

  Future<void> _scheduleKhatmaReminder(KhatmaModel khatma) async {
    if (khatma.isCompleted) {
      await _reminderService.cancelReminder(_khatmaReminderNotificationId);
      return;
    }

    await _reminderService.scheduleDailyReminder(
      notificationId: _khatmaReminderNotificationId,
      title: 'ورد الختمة اليومي',
      body:
          'لا تنس وردك اليوم: ${khatma.amountValue} (من ${khatma.todayFromUnit} إلى ${khatma.todayToUnit})',
      hour: khatma.reminderHour,
      minute: khatma.reminderMinute,
      payload: 'khatma',
      payloadData: <String, dynamic>{
        'feature': 'khatma',
        'khatmaId': khatma.id,
      },
    );
  }
}
