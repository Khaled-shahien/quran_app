# Quran App — Codex Master Prompt

## 🔴 FIRST STEP — MANDATORY
Before doing anything else, read the file `rules.md` in the project root:
```
cat rules.md
```
Follow every instruction in `rules.md` throughout this entire session. If any instruction conflicts with the steps below, `rules.md` takes priority.

---

## ROLE
You are a senior Flutter engineer assigned to audit, fix, and improve a production-grade Islamic mobile app called **Quran App**. The app includes: Prayer Times, Quran Khatma tracker, Duas, Hadiths, and related Islamic features.

Your mission is to fully understand the project, verify all features work correctly, improve UI/UX, performance, and security — then apply all necessary fixes.

---

## PHASE 1 — PROJECT UNDERSTANDING

### 1.1 Read project structure
```
find . -type f -name "*.dart" | head -80
find . -type f -name "*.yaml" -o -name "*.json" | grep -v ".dart_tool" | grep -v "build"
cat pubspec.yaml
```

### 1.2 Read architecture files
- Read `lib/main.dart`
- Read all files under `lib/core/` (DI, router, theme, constants)
- List all feature folders under `lib/features/`
- For each feature, read: `domain/`, `data/`, `presentation/` layers

### 1.3 Identify all features
List every feature found and confirm which ones exist:
- [ ] Prayer Times (مواقيت الصلاة)
- [ ] Quran Khatma tracker (ختم القرآن)
- [ ] Duas (أدعية)
- [ ] Hadiths (أحاديث)
- [ ] Quran reader (عرض القرآن)
- [ ] Qibla direction (القبلة)
- [ ] Notifications / Adhan alerts
- [ ] Any other features found in code

---

## PHASE 2 — FULL FEATURE AUDIT

For each feature:

### 2.1 Functional correctness
- Trace the full data flow: UI → BLoC/Cubit → UseCase → Repository → DataSource
- Verify API calls or local data loading work correctly
- Check error handling: network errors, empty states, loading states
- Check null safety — no `!` force-unwraps without guards
- Check `async/await` usage — no missing `await`, no `unawaited` futures

### 2.2 Prayer Times feature specifically
- Verify calculation method is correct (e.g., Egyptian General Authority of Survey or MWL)
- Verify timezone handling and DST
- Verify location permission flow (request → granted → denied → fallback)
- Verify that times update correctly at midnight

### 2.3 Quran Khatma tracker
- Verify progress is persisted correctly (SharedPreferences / Hive / SQLite)
- Verify progress calculation is accurate
- Verify reset/complete flow works

### 2.4 Notifications / Adhan
- Verify notification scheduling logic (especially for next-day prayers)
- Verify notification fires correctly when app is in background
- Verify user can enable/disable per prayer

---

## PHASE 3 — UI/UX AUDIT

### 3.1 Run visual check
For every screen, verify:
- No overflow errors (`RenderFlex overflowed`)
- Text is readable on both light and dark themes
- Arabic text uses correct RTL alignment and appropriate font (e.g., Amiri, Scheherazade)
- No hardcoded colors — all colors come from `Theme.of(context)`
- No hardcoded font sizes — use `Theme.of(context).textTheme`
- Images/icons load correctly and have fallback on error

### 3.2 Navigation
- Verify all routes work with no dead ends
- Verify back navigation is correct
- Verify deep links or notification taps navigate to correct screen

### 3.3 Accessibility
- Verify `Semantics` labels on icon buttons
- Verify minimum tap target size (48×48dp)
- Verify text scales with system font size (`textScaleFactor`)

### 3.4 Localization
- If the app supports Arabic + English, verify all strings are in `.arb` files
- No hardcoded Arabic or English strings in widget code
- Verify RTL layout switches correctly

---

## PHASE 4 — PERFORMANCE AUDIT

### 4.1 Build optimization
- Check for `const` constructors — add `const` wherever possible
- Check for unnecessary `setState` calls in StatefulWidgets
- Verify `ListView` uses `ListView.builder` not `ListView` with children for long lists
- Verify images use `cached_network_image` or are properly cached
- Verify no heavy work runs on the UI thread (move to `compute()` or isolates if needed)

### 4.2 State management
- Verify BLoC/Cubit closes streams in `close()` override
- Verify no duplicate API calls triggered by unnecessary rebuilds
- Verify `BlocBuilder` uses `buildWhen` to minimize rebuilds where appropriate

### 4.3 App startup
- Check `main()` — avoid heavy sync work before `runApp()`
- Verify dependency injection initializes asynchronously if needed

---

## PHASE 5 — SECURITY AUDIT

### 5.1 Sensitive data
- Search for hardcoded API keys or secrets:
  ```
  grep -r "apiKey\|api_key\|secret\|password\|token" lib/ --include="*.dart"
  ```
- If found: move to `.env` file using `flutter_dotenv` and add `.env` to `.gitignore`

### 5.2 Network security
- Verify `android/app/src/main/AndroidManifest.xml` does NOT have `android:usesCleartextTraffic="true"` unless strictly required
- Verify HTTPS is used for all API endpoints
- If using Dio, verify a certificate pinning interceptor exists or note it as a gap

### 5.3 Local storage
- If storing sensitive user data (e.g., prayer settings, user identity), verify it uses `flutter_secure_storage` not plain SharedPreferences
- Verify no PII is logged to console in release builds

### 5.4 Permissions
- Verify only required permissions are declared in `AndroidManifest.xml` and `Info.plist`
- Verify runtime permission requests have proper rationale strings

---

## PHASE 6 — CODE QUALITY

### 6.1 Run static analysis
```
flutter analyze
```
Fix all errors. For warnings, fix unless there's a documented reason to suppress.

### 6.2 Dead code
- Remove unused imports
- Remove unused variables and functions
- Remove commented-out code blocks older than TODO markers

### 6.3 Magic values
- Replace hardcoded numbers and strings with named constants in `lib/core/constants/`

### 6.4 Error handling
- Every `try/catch` must either recover gracefully or emit an error state — no silent catches:
  ```dart
  // BAD
  catch (e) {}
  
  // GOOD
  catch (e, st) {
    emit(ErrorState(message: e.toString()));
    debugPrint('$e\n$st');
  }
  ```

---

## PHASE 7 — TESTING

### 7.1 Run existing tests
```
flutter test
```
Fix any failing tests before adding new ones.

### 7.2 Add missing tests (priority order)
1. Prayer time calculation logic (unit test)
2. Khatma progress calculation (unit test)
3. BLoC/Cubit state transitions for each feature (unit test)
4. Widget tests for main screens (smoke tests — verify no crash on render)

Target: minimum 60% coverage.
```
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## PHASE 8 — APPLY FIXES

After the audit, apply all fixes in this order:

1. **Critical bugs** — anything that crashes or produces wrong output
2. **Security issues** — hardcoded secrets, cleartext traffic
3. **Performance** — `const`, `ListView.builder`, stream leaks
4. **UI/UX** — overflow, RTL, theme consistency
5. **Code quality** — dead code, magic values, error handling
6. **Tests** — fix failing, add missing

For every change, write a one-line comment in the code explaining *why* the change was made if it's non-obvious.

---

## PHASE 9 — FINAL REPORT

After all fixes, produce a markdown report saved to `AUDIT_REPORT.md` with these sections:

```markdown
# Quran App — Audit Report

## Summary
- Features found: X
- Features verified working: X
- Bugs fixed: X
- Security issues fixed: X
- Performance improvements: X
- Tests added: X

## Features Status
| Feature | Status | Notes |
|---------|--------|-------|
| Prayer Times | ✅ Working | ... |
| Khatma Tracker | ⚠️ Fixed | ... |
| ... | | |

## Bugs Fixed
1. [Bug description] — [File:Line] — [Fix applied]

## Security Issues Fixed
1. ...

## Performance Improvements
1. ...

## Remaining Gaps (with recommended fix)
1. ...

## Test Coverage
- Before: X%
- After: X%
```

---

## CONSTRAINTS
- Do NOT change any Islamic content (Quran text, Hadith text, Duas text) — treat as read-only sacred data
- Do NOT change prayer calculation method without explicit user confirmation
- Do NOT remove any existing feature — only fix and improve
- Maintain existing architecture pattern (Clean Architecture / BLoC) — do not refactor to a different pattern
- All UI strings must remain in their current language unless fixing a localization bug
- Run `flutter analyze` and `flutter test` after every significant change to confirm nothing is broken
