/// Surah Entity
///
/// Domain entity representing a Surah (chapter) of the Quran
class SurahEntity {
  final String name;
  final String nameArabic;
  final String nameArabicLong;
  final String translation;
  final String revelationPlace;
  final int totalAyah;

  SurahEntity({
    required this.name,
    required this.nameArabic,
    required this.nameArabicLong,
    required this.translation,
    required this.revelationPlace,
    required this.totalAyah,
  });

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
    return 'SurahEntity(name: $name, nameArabic: $nameArabic, '
        'translation: $translation, revelationPlace: $revelationPlace, '
        'totalAyah: $totalAyah)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SurahEntity &&
        other.name == name &&
        other.nameArabic == nameArabic &&
        other.totalAyah == totalAyah;
  }

  @override
  int get hashCode {
    return Object.hash(name, nameArabic, totalAyah);
  }
}
