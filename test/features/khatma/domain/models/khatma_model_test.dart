import 'package:flutter_test/flutter_test.dart';
import 'package:quran_app/features/khatma/domain/models/khatma_model.dart';

void main() {
  group('KhatmaModel', () {
    test('computes planning fields from start juz and tracking unit', () {
      final model = KhatmaModel(
        id: '1',
        startMode: 'بداية المصحف',
        startJuz: 2,
        startDate: DateTime(2026, 3, 1),
        trackingUnit: KhatmaTrackingUnit.page,
        goalType: KhatmaGoalType.byDailyAmount,
        plannedDurationDays: 30,
        dailyTargetUnits: 10,
        completedUnits: 0,
        reminderHour: 8,
        reminderMinute: 0,
      );

      expect(model.startUnitIndex, 21);
      expect(model.plannedUnits, 584);
      expect(model.progress, 0);
      expect(model.todayFromUnit, 21);
      expect(model.todayToUnit, 30);
    });

    test('parses legacy fields and keeps backward compatibility values', () {
      final json = <String, dynamic>{
        'id': 'legacy',
        'startMode': 'جزء مخصص',
        'startJuz': 1,
        'durationDays': 20,
        'amountType': 'ربع',
        'amountValue': 'ربعان',
        'startDate': DateTime(2026, 3, 1).toIso8601String(),
        'currentJuz': 3,
      };

      final model = KhatmaModel.fromJson(json);

      expect(model.trackingUnit, KhatmaTrackingUnit.hizb);
      expect(model.plannedDurationDays, 20);
      expect(model.dailyTargetUnits, 1);
      expect(model.completedUnits, 2);
      expect(model.amountType, 'حزب');
    });

    test('summaryForDays returns read amount in time window', () {
      final now = DateTime.now();
      final model = KhatmaModel(
        id: '2',
        startMode: 'بداية المصحف',
        startJuz: 1,
        startDate: DateTime(2026, 3, 1),
        trackingUnit: KhatmaTrackingUnit.juz,
        goalType: KhatmaGoalType.byDailyAmount,
        plannedDurationDays: 30,
        dailyTargetUnits: 1,
        completedUnits: 4,
        reminderHour: 8,
        reminderMinute: 0,
        dailyLogs: <KhatmaDailyLog>[
          KhatmaDailyLog(
            date: now.subtract(const Duration(days: 1)),
            unitsRead: 1,
          ),
          KhatmaDailyLog(
            date: now.subtract(const Duration(days: 3)),
            unitsRead: 2,
          ),
          KhatmaDailyLog(
            date: now.subtract(const Duration(days: 10)),
            unitsRead: 5,
          ),
        ],
      );

      final summary = model.summaryForDays(7);

      expect(summary.readUnits, 3);
      expect(summary.remainingUnits, 26);
      expect(summary.progress, closeTo(4 / 30, 0.0001));
    });
  });
}
