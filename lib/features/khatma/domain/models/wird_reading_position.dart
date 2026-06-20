import 'khatma_model.dart';

class WirdReadingPosition {
  final String khatmaId;
  final KhatmaTrackingUnit trackingUnit;
  final int fromUnit;
  final int toUnit;
  final int surahNumber;
  final int ayahNumber;
  final int pageNumber;
  final int pageIndex;
  final DateTime savedAt;

  const WirdReadingPosition({
    required this.khatmaId,
    required this.trackingUnit,
    required this.fromUnit,
    required this.toUnit,
    required this.surahNumber,
    required this.ayahNumber,
    required this.pageNumber,
    required this.pageIndex,
    required this.savedAt,
  });

  factory WirdReadingPosition.fromJson(Map<String, dynamic> json) {
    Object? readValue(String snake, String camel) => json[snake] ?? json[camel];

    return WirdReadingPosition(
      khatmaId: readValue('khatma_id', 'khatmaId')?.toString() ?? '',
      trackingUnit: KhatmaTrackingUnitX.fromStorage(
        readValue('tracking_unit', 'trackingUnit')?.toString(),
      ),
      fromUnit: _parseInt(readValue('from_unit', 'fromUnit'), fallback: 1),
      toUnit: _parseInt(readValue('to_unit', 'toUnit'), fallback: 1),
      surahNumber: _parseInt(
        readValue('surah_number', 'surahNumber'),
        fallback: 1,
      ),
      ayahNumber: _parseInt(
        readValue('ayah_number', 'ayahNumber'),
        fallback: 1,
      ),
      pageNumber: _parseInt(
        readValue('page_number', 'pageNumber'),
        fallback: 1,
      ),
      pageIndex: _parseInt(readValue('page_index', 'pageIndex'), fallback: 0),
      savedAt: KhatmaModel.parseDateTime(readValue('saved_at', 'savedAt')),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'khatma_id': khatmaId,
      'tracking_unit': trackingUnit.storageValue,
      'from_unit': fromUnit,
      'to_unit': toUnit,
      'surah_number': surahNumber,
      'ayah_number': ayahNumber,
      'page_number': pageNumber,
      'page_index': pageIndex,
      'saved_at': savedAt.toIso8601String(),
    };
  }

  bool matchesCurrentWird(KhatmaModel khatma) {
    return khatmaId == khatma.id &&
        trackingUnit == khatma.trackingUnit &&
        fromUnit == khatma.todayFromUnit &&
        toUnit == khatma.todayToUnit &&
        surahNumber >= 1 &&
        surahNumber <= 114 &&
        ayahNumber >= 1;
  }

  static int _parseInt(Object? value, {required int fallback}) {
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }
}
