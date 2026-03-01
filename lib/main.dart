import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/prayers/presentation/providers/prayer_times_provider.dart';
import 'features/prayers/presentation/providers/prayer_times_performance_provider.dart';
import 'features/prayers/data/data_sources/prayer_times_api_service.dart';
import 'features/prayers/data/repositories/prayer_times_repository_impl.dart';
import 'features/prayers/domain/repositories/prayer_times_repository.dart';
import 'features/quran/data/data_sources/local_surah_data_source.dart';
import 'features/quran/data/repositories/surah_repository.dart';
import 'features/quran/domain/repositories/surah_repository.dart';
import 'features/hadeath/data/data_sources/local_hadeath_data_source.dart';
import 'features/hadeath/data/repositories/hadeath_repository_impl.dart';
import 'features/hadeath/domain/repositories/hadeath_repository.dart';
import 'features/hadeath/presentation/providers/hadeath_provider.dart';
import 'features/duas/data/repositories/azkar_repository.dart';
import 'features/duas/presentation/providers/azkar_provider.dart';
import 'features/duas/data/repositories/duas_repository.dart';
import 'features/duas/presentation/providers/duas_provider.dart';
import 'features/onboarding/presentation/providers/favorites_provider.dart';
import 'features/quran/presentation/providers/bookmark_provider.dart';
import 'core/providers/settings_provider.dart';

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences asynchronously
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Run the app with initialized dependencies
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  // Cache repositories to prevent recreation
  late final PrayerTimesRepository _prayerTimesRepository;
  late final SurahRepository _surahRepository;
  late final HadeathRepository _hadeathRepository;
  late final PrayerTimesProvider _prayerTimesProvider;
  late final PrayerTimesPerformanceProvider _prayerTimesPerformanceProvider;
  late final HadeathProvider _hadeathProvider;
  late final FavoritesProvider _favoritesProvider;
  late final ThemeProvider _themeProvider;
  late final AzkarRepository _azkarRepository;
  late final AzkarProvider _azkarProvider;
  late final DuasRepository _duasRepository;
  late final DuasProvider _duasProvider;
  late final BookmarkProvider _bookmarkProvider;
  late final SettingsProvider _settingsProvider;

  MyApp({super.key, required this.prefs}) {
    // Initialize repositories once during construction (lazy initialization)
    _prayerTimesRepository = PrayerTimesRepositoryImpl(
      apiService: PrayerTimesApiService(),
      sharedPreferences: prefs,
    );

    _surahRepository = SurahRepositoryImpl(
      localDataSource: LocalSurahDataSource(),
      sharedPreferences: prefs,
    );

    _hadeathRepository = HadeathRepositoryImpl(
      localDataSource: LocalHadeathDataSource(),
    );

    _prayerTimesProvider = PrayerTimesProvider(
      repository: _prayerTimesRepository,
    );

    _prayerTimesPerformanceProvider = PrayerTimesPerformanceProvider(
      repository: _prayerTimesRepository,
    );

    _hadeathProvider = HadeathProvider(repository: _hadeathRepository);

    _favoritesProvider = FavoritesProvider(prefs: prefs);

    _themeProvider = ThemeProvider(prefs: prefs);

    _azkarRepository = AzkarRepositoryImpl();
    _azkarProvider = AzkarProvider(repository: _azkarRepository)..loadAzkar();

    _duasRepository = DuasRepositoryImpl();
    _duasProvider = DuasProvider(repository: _duasRepository)..loadDuas();

    _bookmarkProvider = BookmarkProvider(prefs: prefs);
    _settingsProvider = SettingsProvider(prefs: prefs);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide SharedPreferences as a value (no recreation needed)
        Provider<SharedPreferences>.value(value: prefs),

        // Provide repositories as values (pre-initialized)
        Provider<PrayerTimesRepository>.value(value: _prayerTimesRepository),
        Provider<SurahRepository>.value(value: _surahRepository),
        Provider<HadeathRepository>.value(value: _hadeathRepository),

        // Provide providers as values (pre-initialized)
        ChangeNotifierProvider<PrayerTimesProvider>.value(
          value: _prayerTimesProvider,
        ),
        ChangeNotifierProvider<PrayerTimesPerformanceProvider>.value(
          value: _prayerTimesPerformanceProvider,
        ),
        ChangeNotifierProvider<HadeathProvider>.value(value: _hadeathProvider),
        ChangeNotifierProvider<FavoritesProvider>.value(
          value: _favoritesProvider,
        ),
        ChangeNotifierProvider<ThemeProvider>.value(value: _themeProvider),
        ChangeNotifierProvider<AzkarProvider>.value(value: _azkarProvider),
        ChangeNotifierProvider<DuasProvider>.value(value: _duasProvider),
        ChangeNotifierProvider<BookmarkProvider>.value(
          value: _bookmarkProvider,
        ),
        ChangeNotifierProvider<SettingsProvider>.value(
          value: _settingsProvider,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Quran App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: const Locale('ar', 'SA'), // Set default locale to Arabic
            home: const OnboardingScreen(),
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl, // Right-to-left for Arabic
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
