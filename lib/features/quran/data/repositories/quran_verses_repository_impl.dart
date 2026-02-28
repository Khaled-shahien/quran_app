import '../data_sources/quran_verses_data_source.dart';
import '../../domain/repositories/quran_verses_repository.dart';

/// Quran Verses Repository Implementation
///
/// Implements the QuranVersesRepository interface using QuranVersesDataSource
class QuranVersesRepositoryImpl implements QuranVersesRepository {
  final QuranVersesDataSource _dataSource;

  QuranVersesRepositoryImpl(this._dataSource);

  @override
  Future<List<String>> getVersesForSurah(int surahNumber) {
    return _dataSource.getVersesForSurah(surahNumber);
  }

  @override
  Future<Map<int, List<String>>> getAllVerses() {
    return _dataSource.getAllVerses();
  }

  @override
  Future<int> getVerseCountForSurah(int surahNumber) {
    return _dataSource.getVerseCountForSurah(surahNumber);
  }
}
