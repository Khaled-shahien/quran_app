import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/repositories/surah_repository.dart';
import '../../domain/entities/surah_entity.dart';
import 'surah_details_screen.dart';

/// Quran Screen
///
/// Displays the list of all 114 Surahs in the Quran with their details
class QuranScreen extends StatelessWidget {
  const QuranScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SurahRepository>(
      builder: (context, repository, child) {
        return _QuranScreenContent(repository: repository);
      },
    );
  }
}

class _QuranScreenContent extends StatefulWidget {
  final SurahRepository repository;

  const _QuranScreenContent({required this.repository});

  @override
  State<_QuranScreenContent> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<_QuranScreenContent> {
  late SurahRepository _repository;
  List<SurahEntity> _surahs = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository;
    _loadSurahs();
  }

  @override
  void dispose() {
    // No need to close repository
    super.dispose();
  }

  Future<void> _loadSurahs() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final surahs = await _repository.getAllSurahs();
      setState(() {
        _surahs = surahs;
        _isLoading = false;
      });
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
    final ThemeData theme = Theme.of(context);
    final Color primaryColor = theme.colorScheme.primary;
    final Color backgroundColor = theme.scaffoldBackgroundColor;
    final Color cardBackground = theme.colorScheme.surface;
    final Color accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'القرآن الكريم',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: _buildBody(theme, accentColor, cardBackground),
      ),
    );
  }

  Widget _buildBody(ThemeData theme, Color accentColor, Color cardBackground) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
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

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _surahs.length,
      itemBuilder: (context, index) {
        final surah = _surahs[index];
        return SurahCard(
          index: index + 1,
          arabicName: surah.name,
          englishName: surah.englishName,
          translation: surah.englishNameTranslation,
          versesCount: surah.totalAyah,
          type: _getRevelationPlaceArabic(surah.revelationType),
          accentColor: accentColor,
          cardBackground: cardBackground,
          textColor: theme.colorScheme.onSurface,
          secondaryTextColor: theme.colorScheme.onSurfaceVariant,
          onTap: () => _onSurahTap(context, surah, index + 1),
        );
      },
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

  void _onSurahTap(BuildContext context, SurahEntity surah, int number) {
    // Navigate to the Surah details screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SurahDetailsScreen(surah: surah, surahNumber: number),
      ),
    );
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
  final Color textColor;
  final Color secondaryTextColor;
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
    required this.textColor,
    required this.secondaryTextColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: accentColor, width: 1),
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
                          color: textColor,
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
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryTextColor,
                        ),
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
                        color: secondaryTextColor,
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
