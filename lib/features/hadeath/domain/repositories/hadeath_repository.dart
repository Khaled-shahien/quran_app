import '../entities/hadeath_entity.dart';

abstract class HadeathRepository {
  Future<List<HadeathEntity>> getAllAhadeth();
}
