// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'khatma_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KhatmaDailyLog _$KhatmaDailyLogFromJson(Map<String, dynamic> json) =>
    KhatmaDailyLog(
      date: KhatmaModel.parseDateTime(json['date']),
      unitsRead: json['unitsRead'] == null
          ? 0
          : KhatmaModel.parseDouble(json['unitsRead']),
    );

Map<String, dynamic> _$KhatmaDailyLogToJson(KhatmaDailyLog instance) =>
    <String, dynamic>{
      'date': KhatmaModel.dateToJson(instance.date),
      'unitsRead': instance.unitsRead,
    };

KhatmaCompletedWird _$KhatmaCompletedWirdFromJson(Map<String, dynamic> json) =>
    KhatmaCompletedWird(
      fromUnit: json['fromUnit'] == null
          ? 1
          : KhatmaModel.parseInt(json['fromUnit']),
      toUnit: json['toUnit'] == null ? 1 : KhatmaModel.parseInt(json['toUnit']),
      completedAt: KhatmaModel.parseDateTime(json['completedAt']),
      isCompleted: json['isCompleted'] == null
          ? true
          : KhatmaModel.parseBool(json['isCompleted']),
    );

Map<String, dynamic> _$KhatmaCompletedWirdToJson(
  KhatmaCompletedWird instance,
) => <String, dynamic>{
  'fromUnit': instance.fromUnit,
  'toUnit': instance.toUnit,
  'completedAt': KhatmaModel.dateToJson(instance.completedAt),
  'isCompleted': instance.isCompleted,
};

KhatmaModel _$KhatmaModelFromJson(Map<String, dynamic> json) => KhatmaModel(
  id: json['id'] as String? ?? '',
  startMode: json['startMode'] as String? ?? 'بداية المصحف',
  startJuz: json['startJuz'] == null
      ? 1
      : KhatmaModel.parseInt(json['startJuz']),
  startDate: KhatmaModel.parseDateTime(json['startDate']),
  trackingUnit:
      $enumDecodeNullable(_$KhatmaTrackingUnitEnumMap, json['trackingUnit']) ??
      KhatmaTrackingUnit.juz,
  goalType:
      $enumDecodeNullable(_$KhatmaGoalTypeEnumMap, json['goalType']) ??
      KhatmaGoalType.byDuration,
  plannedDurationDays: json['plannedDurationDays'] == null
      ? 30
      : KhatmaModel.parseInt(json['plannedDurationDays']),
  dailyTargetUnits: json['dailyTargetUnits'] == null
      ? 1
      : KhatmaModel.parseDouble(json['dailyTargetUnits']),
  completedUnits: json['completedUnits'] == null
      ? 0
      : KhatmaModel.parseDouble(json['completedUnits']),
  reminderHour: json['reminderHour'] == null
      ? 8
      : KhatmaModel.parseInt(json['reminderHour']),
  reminderMinute: json['reminderMinute'] == null
      ? 0
      : KhatmaModel.parseInt(json['reminderMinute']),
  isCompleted: json['isCompleted'] == null
      ? false
      : KhatmaModel.parseBool(json['isCompleted']),
  dailyLogs:
      (json['dailyLogs'] as List<dynamic>?)
          ?.map((e) => KhatmaDailyLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KhatmaDailyLog>[],
  completedWirds:
      (json['completedWirds'] as List<dynamic>?)
          ?.map((e) => KhatmaCompletedWird.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <KhatmaCompletedWird>[],
);

Map<String, dynamic> _$KhatmaModelToJson(KhatmaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startMode': instance.startMode,
      'startJuz': instance.startJuz,
      'startDate': KhatmaModel.dateToJson(instance.startDate),
      'trackingUnit': _$KhatmaTrackingUnitEnumMap[instance.trackingUnit]!,
      'goalType': _$KhatmaGoalTypeEnumMap[instance.goalType]!,
      'plannedDurationDays': instance.plannedDurationDays,
      'dailyTargetUnits': instance.dailyTargetUnits,
      'completedUnits': instance.completedUnits,
      'reminderHour': instance.reminderHour,
      'reminderMinute': instance.reminderMinute,
      'isCompleted': instance.isCompleted,
      'dailyLogs': instance.dailyLogs.map((e) => e.toJson()).toList(),
      'completedWirds': instance.completedWirds.map((e) => e.toJson()).toList(),
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
