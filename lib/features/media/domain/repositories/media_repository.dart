import '../entities/article.dart';
import '../entities/reciter.dart';
import '../entities/surah_audio.dart';
import '../entities/video.dart';

abstract class MediaRepository {
  Future<List<Article>> getArticles();

  Future<List<Reciter>> getReciters();

  Future<List<SurahAudio>> getSurahAudios(Reciter reciter);

  Future<List<Video>> getIslamicVideos(String query);
}
