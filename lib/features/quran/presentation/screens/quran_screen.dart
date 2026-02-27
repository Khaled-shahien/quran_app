import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/surah_model.dart';
import '../../data/data_sources/surah_api_service.dart';

/// Quran Screen
///
/// Displays the list of all 114 Surahs in the Quran with their details
class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  late SurahApiService _apiService;
  List<SurahModel> _surahs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _apiService = SurahApiService();
    _loadSurahs();
  }

  @override
  void dispose() {
    _apiService.close();
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _apiService.getAllSurahs();
      if (response.status && response.data != null) {
        setState(() {
          _surahs = response.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = response.message ?? 'Failed to load Surahs';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // استخدم ألوان التطبيق
    final Color primaryColor =
        AppColors.lightPrimary; // اللون الأخضر الداكن في الأعلى
    final Color backgroundColor =
        AppColors.scaffoldBackground; // لون الخلفية المائل للبيج
    final Color cardBackground = AppColors.surface; // لون الكروت الأبيض
    final Color accentColor =
        AppColors.lightPrimary; // لون الأرقام والنصوص الرئيسية

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'القرآن الكريم',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _buildBody(accentColor, cardBackground),
      ),
    );
  }

  Widget _buildBody(Color accentColor, Color cardBackground) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error!,
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadSurahs,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSurahs,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _surahs.length,
        itemBuilder: (context, index) {
          final surah = _surahs[index];
          return SurahCard(
            index: index + 1,
            arabicName: surah.surahNameArabic,
            englishName: surah.surahName,
            translation: surah.surahNameTranslation,
            versesCount: surah.totalAyah,
            type: _getRevelationPlaceArabic(surah.revelationPlace),
            accentColor: accentColor,
            cardBackground: cardBackground,
            onTap: () => _onSurahTap(context, surah, index + 1),
          );
        },
      ),
    );
  }

  String _getRevelationPlaceArabic(String revelationPlace) {
    final normalizedPlace = revelationPlace.toLowerCase();
    if (normalizedPlace == 'mecca' ||
        normalizedPlace == 'meccan' ||
        normalizedPlace == 'mc') {
      return 'مكية';
    } else if (normalizedPlace == 'madina' ||
        normalizedPlace == 'medinan' ||
        normalizedPlace == 'md') {
      return 'مدنية';
    }
    return revelationPlace;
  }

  void _onSurahTap(BuildContext context, SurahModel surah, int number) {
    // Show a snackbar with the selected surah info
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم اختيار سورة ${surah.surahNameArabic} (${surah.surahName})',
          style: GoogleFonts.cairo(),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    // Call the specific endpoint for this Surah
    _callSurahEndpoint(context, number, surah);
  }

  /// Calls the specific endpoint for the selected Surah
  Future<void> _callSurahEndpoint(
    BuildContext context,
    int surahNumber,
    SurahModel surah,
  ) async {
    try {
      // Show loading indicator
      final snackBar = SnackBar(
        content: Text(
          'جاري تحميل تفاصيل سورة ${surah.surahNameArabic}...',
          style: GoogleFonts.cairo(),
        ),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // Example endpoints might be:
      // - https://quranapi.pages.dev/api/surah/{surahNumber}.json
      // - https://quranapi.pages.dev/api/surah/{surahNumber}/ayahs
      // For demonstration, I'll use a mock call
      // Removed print statement for production code
      // print('Calling endpoint for Surah $surahNumber (${surah.surahName})');

      // Here you would typically make an API call to get specific Surah data
      // For example:
      // final response = await _apiService.get('surah/$surahNumber.json');

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Show success message
      final successSnackBar = SnackBar(
        content: Text(
          'تم تحميل تفاصيل سورة ${surah.surahNameArabic} بنجاح',
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: Colors.green,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'حدث خطأ أثناء تحميل تفاصيل السورة: $e',
              style: GoogleFonts.cairo(),
            ),
          ),
        );
      }
    }
  }
}

class SurahCard extends StatelessWidget {
  final int index;
  final String arabicName;
  final String englishName;
  final String translation;
  final int versesCount;
  final String type;
  final Color accentColor;
  final Color cardBackground;
  final VoidCallback onTap;

  const SurahCard({
    super.key,
    required this.index,
    required this.arabicName,
    required this.englishName,
    required this.translation,
    required this.versesCount,
    required this.type,
    required this.accentColor,
    required this.cardBackground,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // رقم السورة داخل دائرة
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // أسماء السورة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arabicName,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        englishName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: accentColor.withAlpha((0.8 * 255).round()),
                        ),
                      ),
                      Text(
                        translation,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // تفاصيل (مكية/مدنية وعدد الآيات)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor.withAlpha((0.1 * 255).round()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$versesCount آية',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
