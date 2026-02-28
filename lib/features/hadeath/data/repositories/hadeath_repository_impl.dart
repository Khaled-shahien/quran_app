import '../../domain/entities/hadeath_entity.dart';
import '../../domain/repositories/hadeath_repository.dart';
import '../data_sources/local_hadeath_data_source.dart';

class HadeathRepositoryImpl implements HadeathRepository {
  final LocalHadeathDataSource localDataSource;

  HadeathRepositoryImpl({required this.localDataSource});

  @override
  Future<List<HadeathEntity>> getAllAhadeth() async {
    // The repository delegates the data fetching to the data source
    // It returns a list of HadeathEntity (which HadeathModel extends)
    return await localDataSource.loadAhadeth();
  }
}
