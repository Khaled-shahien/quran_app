import '../../../../core/api/base_api_service.dart';
import '../../../../core/api/models/base_response.dart';

/// Sample Quran API Service
///
/// Demonstrates the API service pattern for Quran-related endpoints
class QuranApiService extends BaseApiService {
  static const String _basePath = '/surah';

  /// Get list of all surahs
  Future<BaseResponse<List<SurahModel>>> getSurahs() async {
    try {
      final response = await get('$_basePath/list');
      return BaseResponse.fromJson(
        response,
        (json) =>
            (json as List).map((item) => SurahModel.fromJson(item)).toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get specific surah by number
  Future<BaseResponse<SurahModel>> getSurah(int surahNumber) async {
    try {
      final response = await get('$_basePath/$surahNumber');
      return BaseResponse.fromJson(
        response,
        (json) => SurahModel.fromJson(json),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Search in Quran
  Future<BaseResponse<List<SearchResultModel>>> searchQuran({
    required String query,
    String? language,
    int? page = 1,
    int? limit = 10,
  }) async {
    try {
      final response = await get(
        '/search',
        queryParams: {
          'q': query,
          'language': ?language,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );
      return BaseResponse.fromJson(
        response,
        (json) => (json as List)
            .map((item) => SearchResultModel.fromJson(item))
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Surah Model
class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final String revelationType;
  final int numberOfAyahs;
  final List<AyahModel> ayahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.revelationType,
    required this.numberOfAyahs,
    required this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      revelationType: json['revelationType'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      ayahs: (json['ayahs'] as List)
          .map((item) => AyahModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'name': name,
      'englishName': englishName,
      'englishNameTranslation': englishNameTranslation,
      'revelationType': revelationType,
      'numberOfAyahs': numberOfAyahs,
      'ayahs': ayahs.map((ayah) => ayah.toJson()).toList(),
    };
  }
}

/// Ayah Model
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

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int,
      text: json['text'] as String,
      numberInSurah: json['numberInSurah'] as int,
      juz: json['juz'] as int,
      manzil: json['manzil'] as int,
      page: json['page'] as int,
      ruku: json['ruku'] as int,
      hizbQuarter: json['hizbQuarter'] as int,
      sajda: json['sajda'] as bool,
    );
  }

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
}

/// Search Result Model
class SearchResultModel {
  final int surahNumber;
  final String surahName;
  final int ayahNumber;
  final String text;

  SearchResultModel({
    required this.surahNumber,
    required this.surahName,
    required this.ayahNumber,
    required this.text,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      surahNumber: json['surahNumber'] as int,
      surahName: json['surahName'] as String,
      ayahNumber: json['ayahNumber'] as int,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surahNumber': surahNumber,
      'surahName': surahName,
      'ayahNumber': ayahNumber,
      'text': text,
    };
  }
}
