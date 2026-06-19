import 'dart:developer' as developer;
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:quran_app/features/prayers/data/data_sources/prayer_times_api_service.dart';
import 'package:quran_app/features/prayers/domain/repositories/prayer_times_repository.dart';
import 'package:quran_app/features/prayers/data/repositories/prayer_times_repository_impl.dart';

import 'package:quran_app/features/quran/data/data_sources/local_surah_data_source.dart';
import 'package:quran_app/features/quran/domain/repositories/surah_repository.dart';
import 'package:quran_app/features/quran/data/repositories/surah_repository.dart';

import 'package:quran_app/features/hadeath/data/data_sources/local_hadeath_data_source.dart';
import 'package:quran_app/features/hadeath/domain/repositories/hadeath_repository.dart';
import 'package:quran_app/features/hadeath/data/repositories/hadeath_repository_impl.dart';

import 'package:quran_app/features/duas/data/repositories/azkar_repository.dart';
import 'package:quran_app/features/duas/data/repositories/duas_repository.dart';
import 'package:quran_app/features/khatma/data/repositories/khatma_repository.dart';

import 'package:quran_app/core/services/notification_service.dart';
import 'package:quran_app/core/services/firebase_messaging_service.dart';
import 'package:quran_app/core/services/workmanager_service.dart';

/// Global instance for dependency injection based on GetIt.
final GetIt getIt = GetIt.instance;

/// Sets up the dependency injection container.
///
/// This asynchronous function initializes [SharedPreferences] and registers all
/// the data sources and repositories required by the application using [GetIt].
/// It guarantees that our dependencies are correctly instantiated as lazy
/// singletons so they share instances but load strictly upon access.
Future<void> setupServiceLocator() async {
  try {
    // ==========================================
    // Core / External Utilities
    // ==========================================
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(prefs);

    // ==========================================
    // Data Sources
    // ==========================================

    getIt.registerLazySingleton<PrayerTimesApiService>(
      () => PrayerTimesApiService(),
    );

    getIt.registerLazySingleton<LocalSurahDataSource>(
      () => LocalSurahDataSource(),
    );

    getIt.registerLazySingleton<LocalHadeathDataSource>(
      () => LocalHadeathDataSource(),
    );

    // ==========================================
    // Repositories
    // ==========================================

    getIt.registerLazySingleton<PrayerTimesRepository>(
      () => PrayerTimesRepositoryImpl(
        apiService: getIt<PrayerTimesApiService>(),
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    getIt.registerLazySingleton<SurahRepository>(
      () => SurahRepositoryImpl(
        localDataSource: getIt<LocalSurahDataSource>(),
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );

    getIt.registerLazySingleton<HadeathRepository>(
      () => HadeathRepositoryImpl(
        localDataSource: getIt<LocalHadeathDataSource>(),
      ),
    );

    getIt.registerLazySingleton<AzkarRepository>(() => AzkarRepositoryImpl());

    getIt.registerLazySingleton<DuasRepository>(() => DuasRepositoryImpl());

    getIt.registerLazySingleton<KhatmaRepository>(
      () => KhatmaRepository(prefs: getIt<SharedPreferences>()),
    );

    // ==========================================
    // Services
    // ==========================================

    getIt.registerLazySingleton<NotificationService>(
      () => NotificationService(),
    );

    getIt.registerLazySingleton<FirebaseMessagingService>(
      () => FirebaseMessagingService(),
    );

    getIt.registerLazySingleton<WorkManagerService>(() => WorkManagerService());
  } catch (e) {
    developer.log(
      'Service Locator setup failed',
      name: 'quran_app.di',
      error: e,
      level: 1000,
    );
    rethrow;
  }
}
