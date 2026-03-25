// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khatma_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KhatmaDailyLog _$KhatmaDailyLogFromJson(Map<String, dynamic> json) =>
    KhatmaDailyLog(
      date: KhatmaModel.parseDateTime(json['date']),
      unitsRead: json['units_read'] == null
          ? 0
          : KhatmaModel.parseDouble(json['units_read']),
    );

Map<String, dynamic> _$KhatmaDailyLogToJson(KhatmaDailyLog instance) =>
    <String, dynamic>{
      'date': KhatmaModel.dateToJson(instance.date),
      'units_read': instance.unitsRead,
    };

KhatmaCompletedWird _$KhatmaCompletedWirdFromJson(Map<String, dynamic> json) =>
    KhatmaCompletedWird(
      fromUnit: json['from_unit'] == null
          ? 1
          : KhatmaModel.parseInt(json['from_unit']),
      toUnit: json['to_unit'] == null
          ? 1
          : KhatmaModel.parseInt(json['to_unit']),
      completedAt: KhatmaModel.parseDateTime(json['completed_at']),
      isCompleted: json['is_completed'] == null
          ? true
          : KhatmaModel.parseBool(json['is_completed']),
    );

Map<String, dynamic> _$KhatmaCompletedWirdToJson(
  KhatmaCompletedWird instance,
) => <String, dynamic>{
  'from_unit': instance.fromUnit,
  'to_unit': instance.toUnit,
  'completed_at': KhatmaModel.dateToJson(instance.completedAt),
  'is_completed': instance.isCompleted,
};

KhatmaModel _$KhatmaModelFromJson(Map<String, dynamic> json) => KhatmaModel(
  id: json['id'] as String? ?? '',
  startMode: json['start_mode'] as String? ?? 'بداية المصحف',
  startJuz: json['start_juz'] == null
      ? 1
      : KhatmaModel.parseInt(json['start_juz']),
  startDate: KhatmaModel.parseDateTime(json['start_date']),
  trackingUnit:
      $enumDecodeNullable(_$KhatmaTrackingUnitEnumMap, json['tracking_unit']) ??
      KhatmaTrackingUnit.juz,
  goalType:
      $enumDecodeNullable(_$KhatmaGoalTypeEnumMap, json['goal_type']) ??
      KhatmaGoalType.byDuration,
  plannedDurationDays: json['planned_duration_days'] == null
      ? 30
      : KhatmaModel.parseInt(json['planned_duration_days']),
  dailyTargetUnits: json['daily_target_units'] == null
      ? 1
      : KhatmaModel.parseDouble(json['daily_target_units']),
  completedUnits: json['completed_units'] == null
      ? 0
      : KhatmaModel.parseDouble(json['completed_units']),
  reminderHour: json['reminder_hour'] == null
      ? 8
      : KhatmaModel.parseInt(json['reminder_hour']),
  reminderMinute: json['reminder_minute'] == null
      ? 0
      : KhatmaModel.parseInt(json['reminder_minute']),
  isCompleted: json['is_completed'] == null
      ? false
      : KhatmaModel.parseBool(json['is_completed']),
  dailyLogs:
      (json['daily_logs'] as List<dynamic>?)
          ?.map((e) => KhatmaDailyLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KhatmaDailyLog>[],
  completedWirds:
      (json['completed_wirds'] as List<dynamic>?)
          ?.map((e) => KhatmaCompletedWird.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KhatmaCompletedWird>[],
);

Map<String, dynamic> _$KhatmaModelToJson(
  KhatmaModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'start_mode': instance.startMode,
  'start_juz': instance.startJuz,
  'start_date': KhatmaModel.dateToJson(instance.startDate),
  'tracking_unit': _$KhatmaTrackingUnitEnumMap[instance.trackingUnit]!,
  'goal_type': _$KhatmaGoalTypeEnumMap[instance.goalType]!,
  'planned_duration_days': instance.plannedDurationDays,
  'daily_target_units': instance.dailyTargetUnits,
  'completed_units': instance.completedUnits,
  'reminder_hour': instance.reminderHour,
  'reminder_minute': instance.reminderMinute,
  'is_completed': instance.isCompleted,
  'daily_logs': instance.dailyLogs.map((e) => e.toJson()).toList(),
  'completed_wirds': instance.completedWirds.map((e) => e.toJson()).toList(),
};

const _$KhatmaTrackingUnitEnumMap = {
  KhatmaTrackingUnit.page: 'page',
  KhatmaTrackingUnit.hizb: 'hizb',
  KhatmaTrackingUnit.juz: 'juz',
};

const _$KhatmaGoalTypeEnumMap = {
  KhatmaGoalType.byDuration: 'byDuration',
  KhatmaGoalType.byDailyAmount: 'byDailyAmount',
};
