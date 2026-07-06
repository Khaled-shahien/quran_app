import '../entities/reciter.dart';
import '../repositories/media_repository.dart';

class GetReciters {
  const GetReciters(this._repository);

  final MediaRepository _repository;

  Future<List<Reciter>> call() {
    return _repository.getReciters();
  }
}
