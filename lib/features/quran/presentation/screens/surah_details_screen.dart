import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/surah_entity.dart';
import '../providers/bookmark_provider.dart';
import '../widgets/quran_settings_dialog.dart';

class _SurahPageData {
  final List<String> verses;
  final int startVerseIndex;

  _SurahPageData(this.verses, this.startVerseIndex);
}

/// Surah Details Screen
///
/// Displays all verses of a selected Surah in traditional Mushaf style vertically,
/// or horizontally paginated depending on implementation.
class SurahDetailsScreen extends StatefulWidget {
  final SurahEntity surah;
  final int surahNumber;

  const SurahDetailsScreen({
    super.key,
    required this.surah,
    required this.surahNumber,
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadVerses().then((_) => _focusBookmarkedPage());
  }

  void _focusBookmarkedPage() {
    final bookmarkProvider = Provider.of<BookmarkProvider>(
      context,
      listen: false,
    );
    if (!mounted) return;

    // Auto jump if this is the bookmarked surah
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadVerses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load verses from assets/ayaat/{surahNumber}.txt
      final fileName = '${widget.surahNumber}.txt';
      final filePath = path.join('assets', 'ayaat', fileName);

      String content = await rootBundle.loadString(filePath);

      // Split the content into verses based on new lines
      List<String> lines = LineSplitter.split(content).toList();

      // Filter out empty lines and trim whitespace
      final verses = lines
          .where((line) => line.trim().isNotEmpty)
          .map((line) => line.trim())
          .toList();

      List<_SurahPageData> paginatedVerses = [];
      List<String> currentPageVerses = [];
      int currentLength = 0;
      int startIndex = 0;
      const int maxCharsPerPage = 550; // Max characters per page

      for (int i = 0; i < verses.length; i++) {
        currentPageVerses.add(verses[i]);
        currentLength += verses[i].length;

        if (currentLength >= maxCharsPerPage || i == verses.length - 1) {
          paginatedVerses.add(
            _SurahPageData(List.from(currentPageVerses), startIndex),
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
      debugPrint('Error loading verses: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color paperColor = Theme.of(context).scaffoldBackgroundColor;
    const Color topBarColor = Colors.transparent;
    final Color textColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0,
        leading: IconButton(
          tooltip: 'رجوع',
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              widget.surah.name, // widget.surah.name already contains "سورة"
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.primary,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_surahPages.isNotEmpty)
              Text(
                "صفحة ${_currentSurahPage + 1} من ${_surahPages.length}",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.7),
                  fontFamily: 'Amiri',
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const QuranSettingsDialog(),
              );
            },
          ),
          IconButton(
            tooltip: 'حفظ العلامة',
            icon: Icon(
              Icons.bookmark,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () async {
              final bookmarkProvider = Provider.of<BookmarkProvider>(
                context,
                listen: false,
              );
              await bookmarkProvider.saveBookmark(
                surahNumber: widget.surahNumber,
                surahName: widget.surah.name,
                pageIndex: _currentSurahPage,
              );

              if (!context.mounted) return;

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
            },
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط معلومات صغير (اختياري)
          if (widget.surahNumber != 9) // لا تبدأ سورة التوبة بالبسملة
            Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              color: Theme.of(context).colorScheme.secondary,
              width: double.infinity,
              child: Text(
                "بِسْمِ اللَّهِ الرَّحْمَِٰ الرَّحِيمِ",
                textAlign: TextAlign.center,
                style: GoogleFonts.amiri(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),

          // محتوى الآيات مع التمرير الأفقي
          Expanded(child: _buildBodyContent(textColor)),

          // الشريط السفلي (Slider)
          if (_surahPages.isNotEmpty && _surahPages.length > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Directionality(
                textDirection: TextDirection.rtl, // Match reading direction
                child: Slider(
                  value: _currentSurahPage.toDouble(),
                  min: 0,
                  max: (_surahPages.length - 1).toDouble(),
                  divisions: _surahPages.length > 1
                      ? _surahPages.length - 1
                      : 1,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    _pageController.jumpToPage(value.toInt());
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBodyContent(Color textColor) {
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
          "لا توجد آيات في هذه السورة",
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
          reverse: false, // Right to left swipe (changed)
          itemCount: _surahPages.length,
          onPageChanged: (index) {
            setState(() {
              _currentSurahPage = index;
            });
          },
          itemBuilder: (context, pageIndex) {
            final pageData = _surahPages[pageIndex];

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: constraints.maxWidth - 40, // Subtract padding
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: GoogleFonts.amiri(
                            fontSize: 24,
                            color: textColor,
                            height: 1.8,
                            fontWeight: FontWeight.w500,
                          ),
                          children: _buildVersesWithNumbers(pageData),
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

  // دالة لبناء نص الآيات مع أرقامها داخل دوائر
  List<InlineSpan> _buildVersesWithNumbers(_SurahPageData pageData) {
    List<InlineSpan> spans = [];

    for (int i = 0; i < pageData.verses.length; i++) {
      final verseText = pageData.verses[i];
      final verseNumber = pageData.startVerseIndex + i + 1;

      // إضافة نص الآية
      spans.add(TextSpan(text: "$verseText  "));

      // إضافة رقم الآية داخل دائرة
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              verseNumber.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
                color: Colors.white,
              ),
            ),
          ),
        ),
      );

      // إضافة مسافة بين الآيات
      if (i < pageData.verses.length - 1) {
        spans.add(const TextSpan(text: " "));
      }
    }

    return spans;
  }
}
