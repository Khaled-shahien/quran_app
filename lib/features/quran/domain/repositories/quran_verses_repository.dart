/// Quran Verses Repository Interface
///
/// Defines the contract for accessing Quran verses data
abstract class QuranVersesRepository {
  /// Gets all verses for a specific Surah
  ///
  /// Parameters:
  /// - [surahNumber]: The Surah number (1-114)
  ///
  /// Returns: Future<List<String>> - List of verses for the specified Surah
  /// Throws: Exception if the data cannot be retrieved
  Future<List<String>> getVersesForSurah(int surahNumber);

  /// Gets all verses for all Surahs
  ///
  /// Returns: Future<Map<int, List<String>>>
  /// Where the key is the Surah number and the value is the list of verses
  /// Throws: Exception if the data cannot be retrieved
  Future<Map<int, List<String>>> getAllVerses();

  /// Gets the total number of verses in a specific Surah
  ///
  /// Parameters:
  /// - [surahNumber]: The Surah number (1-114)
  ///
  /// Returns: Future<int> - Number of verses in the specified Surah
  /// Throws: Exception if the data cannot be retrieved
  Future<int> getVerseCountForSurah(int surahNumber);
}
