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

  // --- Helper Widgets for the More (المزيد) Menu ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, right: 20, left: 20),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          fontSize: 14,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }

  Widget _buildMoreMenuItem({
    required String title,
    Widget? leadingIcon,
    Widget? trailingWidget,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              leadingIcon,
              const SizedBox(width: 16),
            ],
            if (leadingIcon == null) const SizedBox(width: 40),

            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor ?? Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            if (trailingWidget != null) ...[
              const SizedBox(width: 16),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoreMenuSwitch({
    required String title,
    required String subtitle,
    required Widget leadingIcon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? rightSubtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          // Right Side: Icon
          leadingIcon,
          const SizedBox(width: 16),

          // Middle: Text
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // start in RTL is right
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          // Left Side: Switch & Subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.end, // end in RTL is left
            children: [
              SizedBox(
                height: 30,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.primary,
                ),
              ),
              if (rightSubtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  rightSubtitle,
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF5A7B1E), // Greenish color matching design
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
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
    }

    final Color iconColor = Theme.of(context).colorScheme.primary;

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        // 1. دعم التطبيق
        _buildSectionHeader('دعم التطبيق'),
        _buildMoreMenuItem(
          title: 'قم بدعم التطبيق',
          trailingWidget: const Icon(Icons.favorite, color: Colors.red),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 2. الختمة الحالية
        _buildSectionHeader('الختمة الحالية'),
        _buildMoreMenuItem(
          title: 'الأوراد السابقة',
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBadge('6'),
              const SizedBox(width: 12),
              Icon(Icons.keyboard_arrow_left, size: 24, color: iconColor),
            ],
          ),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الأوراد القادمة',
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBadge('23'),
              const SizedBox(width: 12),
              Icon(Icons.keyboard_arrow_left, size: 24, color: iconColor),
            ],
          ),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الفاصل',
          trailingWidget: Icon(Icons.bookmark, color: iconColor),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 3. أقسام القرآن (From old settings)
        _buildSectionHeader('أقسام القرآن'),
        _buildMoreMenuItem(
          title: 'التفسير',
          leadingIcon: Icon(Icons.auto_stories, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الأجزاء',
          leadingIcon: Icon(Icons.menu_book, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الأحزاب',
          leadingIcon: Icon(Icons.bookmark_border, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'السجدات',
          leadingIcon: Icon(Icons.pan_tool_alt_outlined, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الركوع',
          leadingIcon: Icon(Icons.accessibility_new, color: iconColor),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 4. سنن قرآنية
        _buildSectionHeader('سنن قرآنية'),
        _buildMoreMenuItem(
          title: 'سورة الكهف',
          leadingIcon: Icon(Icons.book, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'سورة الملك',
          leadingIcon: Icon(Icons.menu_book, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'سورة البقرة',
          leadingIcon: Icon(Icons.auto_stories, color: iconColor),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 5. الإعدادات
        _buildSectionHeader('الإعدادات'),
        _buildMoreMenuSwitch(
          title: 'تفعيل الوضع الليلي',
          subtitle: 'تغيير مظهر التطبيق',
          leadingIcon: Icon(Icons.dark_mode_outlined, color: iconColor),
          value: isDark,
          onChanged: (v) {
            themeProvider.toggleTheme(v);
          },
        ),
        _buildMoreMenuItem(
          title: 'المنبه اليومي',
          leadingIcon: Icon(Icons.notifications, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'بدء ختمة جديدة',
          leadingIcon: Icon(Icons.add, color: iconColor),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 6. مواقيت الصلاة
        _buildSectionHeader('مواقيت الصلاة'),
        _buildMoreMenuItem(
          title: 'إعدادات مواقيت الصلاة',
          leadingIcon: Icon(Icons.mosque, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'اتجاه القبلة',
          leadingIcon: Image.asset(
            'assets/images/kaaba.png',
            width: 24,
            height: 24,
            color: isDark ? Colors.white : null,
            errorBuilder: (c, e, s) => Icon(Icons.explore, color: iconColor),
          ),
          onTap: showComingSoon,
        ),
        const Divider(height: 1),

        // 7. منبهات الأذكار
        _buildSectionHeader('منبهات الأذكار'),
        _buildMoreMenuSwitch(
          title: 'منبه أذكار الصباح',
          subtitle: 'وقت منبه أذكار الصباح',
          rightSubtitle: 'AM 07:00',
          leadingIcon: Icon(Icons.wb_sunny, color: iconColor),
          value: false,
          onChanged: (val) => showComingSoon(),
        ),
        _buildMoreMenuSwitch(
          title: 'منبه أذكار المساء',
          subtitle: 'وقت منبه أذكار المساء',
          rightSubtitle: 'PM 05:30',
          leadingIcon: Icon(Icons.nightlight_round, color: iconColor),
          value: false,
          onChanged: (val) => showComingSoon(),
        ),
        const Divider(height: 1),

        // 8. منبهات السنن
        _buildSectionHeader('منبهات السنن'),
        _buildMoreMenuSwitch(
          title: 'منبه سورة الملك',
          subtitle: 'وقت منبه سورة الملك',
          rightSubtitle: 'PM 09:00',
          leadingIcon: Icon(Icons.notifications, color: iconColor),
          value: false,
          onChanged: (val) => showComingSoon(),
        ),
        _buildMoreMenuSwitch(
          title: 'منبه سورة البقرة',
          subtitle: 'وقت منبه سورة البقرة',
          rightSubtitle: 'PM 08:30',
          leadingIcon: Icon(Icons.notifications, color: iconColor),
          value: false,
          onChanged: (val) => showComingSoon(),
        ),
        const Divider(height: 1),

        // 9. تطبيق ختمة
        _buildSectionHeader('تطبيق ختمة'),
        _buildMoreMenuItem(
          title: 'الصفحة الرئيسية',
          leadingIcon: Icon(Icons.home_outlined, color: iconColor),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        _buildMoreMenuItem(
          title: 'اللغة',
          leadingIcon: Icon(Icons.settings, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'الإتصال بنا',
          leadingIcon: Icon(Icons.info_outline, color: iconColor),
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'تابعنا على تويتر',
          leadingIcon: const Icon(
            Icons.flutter_dash,
            color: Colors.lightBlue,
          ), // Placeholder for Twitter
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'تابعنا على انستقرام',
          leadingIcon: const Icon(
            Icons.camera_alt,
            color: Colors.purple,
          ), // Placeholder for Instagram
          onTap: showComingSoon,
        ),
        _buildMoreMenuItem(
          title: 'انشر التطبيق',
          leadingIcon: Icon(Icons.share, color: iconColor),
          onTap: () {
            Share.share(
              'تطبيق القرآن الكريم - تطبيق إسلامي شامل. حمل الآن! \n(رابط التطبيق قريباً)',
            );
          },
        ),
        _buildMoreMenuItem(
          title: 'قيم تطبيق ختمة',
          leadingIcon: Icon(Icons.thumb_up_alt_outlined, color: iconColor),
          onTap: showComingSoon,
        ),
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
