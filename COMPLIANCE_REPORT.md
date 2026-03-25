# COMPLIANCE REPORT

Prepared on: 25 March 2026  
Scope: Full review against rules.md  
Method: Evidence-based audit only (no assumptions)

---

## 1. Executive Summary

المشروع في حالة جيدة من ناحية الاستقرار والجودة الأساسية، مع وجود تطبيق واضح لعدة قواعد مهمة مثل:
- نظافة التحليل الثابت (flutter analyze: بدون مشاكل)
- وجود اختبارات (flutter test: جميع الاختبارات ناجحة)
- تطبيق معماري قائم على features/layers
- استخدام go_router
- وجود Theme مركزي مع Light/Dark + ThemeExtension
- وجود تطبيق فعلي لـ Semantics وتحسينات contrast/text scaling

لكن ما زالت هناك فجوات امتثال مهمة:
- قاعدة طول السطر <= 80 غير مكتملة (39 سطرًا مخالفًا داخل lib غير المولّد)
- توثيق Public APIs غير مكتمل بشكل شامل
- استخدام ! (non-null assertion) لا يزال مرتفعًا نسبيًا
- بعض قواعد rules.md هي قواعد إجرائية للمساعد/الأدوات وليست قابلة للتحقق الكامل من الكود فقط
- وجود تعارضات داخل rules.md نفسها (خصوصًا في logging وstate management)

**Overall Assessment: Medium Compliance**

---

## 2. Rules Compliance Table

| Rule | Status | What is Implemented | What is Missing | Technical Notes |
|---|---|---|---|---|
| Project structure (lib/main.dart entry) | ✅ Completed | main.dart موجود كنقطة دخول | - | متوافق مع الهيكل القياسي |
| Standard Flutter structure | ✅ Completed | بنية Flutter القياسية موجودة (android/ios/web/windows/macOS/linux/lib/test) | - | متوافق |
| Feature/layer architecture | ✅ Completed | تنظيم واضح في features + core + data/domain/presentation | - | متوافق معماريًا |
| Separation of concerns (UI vs business/data) | ⚠️ Partial | توجد repositories/providers منفصلة عن الـ UI | يوجد منطق UI داخل شاشات كبيرة في بعض المواضع | يحتاج مزيد تفكيك للشاشات الكبيرة |
| SOLID principles | ⚠️ Partial | هناك abstractions جيدة (repositories/services) | لا يوجد قياس شامل لكل مبدأ في جميع الملفات | يتطلب مراجعة معمقة per-class |
| Composition over inheritance | ✅ Completed | الاعتماد الأكبر على التركيب (Widgets/Providers/Services) | - | استخدام الوراثة محدود ومقبول |
| Immutability (widgets) | ⚠️ Partial | عدد كبير من StatelessWidget وحقول final | توجد Stateful classes مطولة وبعض state mutable بطبيعتها | مقبول جزئيًا بحسب الحاجة |
| Navigation using go_router | ✅ Completed | go_router مستخدم في app_router.dart وعلى مستوى الشاشات | - | متوافق مع قاعدة routing |
| Built-in state preference | ⚠️ Partial | يوجد ValueNotifier في ThemeProvider وFavoritesProvider | الاعتماد الأساسي على provider/ChangeNotifier (third-party) | يوجد تعارض داخلي في rules بين منع third-party والسماح بـ provider |
| ValueNotifier for simple state | ⚠️ Partial | تم تطبيقه في حالات بسيطة (Theme/Favorites) | باقي الحالات البسيطة لم تُراجع جميعًا | امتثال جزئي جيد |
| ChangeNotifier for complex/shared state | ✅ Completed | مستخدم على نطاق واسع لحالات مشتركة | - | متوافق |
| Dependency injection clarity | ⚠️ Partial | constructor DI موجود بعدة طبقات | DI مركزي في main.dart كبير نسبيًا | قابل للتحسين لكن مقبول |
| Naming conventions (classes/members/files) | ⚠️ Partial | أغلب التسميات جيدة (Pascal/camel/snake) | مسار غير متوافق: lib/features/prayers/domain/Entities/prayer_times_entity.dart | يوجد خرق naming واضح واحد على الأقل |
| Line length <= 80 | ⚠️ Partial | جزء كبير ملتزم | 39 سطرًا مخالفًا في lib (non-generated) | أعلى مخالفات: asma_al_husna_screen.dart |
| Keep functions short (<20 lines) | ⚠️ Partial | بعض الدوال قصيرة وواضحة | دوال/شاشات كبيرة نسبيًا في عدة ملفات | يحتاج refactor تدريجي |
| Simplicity / conciseness | ⚠️ Partial | الكود عمومًا مفهوم | توجد مناطق معقدة وطويلة | يحتاج تبسيط موضعي |
| Error handling (no silent failures) | ✅ Completed | وجود try/catch ومعالجة أخطاء في طبقات متعددة | - | جيد وظيفيًا |
| Lint baseline (flutter_lints) | ✅ Completed | include: package:flutter_lints/flutter.yaml موجود | - | متوافق |
| Use logging package instead of print | ⚠️ Partial | لا يوجد print/debugPrint داخل lib | الاستخدام الأساسي هو dart:developer + logger وليس package:logging | قاعدة logging في rules متضاربة مع قسم Logging اللاحق |
| Structured logging with developer.log | ✅ Completed | استخدام واسع لـ developer.log مع names/levels | - | متوافق مع قسم Logging في rules |
| Restrict raw Logger usage | ⚠️ Partial | logger يتركز غالبًا في core/api/security | توجد إنشاءات Logger مباشرة في عدة ملفات core | مقبول جزئيًا وفق سياسة LOGGING_POLICY.md |
| JSON serialization via json_serializable | ✅ Completed | @JsonSerializable مستخدم في عدة models | - | متوافق |
| fieldRename: FieldRename.snake where required | ⚠️ Partial | مطبق في khatma_model | ليس مطبقًا على كل النماذج التي قد تتطلب عقود snake_case | يحتاج تدقيق نموذج-بنموذج |
| build_runner dev dependency | ✅ Completed | build_runner موجود في dev_dependencies | - | متوافق |
| Code generation workflow | ✅ Completed | ملفات g.dart موجودة وتستخدم | لا يوجد دليل آلي CI على regeneration | متوافق وظيفيًا |
| Unit/Widget/Integration test presence | ✅ Completed | test/ و integration_test/ موجودان بملفات متعددة | - | متوافق |
| Test execution health | ✅ Completed | flutter test نجح بالكامل | - | مؤشر جودة قوي |
| package:checks assertions preference | ❌ Not Implemented | - | لا يوجد استخدام package:checks في الاختبارات | الاختبارات تعتمد matchers/expect التقليدية |
| Prefer fakes/stubs over mocks | ⚠️ Partial | أغلب الاختبارات لا تعتمد mocks بكثافة | يوجد mockito مستخدم في بعض الاختبارات | يحتاج توحيد استراتيجية الاختبارات |
| Public API documentation (dartdoc) | ⚠️ Partial | يوجد قدر جيد من /// comments | تغطية غير كاملة (تقديريًا 60 من 136 إعلانًا عامًا موثقًا مباشرة) | يحتاج توثيق منهجي لجميع APIs العامة |
| Trailing comments not allowed | ❌ Not Implemented | - | وجود تعليقات طرفية كثيرة من نوع ; // | مخالف مباشر لقاعدة تعليق السطر الطرفي |
| Null safety: avoid ! unless guaranteed | ⚠️ Partial | الكود null-safe عمومًا | استخدام ! لا يزال مرتفعًا (nonNullBangApprox=172) | يحتاج تقليل تدريجي للحالات عالية الخطورة |
| Async/await robustness | ✅ Completed | استخدام واضح لـ Future/async/catch في طبقات متعددة | - | جيد |
| Streams for async sequences | ⚠️ Partial | توجد استخدامات Stream في سياقات Firebase/notifications | ليست قاعدة مطبقة بوضوح كنمط موحد | لا يوجد نقص حرج |
| Private widget classes over helper methods | ⚠️ Partial | توجد Widgets خاصة في أجزاء متعددة | ما زال هناك helper methods تعيد Widgets في شاشات كبيرة | فرصة تحسين maintainability |
| Avoid expensive work in build() | ⚠️ Partial | لا يوجد network calls مباشرة في build غالبًا | بعض شاشات كبيرة قد تحتاج فصل إضافي | مقبول مع مراقبة |
| Long list performance (builder/slivers) | ✅ Completed | استخدام ListView.builder وSliverGrid/SliverList | - | متوافق |
| Use compute() for expensive parsing | ❌ Not Implemented | - | لا يوجد استخدام compute() ظاهر | قد يؤثر على الأداء عند parsing كبير |
| Theming centralization | ✅ Completed | AppTheme مركزي مستخدم في MaterialApp | - | متوافق ممتاز |
| Light/Dark themes support | ✅ Completed | theme + darkTheme + themeMode مطبقة | - | متوافق |
| ColorScheme.fromSeed usage | ✅ Completed | مستخدم في AppTheme.lightTheme/darkTheme | - | متوافق |
| Component themes (AppBar/Button/Card...) | ✅ Completed | themes مخصصة متعددة موجودة | - | متوافق |
| ThemeExtension tokens | ✅ Completed | _AppThemeExtensions موجود مع copyWith/lerp | - | متوافق |
| WidgetStateProperty styling | ✅ Completed | مستخدم في NavigationBarTheme/Scrollbar | - | متوافق |
| Assets declared in pubspec | ✅ Completed | assets/images, ayaat, hadeath, jsons معلنة | - | متوافق |
| Network image safety (loading/error builders) | ⚠️ Partial | لا يوجد استخدام كثيف للصور الشبكية | لا يوجد نمط موحد مثبت حيث يُستخدم Image.network | يحتاج توحيد عند التوسعة |
| Layout overflow safety (Expanded/Flexible/Wrap/FittedBox) | ⚠️ Partial | تم تحسين أجزاء مهمة ضمن QAP-403 | لا يزال يلزم تدقيق شامل لكل الشاشات | امتثال جزئي جيد |
| WCAG contrast ratios | ⚠️ Partial | تم تحسين أزواج ألوان أساسية ضمن QAP-402 | لا يوجد تدقيق آلي شامل لكل العناصر والحالات | يحتاج pipeline/Checklist تنفيذ دوري |
| Typography readability scale | ⚠️ Partial | TextTheme واضح وخيارات خطوط جيدة | لا يوجد تحقق منهجي لكل الشاشات والأحجام | يحتاج تدقيق UX/QA دوري |
| Accessibility semantics labels | ⚠️ Partial | تمت إضافة Semantics على شاشات حرجة | ليس هناك ضمان تغطية شاملة لكل عناصر التطبيق | يحتاج توسيع + regression checks |
| Dynamic text scaling validation | ⚠️ Partial | إصلاحات واضحة على شاشات core | لا يوجد اختبار آلي أو matrix تشغيل موثق داخل CI | يعتمد حاليًا على فحص يدوي |
| Screen reader testing (TalkBack/VoiceOver) | ❌ Not Implemented | - | لا يوجد دليل تشغيلي موثق داخل المشروع على تنفيذ دوري | يلزم توثيق نتائج QA لكل release |

---

## 3. Missing / Weak Areas

1. **Line-length compliance**
- ما زال هناك 39 سطرًا أطول من 80 حرفًا (داخل lib غير المولّد).
- أكثر ملف متأثر: `lib/features/quran/presentation/screens/asma_al_husna_screen.dart`.

2. **Public API documentation coverage**
- التوثيق موجود لكن غير شامل لكل APIs العامة.
- التقدير الآلي: 60 من 136 إعلانًا عامًا موثقًا مباشرة بتعليق dartdoc قبل الإعلان.

3. **Null-safety strictness**
- استخدام `!` لا يزال مرتفعًا (تقدير: 172 حالة).
- يحتاج خفضًا تدريجيًا للحالات عالية المخاطر.

4. **Trailing comments policy violation**
- وجود تعليقات طرفية كثيرة (مثل `; // comment`) في عدة ملفات.

5. **Testing standards gaps**
- قاعدة `package:checks` غير مطبقة.
- استخدام `mockito` موجود (ولو محدود).

6. **A11Y workflow evidence gap**
- رغم تحسينات semantics/contrast/text scale، لا يوجد دليل تشغيل دوري موثق لـ TalkBack/VoiceOver داخل سير QA المعياري.

7. **Performance guidance gap**
- لا يوجد استخدام `compute()` في parsing/عمليات مرشحة للكلفة.

---

## 4. Technical Observations

1. **Rule conflicts inside rules.md**
- يوجد تعارض بين:
  - "Use the logging package instead of print"
  - وقسم Logging الذي يوجه لاستخدام `dart:developer log`.
- ويوجد تعارض مشابه في state management:
  - "Prefer built-in, avoid third-party"
  - ثم السماح بـ `provider` عند طلب DI أوسع.

2. **Duplicate exception concepts/classes**
- تعريفات متكررة/متوازية لـ `ApiException` و`NetworkException` في أكثر من ملف:
  - `lib/core/errors/app_exceptions.dart`
  - `lib/core/errors/api_exception.dart`
  - `lib/core/errors/network_exception.dart`
- هذا يرفع احتمالات الالتباس والتكرار في معالجة الأخطاء.

3. **Naming consistency issue in path casing**
- مجلد `Entities` داخل prayers domain يخالف snake_case path convention.

4. **Large central composition in main.dart**
- main.dart مسؤول عن تركيب عدد كبير من dependencies/providers، ما يزيد التعقيد التشغيلي.

5. **Evidence boundary**
- بعض القواعد في rules.md سلوكية/إجرائية خاصة بالمساعد أو بعملية التطوير (tools usage style)، ولا يمكن إثبات امتثالها الكامل من الكود وحده.

---

## 5. Improvement Recommendations

### Priority 1 (High)
1. إغلاق كل مخالفات طول السطر (>80) في `lib/` غير المولّد.
2. توحيد طبقة الاستثناءات (مصدر واحد لـ Api/Network exceptions).
3. تقليل `!` في المسارات الحرجة (providers/services/navigation parsing).
4. فرض بوابة A11Y release gate باستخدام `A11Y_SMOKE_CHECKLIST.md` مع أدلة تشغيل فعلية.

### Priority 2 (Medium)
1. استكمال توثيق كل Public APIs بـ dartdoc منهجيًا.
2. إزالة/تقليل trailing comments واستبدالها بتعليقات سطرية أعلى الكود عند الحاجة.
3. توحيد سياسة logging عمليًا (developer.log default + logger only via approved wrappers) وإنعاش rules.md لتجنب التعارض.
4. إصلاح naming path (`Entities` -> `entities`) مع تحديث الاستيرادات.

### Priority 3 (Medium-Low)
1. تقييم نقاط parsing الثقيلة وإدخال `compute()` حيث يفيد الأداء.
2. تحسين تفكيك الشاشات/الدوال الطويلة إلى Widgets/units أصغر.
3. اعتماد `package:checks` تدريجيًا في الاختبارات الجديدة ثم القديمة.

### Priority 4 (Low)
1. إضافة قياسات امتثال آلية في CI (line-length, docs coverage, a11y smoke evidence checklist gating).
2. مواءمة صياغة rules.md: فصل القواعد "الإرشادية للمساعد" عن "القواعد الملزمة للكود" لتسهيل المراجعة.

---

## Evidence Snapshot (Executed During This Review)

- Static analysis: `flutter analyze` -> No issues found.
- Tests: `flutter test` -> All tests passed.
- Non-generated line-length scan in `lib/`: 39 long lines.
- `print/debugPrint` in `lib/`: no matches.
- JSON annotations: present across multiple models, with selective `FieldRename.snake`.
- A11Y Semantics usage: present in core screens.
- Integration tests: present under `integration_test/` (quran/prayers/duas/smoke).

---

## 6. Consolidated Notes from Previous Report

This section merges useful planning-oriented points from `report.md` into the
current evidence-based report.

### 6.1 Confirmed strengths worth retaining

- Strong feature-based structure with Presentation/Domain/Data/Core separation.
- Good routing quality with `go_router` and route-level guard/error handling.
- Mature theming baseline with Material 3 + light/dark mode support.
- Practical accessibility baseline exists (Semantics + contrast/text-scale work).

### 6.2 Items from previous report that require re-validation before claiming

- Any explicit percentage score (for example 92%) is not preserved here because
  it is not directly measured in this audit method.
- Any absolute claim like "fully implemented" is treated as conditional unless
  backed by direct code/search/test evidence.

### 6.3 Execution-oriented roadmap (merged)

1. Stabilize style compliance first:
  - close all >80 char violations in `lib/` non-generated files.
2. Reduce maintenance hotspots:
  - split very large screens/functions into smaller private widgets and units.
3. Strengthen quality gates:
  - add CI checks for line length, docs coverage targets, and A11Y smoke gate.
4. Improve API contract safety:
  - apply `FieldRename.snake` where external API contracts require it.
5. Expand test quality over time:
  - increase branch coverage and gradually adopt stronger assertion style.
