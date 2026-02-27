/// Surah Model
///
/// Represents a single Surah (chapter) of the Quran with all its metadata
class SurahModel {
  final String surahName;
  final String surahNameArabic;
  final String surahNameArabicLong;
  final String surahNameTranslation;
  final String revelationPlace;
  final int totalAyah;

  SurahModel({
    required this.surahName,
    required this.surahNameArabic,
    required this.surahNameArabicLong,
    required this.surahNameTranslation,
    required this.revelationPlace,
    required this.totalAyah,
  });

  /// Creates a SurahModel from JSON
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    // Handle different API response formats
    // alquran.cloud API uses different field names
    return SurahModel(
      surahName: json['surahName'] as String? ??
          json['englishName'] as String? ??
          json['name'] as String? ??
          '',
      surahNameArabic: json['surahNameArabic'] as String? ??
          json['name'] as String? ??
          '',
      surahNameArabicLong: json['surahNameArabicLong'] as String? ??
          json['name'] as String? ??
          '',
      surahNameTranslation: json['surahNameTranslation'] as String? ??
          json['englishName'] as String? ??
          '',
      revelationPlace: json['revelationPlace'] as String? ??
          json['revelationType'] as String? ??
          '',
      totalAyah: json['totalAyah'] as int? ??
          json['numberOfAyahs'] as int? ??
          0,
    );
  }

  /// Converts SurahModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'surahName': surahName,
      'surahNameArabic': surahNameArabic,
      'surahNameArabicLong': surahNameArabicLong,
      'surahNameTranslation': surahNameTranslation,
      'revelationPlace': revelationPlace,
      'totalAyah': totalAyah,
    };
  }

  /// Get revelation place in Arabic
  String get revelationPlaceArabic {
    if (revelationPlace.toLowerCase() == 'mecca') {
      return 'مكة';
    } else if (revelationPlace.toLowerCase() == 'madina') {
      return 'المدينة';
    }
    return revelationPlace;
  }

  /// Check if this is a Meccan Surah
  bool get isMeccan => revelationPlace.toLowerCase() == 'mecca';

  /// Check if this is a Median Surah
  bool get isMedian => revelationPlace.toLowerCase() == 'madina';

  @override
  String toString() {
    return 'SurahModel(surahName: $surahName, surahNameArabic: $surahNameArabic, '
        'surahNameTranslation: $surahNameTranslation, revelationPlace: $revelationPlace, '
        'totalAyah: $totalAyah)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurahModel &&
        other.surahName == surahName &&
        other.surahNameArabic == surahNameArabic &&
        other.totalAyah == totalAyah;
  }

  @override
  int get hashCode {
    return Object.hash(surahName, surahNameArabic, totalAyah);
  }
}
