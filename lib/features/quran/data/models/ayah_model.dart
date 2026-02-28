/// Ayah Model
///
/// Represents a single Ayah (verse) of the Quran with all its metadata
class AyahModel {
  final int number;
  final String text;
  final int numberInSurah;
  final int juz;
  final int manzil;
  final int page;
  final int ruku;
  final int hizbQuarter;
  final bool sajda;

  AyahModel({
    this.number = 0,
    required this.text,
    this.numberInSurah = 0,
    this.juz = 0,
    this.manzil = 0,
    this.page = 0,
    this.ruku = 0,
    this.hizbQuarter = 0,
    this.sajda = false,
  });

  /// Creates an AyahModel from JSON
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      numberInSurah: json['numberInSurah'] as int? ?? 0,
      juz: json['juz'] as int? ?? 0,
      manzil: json['manzil'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      ruku: json['ruku'] as int? ?? 0,
      hizbQuarter: json['hizbQuarter'] as int? ?? 0,
      sajda: json['sajda'] as bool? ?? false,
    );
  }

  /// Converts AyahModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'text': text,
      'numberInSurah': numberInSurah,
      'juz': juz,
      'manzil': manzil,
      'page': page,
      'ruku': ruku,
      'hizbQuarter': hizbQuarter,
      'sajda': sajda,
    };
  }

  @override
  String toString() {
    return 'AyahModel(number: $number, text: $text, numberInSurah: $numberInSurah, '
        'juz: $juz, manzil: $manzil, page: $page, ruku: $ruku, '
        'hizbQuarter: $hizbQuarter, sajda: $sajda)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AyahModel &&
        other.number == number &&
        other.text == text &&
        other.numberInSurah == numberInSurah;
  }

  @override
  int get hashCode {
    return Object.hash(number, text, numberInSurah);
  }
}
