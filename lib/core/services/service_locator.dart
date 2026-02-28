import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran_app/features/prayers/data/data_sources/prayer_times_api_service.dart';
import 'package:quran_app/features/prayers/data/repositories/prayer_times_repository_impl.dart';
import 'package:quran_app/features/prayers/domain/repositories/prayer_times_repository.dart';
import 'package:quran_app/features/prayers/presentation/providers/prayer_times_performance_provider.dart';
import 'package:quran_app/features/quran/data/data_sources/local_surah_data_source.dart';
import 'package:quran_app/features/quran/data/repositories/surah_repository.dart';
import 'package:quran_app/features/quran/domain/repositories/surah_repository.dart';

/// Service Locator for Dependency Injection
///
/// Provides centralized dependency management with lazy initialization
/// and proper lifecycle management for better performance and testability.
class ServiceLocator {
  // Singleton instance
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  // Service instances
  SharedPreferences? _sharedPreferences;
  PrayerTimesRepository? _prayerTimesRepository;
  SurahRepository? _surahRepository;
  PrayerTimesPerformanceProvider? _prayerTimesProvider;

  // Data sources
  PrayerTimesApiService? _prayerTimesApiService;
  LocalSurahDataSource? _localSurahDataSource;

  /// Initialize all services
  Future<void> initialize() async {
    // Initialize shared preferences
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  /// Get Shared Preferences instance
  SharedPreferences get sharedPreferences {
    if (_sharedPreferences == null) {
      throw StateError(
        'ServiceLocator not initialized. Call initialize() first.',
      );
    }
    return _sharedPreferences!;
  }

  /// Get Prayer Times API Service
  PrayerTimesApiService get prayerTimesApiService {
    _prayerTimesApiService ??= PrayerTimesApiService();
    return _prayerTimesApiService!;
  }

  /// Get Local Surah Data Source
  LocalSurahDataSource get localSurahDataSource {
    _localSurahDataSource ??= LocalSurahDataSource();
    return _localSurahDataSource!;
  }

  /// Get Prayer Times Repository
  PrayerTimesRepository get prayerTimesRepository {
    _prayerTimesRepository ??= PrayerTimesRepositoryImpl(
      apiService: prayerTimesApiService,
      sharedPreferences: sharedPreferences,
    );
    return _prayerTimesRepository!;
  }

  /// Get Surah Repository
  SurahRepository get surahRepository {
    _surahRepository ??= SurahRepositoryImpl(
      localDataSource: localSurahDataSource,
      sharedPreferences: sharedPreferences,
    );
    return _surahRepository!;
  }

  /// Get Prayer Times Provider (performance optimized)
  PrayerTimesPerformanceProvider get prayerTimesProvider {
    _prayerTimesProvider ??= PrayerTimesPerformanceProvider(
      repository: prayerTimesRepository,
    );
    return _prayerTimesProvider!;
  }

  /// Get all registered providers for MultiProvider
  List<dynamic> getProvidersForMultiProvider() {
    return [
      // Services and Repositories
      _sharedPreferences,
      _prayerTimesApiService,
      _localSurahDataSource,
      prayerTimesRepository,
      surahRepository,
      // Performance-optimized Providers
      prayerTimesProvider,
    ];
  }

  /// Dispose all resources to prevent memory leaks
  void dispose() {
    _prayerTimesProvider?.dispose();
    _sharedPreferences = null;
    _prayerTimesRepository = null;
    _surahRepository = null;
    _prayerTimesProvider = null;
    _prayerTimesApiService = null;
    _localSurahDataSource = null;
  }

  /// Reset all services (useful for testing)
  void reset() {
    dispose();
    _sharedPreferences = null;
  }
}

/// Lazy-Loading Dependency Manager
///
/// Automatically manages object creation and caching to reduce startup time
class LazyDependencyManager {
  final Map<String, dynamic> _instanceCache = {};
  final Map<String, Future<dynamic> Function()> _factories = {};

  /// Register a factory for a service
  void register<T>(String name, Future<T> Function() factory) {
    _factories[name] = factory as Future<dynamic> Function();
  }

  /// Get an instance, creating it if needed
  Future<T> get<T>(String name) async {
    if (_instanceCache.containsKey(name)) {
      return _instanceCache[name] as T;
    }

    if (!_factories.containsKey(name)) {
      throw ArgumentError('No factory registered for $name');
    }

    final instance = await _factories[name]!();
    _instanceCache[name] = instance;
    return instance as T;
  }

  /// Clear cached instances
  void clearCache() {
    _instanceCache.clear();
  }

  /// Clear specific instance
  void clearInstance(String name) {
    _instanceCache.remove(name);
  }
}

/// Feature-Specific Service Locators
///
/// Organize dependencies by feature for better modularity

/// Prayer Times Feature Service Locator
class PrayerTimesServiceLocator {
  static final PrayerTimesServiceLocator _instance =
      PrayerTimesServiceLocator._internal();
  factory PrayerTimesServiceLocator() => _instance;
  PrayerTimesServiceLocator._internal();

  late final PrayerTimesApiService _apiService;
  late final PrayerTimesRepository _repository;
  late final PrayerTimesPerformanceProvider _provider;

  Future<void> initialize() async {
    _apiService = PrayerTimesApiService();
    _repository = PrayerTimesRepositoryImpl(
      apiService: _apiService,
      sharedPreferences: ServiceLocator().sharedPreferences,
    );
    _provider = PrayerTimesPerformanceProvider(repository: _repository);
  }

  PrayerTimesApiService get apiService => _apiService;
  PrayerTimesRepository get repository => _repository;
  PrayerTimesPerformanceProvider get provider => _provider;

  void dispose() {
    _provider.dispose();
  }
}

/// Quran Feature Service Locator
class QuranServiceLocator {
  static final QuranServiceLocator _instance = QuranServiceLocator._internal();
  factory QuranServiceLocator() => _instance;
  QuranServiceLocator._internal();

  late final LocalSurahDataSource _dataSource;
  late final SurahRepository _repository;

  Future<void> initialize() async {
    _dataSource = LocalSurahDataSource();
    _repository = SurahRepositoryImpl(
      localDataSource: _dataSource,
      sharedPreferences: ServiceLocator().sharedPreferences,
    );
  }

  LocalSurahDataSource get dataSource => _dataSource;
  SurahRepository get repository => _repository;
}
