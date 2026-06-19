# Quran App - Audit Report

## Summary
- Features found: 9
- Features verified working: 8 by static audit and automated tests
- Bugs fixed: 11
- Security issues fixed: 1
- Performance improvements: 0 direct code changes; performance gaps documented
- Tests added: 0 new test files
- Tests updated: 3 targeted fixes/expectation updates

Note: this codebase uses Provider/ChangeNotifier, GetIt, and go_router rather
than BLoC/Cubit. The existing architecture was preserved.

## Features Status
| Feature | Status | Notes |
|---------|--------|-------|
| Prayer Times | Fixed / partially verified | Provider, repository, API model, screen, loading/error/empty states, and tests pass. Calculation method still needs product/fiqh confirmation because it must not be changed without approval. |
| Quran Reader | Working | Surah list and details render in tests. Quran text was not modified. |
| Quran Khatma Tracker | Fixed | Stored progress parsing now logs malformed data, and Khatma reminder taps have a route fallback. |
| Duas / Azkar | Working | Existing data and screen tests pass. Sacred text was not modified. |
| Hadiths | Working | Existing list/details/widget tests pass. Hadith text was not modified. |
| Qibla Direction | Gap | Present as an external QiblaFinder link, not a native compass/location implementation. |
| Notifications / Alarms / FCM | Fixed / partially verified | Diagnostic UI, token masking/logging, pending notifications, and route handling were improved. Real background delivery still needs device testing. |
| Tasbeeh | Working | Existing widget tests pass. |
| Settings / Onboarding / Home | Fixed | Smoke test updated and home Khatma navigation async safety improved. |

## Bugs Fixed
1. Broken app smoke test referenced a removed `MyApp` entry point - `test/widget_test.dart:14` - replaced with an `OnboardingScreen` smoke test that matches the current app structure.
2. Async `BuildContext` usage could trigger analyzer warnings in home actions - `lib/features/onboarding/presentation/screens/home_screen.dart:823` - switched post-await checks to `context.mounted`.
3. Khatma current-wird navigation used async context-sensitive work without enough guards - `lib/features/onboarding/presentation/widgets/current_wird_widget.dart:441` - captured dependencies before awaits and guarded empty Surah data.
4. Home Khatma unit navigation lacked empty Surah protection - `lib/features/onboarding/presentation/screens/home_screen.dart:555` - added safe handling before opening a reader page.
5. Corrupt saved Khatma data was swallowed silently - `lib/features/khatma/data/repositories/khatma_repository.dart:24` - added structured developer logging while preserving graceful recovery.
6. FCM token refresh logging exposed token values - `lib/core/services/firebase_messaging_service.dart:273` - stopped logging raw token contents.
7. NotificationProvider diagnostic logs exposed refreshed FCM token values - `lib/core/providers/notification_provider.dart:248` - replaced with a generic success log.
8. Khatma notification payloads had no complete route handling - `lib/core/navigation/notification_router.dart:37`, `lib/core/navigation/notification_handler.dart:29`, `lib/core/navigation/navigation_handler.dart:42` - added `/khatma` fallback handling.
9. Notification diagnostic screen was incomplete for testing and operations - `lib/features/settings/presentation/screens/notification_test_screen.dart:42` - rebuilt it with permission, local notification, FCM, pending schedule, alarm control, and debug sections.
10. Prayer times screen lacked stable loading/error/empty/test-facing states and Sunrise display - `lib/features/prayers/presentation/screens/prayer_times_screen.dart:79` - added fallback labels, retry UI, no-data state, and Sunrise mapping without changing calculation logic.
11. Visible Bismillah heading in Surah details was not selectable like the verse content - `lib/features/quran/presentation/screens/surah_details_screen.dart:301` - changed the visible header widget to `SelectableText` without changing the text.

## Security Issues Fixed
1. Raw FCM token logging was removed from service/provider logs - `lib/core/services/firebase_messaging_service.dart:273`, `lib/core/providers/notification_provider.dart:248`. The diagnostic UI masks the token at `lib/features/settings/presentation/screens/notification_test_screen.dart:276`; copying the token remains a deliberate diagnostic action.

## Performance Improvements
No direct performance-only edits were applied in this pass. The audit did not find a safe, narrow performance change that was more important than preserving behavior and passing the current test suite.

## Remaining Gaps (with recommended fix)
1. Prayer calculation method is inconsistent in defaults: the provider uses method `5` while the repository signature default is `3`. Recommended fix: confirm the intended method with the product/fiqh owner, then align defaults and tests.
2. Prayer location is fixed to Cairo coordinates in the current location service. Recommended fix: add a real location permission flow with denied/fallback states and tests.
3. Prayer times do not have a dedicated midnight refresh scheduler. Recommended fix: schedule a date-bound refresh or app-resume check that reloads after local midnight.
4. Per-prayer Adhan toggles/schedules are not fully implemented; current alarms cover app reminder categories. Recommended fix: model per-prayer notification preferences and schedule each upcoming prayer separately.
5. Qibla is an external-link feature rather than a native compass. Recommended fix: add a compass/location package only after confirming target platforms and permissions.
6. Firebase client config values remain in `lib/firebase_options.dart` and `android/app/google-services.json`. These are client config values, not server secrets, but they should be restricted in Firebase Console by app/package and API rules.
7. HTTPS endpoints are used and Android cleartext traffic is not enabled, but no certificate pinning was found. Recommended fix: add pinning/interceptor support if the threat model requires it.
8. Manual notification delivery, background taps, exact alarms, and visual overflow checks still need physical device/emulator validation.
9. Localization is not fully externalized into ARB files; many strings remain in widgets. Recommended fix: introduce Flutter localization incrementally after stabilizing current screens.
10. Test coverage is below the requested 60% target. Recommended fix: add focused unit tests for prayer scheduling/location, Khatma progress edge cases, and notification tap routing.

## Test Coverage
- Before: Not measured in this run.
- After: 47.86% line coverage (`2463/5146` lines from `coverage/lcov.info`).
- Target: 60%.
- Coverage command: `flutter test --coverage` passed with `+162` tests.
- HTML coverage: not generated because `genhtml` is not installed on this machine.

## Verification
- `flutter analyze` - no issues found.
- `flutter test` - all tests passed (`+162`).
- `flutter test --coverage` - all tests passed (`+162`) and wrote `coverage/lcov.info`.
