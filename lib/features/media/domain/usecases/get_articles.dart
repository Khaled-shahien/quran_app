import '../entities/article.dart';
import '../repositories/media_repository.dart';

class GetArticles {
  const GetArticles(this._repository);

  final MediaRepository _repository;

  Future<List<Article>> call() {
    return _repository.getArticles();
  }
}
