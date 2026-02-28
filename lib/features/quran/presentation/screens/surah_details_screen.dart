import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

import '../../domain/entities/surah_entity.dart';

/// Surah Details Screen
///
/// Displays all verses of a selected Surah in traditional Mushaf style
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
  List<String> _verses = [];
  bool _isLoading = true;
  String? _error;
  double _currentPage = 135; // Default page number
  final double _minPage = 1;
  final double _maxPage = 604;

  @override
  void initState() {
    super.initState();
    _loadVerses();
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

      setState(() {
        _verses = verses;
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
    // الألوان المستوحاة من التصميم التقليدي للمصحف
    const Color paperColor = Color(0xFFF4F1EA);
    const Color topBarColor = Color(0xFF5D6363);
    const Color textColor = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: paperColor,
      appBar: AppBar(
        backgroundColor: topBarColor,
        elevation: 0,
        leading: IconButton(
          tooltip: 'رجوع',
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              "سورة ${widget.surah.name}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Amiri',
              ),
            ),
            Text(
              "صفحة $_currentPage، جزء ${_getJuzForPage(_currentPage.toInt())}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[300],
                fontFamily: 'Amiri',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'الإعدادات',
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'حفظ العلامة',
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // شريط معلومات صغير (اختياري)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            color: Colors.black12,
            width: double.infinity,
            child: const Text(
              "بِسْمِ اللَّهِ الرَّحْمَِٰ الرَّحِيمِ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
          ),

          // محتوى الآيات
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 24,
                      color: textColor,
                      height: 1.8, // للمسافة بين الأسطر
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Amiri',
                    ),
                    children: _buildVersesWithNumbers(),
                  ),
                ),
              ),
            ),
          ),

          // الشريط السفلي (Slider)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Slider(
              value: _currentPage,
              min: _minPage,
              max: _maxPage,
              divisions: (_maxPage - _minPage).toInt(),
              activeColor: Colors.green[700],
              inactiveColor: Colors.grey[400],
              onChanged: (value) {
                setState(() {
                  _currentPage = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // دالة لحساب الجزء بناءً على رقم الصفحة
  int _getJuzForPage(int page) {
    // تقسيم بسيط للصفحات إلى أجزاء
    if (page <= 22) return 1;
    if (page <= 42) return 2;
    if (page <= 62) return 3;
    if (page <= 82) return 4;
    if (page <= 102) return 5;
    if (page <= 122) return 6;
    if (page <= 142) return 7;
    if (page <= 162) return 8;
    if (page <= 182) return 9;
    if (page <= 202) return 10;
    if (page <= 222) return 11;
    if (page <= 242) return 12;
    if (page <= 262) return 13;
    if (page <= 282) return 14;
    if (page <= 302) return 15;
    if (page <= 322) return 16;
    if (page <= 342) return 17;
    if (page <= 362) return 18;
    if (page <= 382) return 19;
    if (page <= 402) return 20;
    if (page <= 422) return 21;
    if (page <= 442) return 22;
    if (page <= 462) return 23;
    if (page <= 482) return 24;
    if (page <= 502) return 25;
    if (page <= 522) return 26;
    if (page <= 542) return 27;
    if (page <= 562) return 28;
    if (page <= 582) return 29;
    return 30;
  }

  // دالة لبناء نص الآيات مع أرقامها داخل دوائر
  List<InlineSpan> _buildVersesWithNumbers() {
    if (_isLoading) {
      return [
        const WidgetSpan(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5D6363)),
            ),
          ),
        ),
      ];
    }

    if (_error != null) {
      return [
        TextSpan(
          text: _error!,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontFamily: 'Amiri',
          ),
        ),
      ];
    }

    if (_verses.isEmpty) {
      return [
        const TextSpan(
          text: "لا توجد آيات في هذه السورة",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
            fontFamily: 'Amiri',
          ),
        ),
      ];
    }

    List<InlineSpan> spans = [];

    for (int i = 0; i < _verses.length; i++) {
      final verseText = _verses[i];
      final verseNumber = i + 1;

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
              border: Border.all(color: Colors.green, width: 1),
            ),
            child: Text(
              verseNumber.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
          ),
        ),
      );

      // إضافة مسافة بين الآيات
      if (i < _verses.length - 1) {
        spans.add(const TextSpan(text: "\n\n"));
      }
    }

    return spans;
  }
}
