/// Ayah Entity
///
/// Domain entity representing a single Ayah (verse) of the Quran
class AyahEntity {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahEntity({
    required this.number,
    required this.text,
    required this.numberInSurah,
    required this.juz,
    required this.manzil,
    required this.page,
    required this.ruku,
    required this.hizbQuarter,
    required this.sajda,
  });

  @override
  String toString() {
    return 'AyahEntity('
        'number: $number, text: $text, numberInSurah: $numberInSurah, '
        'juz: $juz, manzil: $manzil, page: $page, ruku: $ruku, '
        'hizbQuarter: $hizbQuarter, sajda: $sajda)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AyahEntity &&
        other.number == number &&
        other.text == text &&
        other.numberInSurah == numberInSurah;
  }

  @override
  int get hashCode {
    return Object.hash(number, text, numberInSurah);
  }
}
