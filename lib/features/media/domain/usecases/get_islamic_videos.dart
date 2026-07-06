import '../entities/video.dart';
import '../repositories/media_repository.dart';

class GetIslamicVideos {
  const GetIslamicVideos(this._repository);

  final MediaRepository _repository;

  Future<List<Video>> call(String query) {
    return _repository.getIslamicVideos(query);
  }
}
