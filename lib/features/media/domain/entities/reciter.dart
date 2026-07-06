class Reciter {
  final int id;
  final String name;
  final String serverUrl;
  final String surahList;
  final String moshafName;

  const Reciter({
    required this.id,
    required this.name,
    required this.serverUrl,
    required this.surahList,
    required this.moshafName,
  });

  String getAudioUrl(int surahNumber) {
    final paddedNumber = surahNumber.toString().padLeft(3, '0');
    final normalizedServer = serverUrl.endsWith('/')
        ? serverUrl
        : '$serverUrl/';
    return '$normalizedServer$paddedNumber.mp3';
  }

  bool hasSurah(int surahNumber) {
    return surahNumbers.contains(surahNumber);
  }

  List<int> get surahNumbers {
    return surahList
        .split(',')
        .map((value) => int.tryParse(value.trim()))
        .whereType<int>()
        .toList(growable: false);
  }
}
