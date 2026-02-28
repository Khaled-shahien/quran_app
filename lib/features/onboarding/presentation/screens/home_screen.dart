import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_provider.dart';
import '../providers/favorites_provider.dart';
import '../widgets/header_card_widget.dart';
import '../widgets/daily_verse_section_widget.dart';
import '../widgets/tab_switcher_widget.dart';
import '../widgets/category_grid_widget.dart';
import '../widgets/media_tiles_widget.dart';
import '../widgets/prayer_times_widget.dart';
import '../../../prayers/presentation/providers/prayer_times_performance_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTabIndex = 0; // 0: جميع التصنيفات, 1: كل الوسائط, 2: أوقات الصلاة
  int drawerSubTab = 0; // 0 للأعدادات، 1 للمفضلة
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prayerProvider = Provider.of<PrayerTimesPerformanceProvider>(
        context,
        listen: false,
      );
      // Fetch prayer times for Cairo by default
      prayerProvider.fetchPrayerTimes(DateTime.now(), 30.0444, 31.2357);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer:
          _buildNavigationDrawer(), // القائمة الجانبية (يمين لأن التطبيق عربي)
      appBar: _buildAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(child: HeaderCardWidget()),
            const SliverToBoxAdapter(child: DailyVerseSectionWidget()),
            SliverToBoxAdapter(
              child: TabSwitcherWidget(
                onTabChanged: (index) {
                  setState(() {
                    selectedTabIndex = index;
                  });
                },
                selectedIndex: selectedTabIndex,
              ),
            ),

            // المحتوى المتغير
            _buildDynamicContent(),

            const SliverToBoxAdapter(child: SizedBox(height: 50)),
          ],
        ),
      ),
    );
  }

  // --- 1. AppBar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: Icon(
        Icons.search,
        color: Theme.of(context).colorScheme.primary,
        size: 28,
      ),
      title: Text(
        'القرآن الكريم',
        style: GoogleFonts.cairo(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.segment,
            color: Theme.of(context).colorScheme.primary,
            size: 30,
          ),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  // --- 2. القائمة الجانبية المطورة (Navigation Drawer) ---
  Widget _buildNavigationDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // رأس القائمة الداكن
            Container(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 20,
                right: 20,
                left: 20,
              ),
              color: AppColors.darkCard,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'القرآن الكريم',
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.menu_book, color: Colors.white),
                  ),
                ],
              ),
            ),

            // مفتاح التبديل بين الإعدادات والمفضلة
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF634D43).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _drawerTabItem('الاعدادات', 0),
                    _drawerTabItem('المفضلة', 1),
                  ],
                ),
              ),
            ),

            // محتوى القائمة المتغير (إعدادات أو مفضلة)
            Expanded(
              child: drawerSubTab == 0
                  ? _buildSettingsList()
                  : _buildFavoritesList(),
            ),
          ],
        ),
      ),
    );
  }

  // --- مكونات واجهة المستخدم المساعدة ---

  Widget _drawerItem(String title, IconData icon, [VoidCallback? onTap]) =>
      ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        ),
        onTap: onTap,
      );

  Widget _drawerTabItem(String label, int index) {
    bool active = drawerSubTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => drawerSubTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cairo(
              color: active ? Colors.white : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    void showComingSoon() {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'هذه الميزة ستتوفر قريباً إن شاء الله',
            style: GoogleFonts.cairo(),
            textAlign: TextAlign.center,
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Close drawer after showing
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _drawerItem('التفسير', Icons.auto_stories, showComingSoon),
        _drawerItem('الأجزاء', Icons.menu_book, showComingSoon),
        _drawerItem('الأحزاب', Icons.bookmark_border, showComingSoon),
        _drawerItem('السجدات', Icons.pan_tool_alt_outlined, showComingSoon),
        _drawerItem('الركوع', Icons.accessibility_new, showComingSoon),
        const Divider(height: 30, indent: 20, endIndent: 20),
        _drawerItem('الصفحة الرئيسية', Icons.home_outlined, () {
          Navigator.pop(context);
        }),
        ListTile(
          leading: const Icon(
            Icons.dark_mode_outlined,
            color: AppColors.primary,
          ),
          title: Text('تفعيل الوضع الليلي', style: GoogleFonts.cairo()),
          trailing: Switch(
            value: isDark,
            activeThumbColor: AppColors.primary,
            onChanged: (v) {
              themeProvider.toggleTheme(v);
            },
          ),
        ),
        _drawerItem('مشاركة التطبيق', Icons.share_outlined, () {
          Navigator.pop(context); // Close drawer before sharing
          Share.share(
            'تطبيق القرآن الكريم - تطبيق إسلامي شامل. حمل الآن! \n(رابط التطبيق قريباً)',
          );
        }),
      ],
    );
  }

  Widget _buildFavoritesList() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final favorites = favoritesProvider.favoriteVerses;

        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'لا توجد آيات مفضلة',
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final verse = favorites[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          Icons.cancel,
                          color: Theme.of(context).colorScheme.primary,
                          size: 20,
                        ),
                        onPressed: () {
                          favoritesProvider.removeFavorite(verse);
                        },
                      ),
                      Expanded(
                        child: Text(
                          verse['arabic'] ?? '',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.amiri(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    verse['surah'] ?? '',
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.8),
                    ),
                  ),
                  if (verse['english'] != null)
                    Text(
                      verse['english']!,
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.left,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDynamicContent() {
    if (selectedTabIndex == 0) {
      return const CategoryGridWidget();
    } else if (selectedTabIndex == 1) {
      return const MediaTilesWidget();
    } else {
      return const SliverToBoxAdapter(child: PrayerTimesWidget());
    }
  }
}
