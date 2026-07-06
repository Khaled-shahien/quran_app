import '../entities/reciter.dart';
import '../entities/surah_audio.dart';
import '../repositories/media_repository.dart';

class GetSurahAudios {
  const GetSurahAudios(this._repository);

  final MediaRepository _repository;

  Future<List<SurahAudio>> call(Reciter reciter) {
    return _repository.getSurahAudios(reciter);
  }
}
