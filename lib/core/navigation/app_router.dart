import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/duas/presentation/screens/azkar_details_screen.dart';
import '../../features/duas/presentation/screens/azkar_screen.dart';
import '../../features/duas/presentation/screens/duas_screen.dart';
import '../../features/hadeath/domain/entities/hadeath_entity.dart';
import '../../features/hadeath/domain/repositories/hadeath_repository.dart';
import '../../features/hadeath/presentation/screens/'
    'hadeath_details_screen.dart';
import '../../features/hadeath/presentation/screens/hadeath_screen.dart';
import '../../features/khatma/presentation/screens/khatma_duration_screen.dart';
import '../../features/khatma/presentation/screens/khatma_location_screen.dart';
import '../../features/onboarding/presentation/screens/home_screen.dart';
import '../../features/onboarding/presentation/screens/media_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/prayers/presentation/screens/prayer_times_screen.dart';
import '../../features/quran/domain/entities/surah_entity.dart';
import '../../features/quran/domain/repositories/surah_repository.dart';
import '../../features/quran/presentation/screens/asma_al_husna_screen.dart';
import '../../features/quran/presentation/screens/quran_screen.dart';
import '../../features/quran/presentation/screens/surah_details_screen.dart';
import '../../features/quran/presentation/screens/tasbeeh_screen.dart';
import '../../features/settings/presentation/screens/'
    'notification_test_screen.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: appNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/quran', builder: (context, state) => const QuranScreen()),
    GoRoute(
      path: '/quran/surah/:number',
      builder: (context, state) {
        final int? surahNumber = int.tryParse(
          state.pathParameters['number'] ?? '',
        );
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final SurahEntity? surah = extra?['surah'] as SurahEntity?;
        final int? initialAyahNumber = extra?['initialAyahNumber'] as int?;
        final int? initialPageNumber = extra?['initialPageNumber'] as int?;

        if (surahNumber == null) {
          return const _RouteDataErrorScreen(
            message:
                'تعذر فتح السورة:\n'
                'رقم السورة غير صالح.',
          );
        }

        if (surah == null) {
          return _SurahDetailsRouteLoader(
            surahNumber: surahNumber,
            initialAyahNumber: initialAyahNumber,
            initialPageNumber: initialPageNumber,
          );
        }

        return SurahDetailsScreen(
          surah: surah,
          surahNumber: surahNumber,
          initialAyahNumber: initialAyahNumber,
          initialPageNumber: initialPageNumber,
        );
      },
    ),
    GoRoute(
      path: '/prayers',
      builder: (context, state) => const PrayerTimesScreen(),
    ),
    GoRoute(path: '/duas', builder: (context, state) => const AzkarScreen()),
    GoRoute(path: '/duas/all', builder: (context, state) => const DuasScreen()),
    GoRoute(
      path: '/azkar/details',
      builder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        return AzkarDetailsScreen(
          categoryName: extra?['categoryName'] as String? ?? '',
        );
      },
    ),
    GoRoute(
      path: '/duas/morning',
      builder: (context, state) =>
          const AzkarDetailsScreen(categoryName: 'أذكار الصباح'),
    ),
    GoRoute(
      path: '/duas/evening',
      builder: (context, state) =>
          const AzkarDetailsScreen(categoryName: 'أذكار المساء'),
    ),
    GoRoute(
      path: '/hadeath',
      builder: (context, state) => const HadeathScreen(),
    ),
    GoRoute(
      path: '/hadeath/details/:index',
      builder: (context, state) {
        final HadeathEntity? hadeath = state.extra as HadeathEntity?;
        final int? index = int.tryParse(state.pathParameters['index'] ?? '');

        if (index == null) {
          return const _RouteDataErrorScreen(
            message:
                'تعذر فتح الحديث:\n'
                'معرف الحديث غير صالح.',
          );
        }

        if (hadeath == null) {
          return _HadeathDetailsRouteLoader(index: index);
        }

        return HadeathDetailsScreen(hadeath: hadeath);
      },
    ),
    GoRoute(
      path: '/tasbeeh',
      builder: (context, state) => const TasbeehScreen(),
    ),
    GoRoute(
      path: '/asma',
      builder: (context, state) => const AsmaAlHusnaScreen(),
    ),
    GoRoute(path: '/media', builder: (context, state) => const MediaScreen()),
    GoRoute(
      path: '/settings/notification-test',
      builder: (context, state) => const NotificationTestScreen(),
    ),
    GoRoute(
      path: '/khatma/location',
      builder: (context, state) => const KhatmaLocationScreen(),
    ),
    GoRoute(
      path: '/khatma/duration',
      builder: (context, state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final String startMode =
            extra?['startMode'] as String? ?? 'بداية المصحف';
        final int? startJuz = extra?['startJuz'] as int?;

        return KhatmaDurationScreen(startMode: startMode, startJuz: startJuz);
      },
    ),
  ],
);

class _RouteDataErrorScreen extends StatelessWidget {
  final String message;

  const _RouteDataErrorScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تنبيه')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(message, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

class _SurahDetailsRouteLoader extends StatelessWidget {
  final int surahNumber;
  final int? initialAyahNumber;
  final int? initialPageNumber;

  const _SurahDetailsRouteLoader({
    required this.surahNumber,
    this.initialAyahNumber,
    this.initialPageNumber,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SurahEntity>(
      future: context.read<SurahRepository>().getSurahByIndex(surahNumber),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final SurahEntity? surah = snapshot.data;
        if (snapshot.hasError || surah == null) {
          return const _RouteDataErrorScreen(
            message:
                'تعذر فتح السورة\n'
                'من الرابط المباشر.',
          );
        }

        return SurahDetailsScreen(
          surah: surah,
          surahNumber: surahNumber,
          initialAyahNumber: initialAyahNumber,
          initialPageNumber: initialPageNumber,
        );
      },
    );
  }
}

class _HadeathDetailsRouteLoader extends StatelessWidget {
  final int index;

  const _HadeathDetailsRouteLoader({required this.index});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HadeathEntity>>(
      future: context.read<HadeathRepository>().getAllAhadeth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final List<HadeathEntity> all =
            snapshot.data ?? const <HadeathEntity>[];
        if (snapshot.hasError || index < 0 || index >= all.length) {
          return const _RouteDataErrorScreen(
            message:
                'تعذر فتح الحديث\n'
                'من الرابط المباشر.',
          );
        }

        return HadeathDetailsScreen(hadeath: all[index]);
      },
    );
  }
}
