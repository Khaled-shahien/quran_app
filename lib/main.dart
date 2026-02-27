import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/prayers/presentation/providers/prayer_times_provider.dart';
import 'features/prayers/data/data_sources/prayer_times_api_service.dart';
import 'features/prayers/data/repositories/prayer_times_repository_impl.dart';
import 'features/prayers/domain/repositories/prayer_times_repository.dart';

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
  late final PrayerTimesProvider _prayerTimesProvider;

  MyApp({super.key, required this.prefs}) {
    // Initialize repositories once during construction (lazy initialization)
    _prayerTimesRepository = PrayerTimesRepositoryImpl(
      apiService: PrayerTimesApiService(),
      sharedPreferences: prefs,
    );

    _prayerTimesProvider = PrayerTimesProvider(
      repository: _prayerTimesRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide SharedPreferences as a value (no recreation needed)
        Provider<SharedPreferences>.value(value: prefs),

        // Provide repository as a value (pre-initialized)
        Provider<PrayerTimesRepository>.value(value: _prayerTimesRepository),

        // Provide provider as a value (pre-initialized)
        ChangeNotifierProvider<PrayerTimesProvider>.value(
          value: _prayerTimesProvider,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quran App',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        locale: const Locale('ar', 'SA'), // Set default locale to Arabic
        home: const OnboardingScreen(),
        builder: (context, child) {
          return Directionality(
            textDirection: TextDirection.rtl, // Right-to-left for Arabic
            child: child!,
          );
        },
      ),
    );
  }
}
