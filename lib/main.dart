import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/navigation/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/navigation/notification_router.dart';
import 'core/providers/notification_provider.dart';
import 'features/prayers/presentation/providers/prayer_times_provider.dart';
import 'features/prayers/presentation/providers/'
    'prayer_times_performance_provider.dart';
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
import 'core/services/workmanager_service.dart';
import 'core/services/firebase_messaging_service.dart';
import 'features/khatma/data/repositories/khatma_repository.dart';
import 'features/khatma/presentation/providers/khatma_provider.dart';

void _handleNotificationNavigation(String route, Map<String, dynamic>? data) {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;

  switch (route) {
    case '/duas':
      final String? dhikrType = data?['type']?.toString();
      if (dhikrType == 'morning') {
        context.go('/duas/morning');
      } else if (dhikrType == 'evening') {
        context.go('/duas/evening');
      } else {
        context.go('/duas');
      }
      break;
    case '/quran':
      context.go('/quran');
      break;
    case '/prayers':
      context.go('/prayers');
      break;
    case '/':
    default:
      context.go('/home');
      break;
  }
}

void main() async {
  // Ensure Flutter binding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase Core FIRST (required before any Firebase services)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    developer.log(
      'Firebase Core initialized successfully',
      name: 'quran_app.main',
    );

    // Register FCM background handler as early as possible.
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    developer.log('FCM background handler registered', name: 'quran_app.main');

    // Initialize SharedPreferences (fast operation)
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Run app immediately, then finish non-critical setup in background.
    runApp(MyApp(prefs: prefs));
    unawaited(_initializeBackgroundServices());
  } catch (e) {
    developer.log(
      'Critical error in main',
      name: 'quran_app.main',
      level: 1000,
      error: e,
    );
    // Try to run app anyway with minimal initialization
    SharedPreferences.getInstance().then((prefs) {
      runApp(MyApp(prefs: prefs));
    });
  }
}

Future<void> _initializeBackgroundServices() async {
  try {
    final FirebaseMessagingService firebaseMessagingService =
        FirebaseMessagingService();
    await firebaseMessagingService.initialize();

    final NotificationService notificationService = NotificationService();
    await notificationService
        .initialize(requestPermissions: false)
        .timeout(
          const Duration(seconds: 2),
          onTimeout: () {
            developer.log(
              'Notification initialization timeout - continuing anyway',
              name: 'quran_app.main',
              level: 900,
            );
          },
        )
        .catchError((error) {
          developer.log(
            'Notification initialization error',
            name: 'quran_app.main',
            level: 1000,
            error: error,
          );
        });

    // Initialize background task scheduler for boot/update alarm recovery.
    final WorkManagerService workManagerService = WorkManagerService();
    await workManagerService.initialize();
    await workManagerService.registerBootRescheduleTask();
  } catch (e) {
    developer.log(
      'Background services initialization error',
      name: 'quran_app.main',
      level: 1000,
      error: e,
    );
  }
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final bool initializeNotifications;

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
  late final KhatmaRepository _khatmaRepository;
  late final KhatmaProvider _khatmaProvider;
  late final NotificationProvider _notificationProvider;

  MyApp({super.key, required this.prefs, this.initializeNotifications = true}) {
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

    _khatmaRepository = KhatmaRepository(prefs: prefs);
    _khatmaProvider = KhatmaProvider(repository: _khatmaRepository);

    // Initialize notification provider globally at app startup.
    _notificationProvider = NotificationProvider(prefs: prefs);
    if (initializeNotifications) {
      unawaited(_notificationProvider.initialize());
    }

    NotificationRouter.setNavigationCallback(_handleNotificationNavigation);
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
        Provider<KhatmaRepository>.value(value: _khatmaRepository),

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
        ChangeNotifierProvider<KhatmaProvider>.value(value: _khatmaProvider),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: _notificationProvider,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Quran App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: const Locale('ar', 'SA'), // Set default locale to Arabic
            routerConfig: appRouter,
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
