import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/surah_entity.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/quran_settings_dialog.dart';

class _SurahPageData {
  final List<String> verses;
  final int startVerseIndex;

  _SurahPageData(this.verses, this.startVerseIndex);
}

class SurahDetailsScreen extends StatefulWidget {
  final SurahEntity surah;
  final int surahNumber;
  final int? initialAyahNumber;

  const SurahDetailsScreen({
    super.key,
    required this.surah,
    required this.surahNumber,
    this.initialAyahNumber,
  });

  @override
  State<SurahDetailsScreen> createState() => _SurahDetailsScreenState();
}

class _SurahDetailsScreenState extends State<SurahDetailsScreen> {
  List<_SurahPageData> _surahPages = [];
  bool _isLoading = true;
  String? _error;

  late PageController _pageController;
  int _currentSurahPage = 0;

  double _fontSize = 28;
  double _lineHeight = 1.95;
  bool _showVerseMarkers = true;
  bool _immersiveMode = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadVerses().then((_) => _focusInitialTarget());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _focusInitialTarget() {
    if (_focusInitialAyahIfProvided()) {
      return;
    }
    _focusBookmarkedPage();
  }

  bool _focusInitialAyahIfProvided() {
    final int? targetAyah = widget.initialAyahNumber;
    if (targetAyah == null || _surahPages.isEmpty) {
      return false;
    }

    int targetPage = 0;
    for (int i = 0; i < _surahPages.length; i++) {
      final _SurahPageData page = _surahPages[i];
      final int start = page.startVerseIndex + 1;
      final int end = start + page.verses.length - 1;
      if (targetAyah >= start && targetAyah <= end) {
        targetPage = i;
        break;
      }
    }

    if (!mounted) return true;
    setState(() {
      _currentSurahPage = targetPage;
    });
    _pageController.jumpToPage(targetPage);
    return true;
  }

  void _focusBookmarkedPage() {
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      context,
      listen: false,
    );

    if (!mounted) return;

    if (bookmarkProvider.surahNumber == widget.surahNumber &&
        bookmarkProvider.pageIndex != null &&
        _surahPages.isNotEmpty) {
      final int targetPage = bookmarkProvider.pageIndex!;
      if (targetPage < _surahPages.length) {
        setState(() {
          _currentSurahPage = targetPage;
        });
        _pageController.jumpToPage(targetPage);
      }
    }
  }

  Future<void> _loadVerses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final String filePath = 'assets/ayaat/${widget.surahNumber}.txt';
      final String content = await rootBundle.loadString(filePath);

      final List<String> verses = LineSplitter.split(
        content,
      ).map((line) => line.trim()).where((line) => line.isNotEmpty).toList();

      final List<_SurahPageData> paginatedVerses = [];
      List<String> currentPageVerses = [];
      int currentLength = 0;
      int startIndex = 0;
      const int maxCharsPerPage = 550;

      for (int i = 0; i < verses.length; i++) {
        currentPageVerses.add(verses[i]);
        currentLength += verses[i].length;

        if (currentLength >= maxCharsPerPage || i == verses.length - 1) {
          paginatedVerses.add(
            _SurahPageData(List<String>.from(currentPageVerses), startIndex),
          );
          currentPageVerses = [];
          currentLength = 0;
          startIndex = i + 1;
        }
      }

      setState(() {
        _surahPages = paginatedVerses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ أثناء تحميل آيات السورة';
        _isLoading = false;
      });
      developer.log(
        'Error loading verses',
        name: 'quran_app.quran_screen',
        level: 1000,
        error: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color paperColor = theme.scaffoldBackgroundColor;
    final Color textColor = theme.colorScheme.primary;
    final Color pageSurface = theme.brightness == Brightness.dark
        ? const Color(0xFF1A1A1A)
        : const Color(0xFFFFFCF5);
    final Color pageBorder = theme.colorScheme.primary.withValues(alpha: 0.22);

    return Scaffold(
      backgroundColor: paperColor,
      appBar: _immersiveMode ? null : _buildAppBar(theme),
      body: SafeArea(
        top: !_immersiveMode,
        child: Column(
          children: [
            if (!_immersiveMode && widget.surahNumber != 9)
              Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  color: pageSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: pageBorder),
                ),
                width: double.infinity,
                child: Text(
                  'بِسْمِ اللَّهِ '
                  'الرَّحْمَٰنِ الرَّحِيمِ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            Expanded(
              child: _buildBodyContent(
                textColor: textColor,
                pageSurface: pageSurface,
                pageBorder: pageBorder,
              ),
            ),
            if (!_immersiveMode &&
                _surahPages.isNotEmpty &&
                _surahPages.length > 1)
              _buildBottomNavigation(theme, pageSurface, pageBorder),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    final Color primary = theme.colorScheme.primary;

    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: _buildAppBarIconButton(
        tooltip: 'رجوع',
        icon: Icons.arrow_back_ios,
        color: primary,
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 4,
      title: Container(
        constraints: const BoxConstraints(maxWidth: 240),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.surah.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.amiri(
                fontSize: 21,
                color: primary,
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${_revelationLabel(widget.surah.revelationType)} '
              '• ${widget.surah.totalAyah} آية',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 11,
                color: primary.withValues(alpha: 0.72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: [
        _buildAppBarIconButton(
          tooltip: 'خيارات القراءة',
          icon: Icons.tune,
          color: primary,
          onPressed: _showReadingControlsSheet,
        ),
        _buildAppBarIconButton(
          tooltip: 'الإعدادات',
          icon: Icons.settings,
          color: primary,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const QuranSettingsDialog(),
            );
          },
        ),
        _buildAppBarIconButton(
          tooltip: 'حفظ العلامة',
          icon: Icons.bookmark,
          color: primary,
          onPressed: _saveBookmark,
        ),
      ],
      centerTitle: true,
    );
  }

  Widget _buildAppBarIconButton({
    required String tooltip,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: IconButton(
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.1),
          side: BorderSide(color: color.withValues(alpha: 0.18)),
        ),
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }

  String _revelationLabel(String value) {
    final String normalized = value.toLowerCase();
    if (normalized.contains('mecca') || normalized.contains('meccan')) {
      return 'مكية';
    }
    if (normalized.contains('medina') || normalized.contains('medinan')) {
      return 'مدنية';
    }
    return value;
  }

  Widget _buildBottomNavigation(
    ThemeData theme,
    Color pageSurface,
    Color pageBorder,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      child: Container(
        decoration: BoxDecoration(
          color: pageSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: pageBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'الصفحة السابقة',
                  onPressed: _currentSurahPage > 0
                      ? () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        )
                      : null,
                  icon: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Expanded(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Slider(
                      value: _currentSurahPage.toDouble(),
                      min: 0,
                      max: (_surahPages.length - 1).toDouble(),
                      divisions: _surahPages.length > 1
                          ? _surahPages.length - 1
                          : 1,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.colorScheme.secondary,
                      onChanged: (value) {
                        _pageController.jumpToPage(value.toInt());
                      },
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'الصفحة التالية',
                  onPressed: _currentSurahPage < _surahPages.length - 1
                      ? () => _pageController.nextPage(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        )
                      : null,
                  icon: Icon(
                    Icons.chevron_left,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'انتقلت إلى الصفحة ${_currentSurahPage + 1}',
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: theme.colorScheme.primary.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContent({
    required Color textColor,
    required Color pageSurface,
    required Color pageBorder,
  }) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D6363)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Text(
          _error!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    if (_surahPages.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد آيات في هذه السورة',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Amiri',
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return PageView.builder(
          controller: _pageController,
          padEnds: false,
          reverse: false,
          itemCount: _surahPages.length,
          onPageChanged: (index) {
            setState(() {
              _currentSurahPage = index;
            });
          },
          itemBuilder: (context, pageIndex) {
            final pageData = _surahPages[pageIndex];

            return Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: pageSurface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: pageBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: SelectableText.rich(
                            TextSpan(
                              style: GoogleFonts.amiri(
                                fontSize: _fontSize,
                                color: textColor,
                                height: _lineHeight,
                                fontWeight: FontWeight.w500,
                              ),
                              children: _buildVersesWithNumbers(pageData),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<InlineSpan> _buildVersesWithNumbers(_SurahPageData pageData) {
    final List<InlineSpan> spans = [];

    for (int i = 0; i < pageData.verses.length; i++) {
      final String verseText = pageData.verses[i];
      final int verseNumber = pageData.startVerseIndex + i + 1;

      spans.add(TextSpan(text: '$verseText  '));

      if (_showVerseMarkers) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.08),
              ),
              child: Text(
                verseNumber.toString(),
                style: TextStyle(
                  fontSize: _fontSize * 0.45,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiri',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        );
      }

      if (i < pageData.verses.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return spans;
  }

  Future<void> _saveBookmark() async {
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      context,
      listen: false,
    );
    await bookmarkProvider.saveBookmark(
      surahNumber: widget.surahNumber,
      surahName: widget.surah.name,
      pageIndex: _currentSurahPage,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم حفظ علامة القراءة بنجاح',
          style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showReadingControlsSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'تخصيص القراءة',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'حجم الخط',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _fontSize,
                      min: 22,
                      max: 38,
                      divisions: 16,
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                        setLocalState(() {});
                      },
                    ),
                    Text(
                      'تباعد الأسطر',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                    ),
                    Slider(
                      value: _lineHeight,
                      min: 1.5,
                      max: 2.5,
                      divisions: 10,
                      onChanged: (value) {
                        setState(() {
                          _lineHeight = value;
                        });
                        setLocalState(() {});
                      },
                    ),
                    SwitchListTile(
                      value: _showVerseMarkers,
                      onChanged: (value) {
                        setState(() {
                          _showVerseMarkers = value;
                        });
                        setLocalState(() {});
                      },
                      title: Text(
                        'إظهار أرقام الآيات',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SwitchListTile(
                      value: _immersiveMode,
                      onChanged: (value) {
                        setState(() {
                          _immersiveMode = value;
                        });
                        setLocalState(() {});
                      },
                      title: Text(
                        'وضع القراءة الكاملة',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
