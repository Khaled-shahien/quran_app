import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../khatma/domain/models/khatma_model.dart';
import '../../../quran/domain/entities/surah_entity.dart';
import '../../../quran/domain/repositories/surah_repository.dart';
import 'package:provider/provider.dart';
import '../../../khatma/presentation/providers/khatma_provider.dart';

class _WirdPreviewData {
  final String ayahText;
  final String reference;

  const _WirdPreviewData({required this.ayahText, required this.reference});
}

class CurrentWirdWidget extends StatelessWidget {
  const CurrentWirdWidget({super.key});

  static const String _completedWirdMessage =
      'تم إتمام ورد اليوم، '
      'انتقل إلى الورد التالي';
  static const String _completedKhatmaMessage =
      'تم إتمام الختمة بنجاح، بارك الله فيك';

  static const List<int> _surahStartPages = [
    1,
    2,
    50,
    77,
    106,
    128,
    151,
    177,
    187,
    208,
    221,
    235,
    249,
    255,
    262,
    267,
    282,
    293,
    305,
    312,
    322,
    332,
    342,
    350,
    359,
    367,
    377,
    385,
    396,
    404,
    411,
    415,
    418,
    428,
    434,
    440,
    446,
    453,
    458,
    467,
    477,
    483,
    489,
    496,
    499,
    502,
    507,
    511,
    515,
    518,
    520,
    523,
    526,
    528,
    531,
    534,
    537,
    542,
    545,
    549,
    551,
    553,
    554,
    556,
    558,
    560,
    562,
    564,
    566,
    568,
    570,
    572,
    574,
    575,
    577,
    578,
    580,
    582,
    583,
    585,
    586,
    587,
    587,
    589,
    590,
    591,
    591,
    592,
    593,
    594,
    595,
    595,
    596,
    596,
    597,
    597,
    598,
    598,
    599,
    599,
    600,
    600,
    601,
    601,
    601,
    602,
    602,
    602,
    603,
    603,
    603,
    604,
    604,
    604,
  ];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Colors from the design
    final Color cardBgColor = isDarkMode
        ? AppColors.darkCardContent
        : Colors.white;
    final Color accentYellow = isDarkMode
        ? AppColors.darkSecondary
        : const Color(0xFFF9D030); // Yellow button
    final Color finishedBtnText = isDarkMode ? Colors.white : Colors.black87;
    final Color textDark = isDarkMode ? Colors.white : const Color(0xFF4A4A4A);
    final Color dividerColor = isDarkMode
        ? AppColors.darkGray
        : const Color(0xFFE5E5E5);
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    return Consumer<KhatmaProvider>(
      builder: (context, khatmaProvider, child) {
        final activeKhatma = khatmaProvider.activeKhatma;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section Title
              Text(
                'الورد الحالي',
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 12),

              if (activeKhatma != null) ...[
                // Main Card
                Container(
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Top Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'من قوله تعالى',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                            Text(
                              'الجزء ${activeKhatma.currentJuz}',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Dynamic first ayah preview for current wird range.
                        _AnimatedWirdAyahPreview(
                          cacheKey:
                              '${activeKhatma.id}_'
                              '${activeKhatma.todayFromUnit}_'
                              '${activeKhatma.todayToUnit}',
                          textColor: textDark,
                          loader: () => _loadCurrentWirdPreview(
                            context: context,
                            khatma: activeKhatma,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Details Row 1 (Start)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'بدء الختمة: ${activeKhatma.startMode}',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              '${activeKhatma.amountValue} / يوم',
                              style: GoogleFonts.cairo(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ورد اليوم: '
                          'من ${activeKhatma.todayFromUnit} '
                          'إلى ${activeKhatma.todayToUnit} '
                          '(${activeKhatma.amountType})',
                          style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textDark.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 24),

                        // Action Buttons
                        Row(
                          children: [
                            // Finished Button (Yellow)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await khatmaProvider
                                      .markCurrentWirdAsFinished();
                                  if (!context.mounted) return;

                                  final nextKhatma =
                                      khatmaProvider.activeKhatma;
                                  final bool stillActive =
                                      nextKhatma != null &&
                                      !nextKhatma.isCompleted;
                                  final String message = stillActive
                                      ? _completedWirdMessage
                                      : _completedKhatmaMessage;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        message,
                                        style: GoogleFonts.cairo(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                      duration: const Duration(seconds: 3),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentYellow,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chevron_left,
                                      color: finishedBtnText,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'أتممت القراءة',
                                      style: GoogleFonts.cairo(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: finishedBtnText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Read Button (Green)
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _openWirdAtStart(
                                    context: context,
                                    khatma: activeKhatma,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'اقرأ الورد',
                                  style: GoogleFonts.cairo(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Divider(color: dividerColor, thickness: 1),
                const SizedBox(height: 16),

                // Khatma Details (Progress Section)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الختمة الحالية',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'إلغاء الختمة',
                              style: GoogleFonts.cairo(),
                            ),
                            content: Text(
                              'هل أنت متأكد من '
                              'إلغاء الختمة الحالية؟',
                              style: GoogleFonts.cairo(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  'تراجع',
                                  style: GoogleFonts.cairo(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  khatmaProvider.cancelKhatma();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'نعم، إلغاء',
                                  style: GoogleFonts.cairo(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: activeKhatma.progress,
                    minHeight: 12,
                    backgroundColor: dividerColor,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'المتبقي: ${activeKhatma.remainingUnits.ceil()} '
                      '${activeKhatma.amountType}',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    Text(
                      'الإنجاز: '
                      '${(activeKhatma.progress * 100).toStringAsFixed(1)}%',
                      style: GoogleFonts.cairo(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
                if (activeKhatma.isBehindSchedule) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'هناك انقطاع في المتابعة. '
                            'اضغط لاستئناف '
                            'الخطة تلقائياً.',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: textDark,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          onPressed: () {
                            khatmaProvider.resumeAfterGap();
                          },
                          child: Text(
                            'استئناف',
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ] else ...[
                // Empty State (No Active Khatma)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: dividerColor),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.menu_book,
                        size: 48,
                        color: primaryColor.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد ختمة نشطة حالياً',
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ابدأ ختمة جديدة '
                        'وتابع وردك اليومي بسهولة',
                        style: GoogleFonts.cairo(
                          fontSize: 14,
                          color: textDark.withValues(alpha: 0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/khatma/location');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ابدأ ختمة جديدة',
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _openWirdAtStart({
    required BuildContext context,
    required KhatmaModel khatma,
  }) async {
    final int targetPage = _resolveTargetPageFromCurrentWird(khatma);

    final SurahRepository surahRepository = Provider.of<SurahRepository>(
      context,
      listen: false,
    );
    final List<SurahEntity> surahs = await surahRepository.getAllSurahs();
    final int targetSurahNumber = _resolveSurahForPage(targetPage);
    final SurahEntity targetSurah = surahs.firstWhere(
      (surah) => surah.number == targetSurahNumber,
      orElse: () => surahs.first,
    );
    final int targetAyah = _estimateAyahForPage(
      targetPage: targetPage,
      surah: targetSurah,
    );

    if (!context.mounted) return;

    context.push(
      '/quran/surah/${targetSurah.number}',
      extra: <String, dynamic>{
        'surah': targetSurah,
        'initialAyahNumber': targetAyah,
      },
    );
  }

  int _resolveTargetPageFromCurrentWird(KhatmaModel khatma) {
    switch (khatma.trackingUnit) {
      case KhatmaTrackingUnit.page:
        return khatma.todayFromUnit.clamp(1, 604);
      case KhatmaTrackingUnit.hizb:
        return (((khatma.todayFromUnit - 1) * 604) / 60).round().clamp(0, 603) +
            1;
      case KhatmaTrackingUnit.juz:
        return (((khatma.todayFromUnit - 1) * 604) / 30).round().clamp(0, 603) +
            1;
    }
  }

  int _resolveSurahForPage(int page) {
    final int safePage = page.clamp(1, 604);
    for (int i = _surahStartPages.length - 1; i >= 0; i--) {
      if (safePage >= _surahStartPages[i]) {
        return i + 1;
      }
    }
    return 1;
  }

  int _estimateAyahForPage({
    required int targetPage,
    required SurahEntity surah,
  }) {
    final int surahIndex = surah.number - 1;
    final int startPage = _surahStartPages[surahIndex];
    final int endPage = surah.number < 114
        ? _surahStartPages[surahIndex + 1] - 1
        : 604;
    final int span = math.max(1, endPage - startPage + 1);
    final double ratio = ((targetPage - startPage) / span).clamp(0, 1);
    final int ayah = (ratio * surah.totalAyah).floor() + 1;
    return ayah.clamp(1, surah.totalAyah);
  }

  Future<_WirdPreviewData> _loadCurrentWirdPreview({
    required BuildContext context,
    required KhatmaModel khatma,
  }) async {
    final int targetPage = _resolveTargetPageFromCurrentWird(khatma);

    final SurahRepository surahRepository = Provider.of<SurahRepository>(
      context,
      listen: false,
    );
    final List<SurahEntity> surahs = await surahRepository.getAllSurahs();
    final int targetSurahNumber = _resolveSurahForPage(targetPage);
    final SurahEntity targetSurah = surahs.firstWhere(
      (surah) => surah.number == targetSurahNumber,
      orElse: () => surahs.first,
    );

    final int targetAyah = _estimateAyahForPage(
      targetPage: targetPage,
      surah: targetSurah,
    );

    final String content = await rootBundle.loadString(
      'assets/ayaat/${targetSurah.number}.txt',
    );
    final List<String> verses = LineSplitter.split(
      content,
    ).map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

    final int ayahIndex = targetAyah.clamp(1, verses.length) - 1;
    final String ayahText = verses.isEmpty
        ? 'تعذر تحميل آية الورد'
        : verses[ayahIndex];

    return _WirdPreviewData(
      ayahText: ayahText,
      reference: '${targetSurah.name} - الآية $targetAyah',
    );
  }
}

class _AnimatedWirdAyahPreview extends StatefulWidget {
  final String cacheKey;
  final Color textColor;
  final Future<_WirdPreviewData> Function() loader;

  const _AnimatedWirdAyahPreview({
    required this.cacheKey,
    required this.textColor,
    required this.loader,
  });

  @override
  State<_AnimatedWirdAyahPreview> createState() =>
      _AnimatedWirdAyahPreviewState();
}

class _AnimatedWirdAyahPreviewState extends State<_AnimatedWirdAyahPreview> {
  _WirdPreviewData? _current;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  void didUpdateWidget(covariant _AnimatedWirdAyahPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cacheKey != widget.cacheKey) {
      _refresh();
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final _WirdPreviewData data = await widget.loader();
      if (!mounted) return;
      setState(() {
        _current = data;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _WirdPreviewData display =
        _current ??
        const _WirdPreviewData(
          ayahText: 'جاري تحميل آية الورد...',
          reference: '',
        );

    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.06),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Column(
            key: ValueKey<String>('${display.reference}_${display.ayahText}'),
            children: [
              Text(
                display.ayahText,
                style: GoogleFonts.amiri(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (display.reference.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  display.reference,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: widget.textColor.withValues(alpha: 0.75),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
        if (_isLoading && _current != null) ...[
          const SizedBox(height: 6),
          SizedBox(
            width: 48,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: widget.textColor.withValues(alpha: 0.45),
            ),
          ),
        ],
      ],
    );
  }
}
