import '../../domain/repositories/surah_repository.dart';
import '../entities/surah_entity.dart';

/// Get All Surahs Usecase
///
/// Business logic for fetching all Surahs from the repository
class GetAllSurahsUsecase {
  final SurahRepository _repository;

  GetAllSurahsUsecase(this._repository);

  /// Execute the usecase to get all Surahs
  Future<List<SurahEntity>> call() async {
    return await _repository.getAllSurahs();
  }
}
