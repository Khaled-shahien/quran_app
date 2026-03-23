import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/notification_provider.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool _isTestMode = false;

  void _toggleTestMode() {
    setState(() {
      _isTestMode = !_isTestMode;
    });
  }

  Future<void> _scheduleTestAlarm() async {
    try {
      final provider = context.read<NotificationProvider>();

      // Schedule alarm for 5 minutes from now using the new test method
      final now = DateTime.now();
      final testTime = now.add(const Duration(minutes: 5));

      await provider.scheduleTestAlarmAfter5Minutes(
        id: 9999, // Test alarm ID
        title: '⏰ منبه اختبار',
        body: 'هذا إشعار اختبار - تم ضبطه بعد 5 دقائق',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ تم ضبط منبه اختبار للساعة ${testTime.hour.toString().padLeft(2, '0')}:${testTime.minute.toString().padLeft(2, '0')}\n'
              'سيظهر الإشعار بعد 5 دقائق',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 5),
          ),
        );
      }

      // Print debug info
      debugPrint('🔔 TEST ALARM SCHEDULED FOR: ${testTime.toString()}');
      debugPrint('⏰ Current time: ${now.toString()}');
      debugPrint('⏱️ Will appear in: 5 minutes');
    } catch (e) {
      debugPrint('❌ ERROR scheduling test alarm: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ فشل ضبط المنبه: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.kPaddingLarge,
              ),
              child: Column(
                children: [
                  const SizedBox(height: AppConstants.kPaddingExtraLarge),

                  // Basmalah
                  Image.asset(
                    'assets/images/بسم الله الرحمن الرحيم.png',
                    width: 350,
                    fit: BoxFit.contain,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),

                  const SizedBox(height: AppConstants.kPaddingLarge),

                  // Central Image Container
                  Container(
                    width: double.infinity,
                    height: screenSize.height * 0.38,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(
                        AppConstants.kBorderRadiusExtraLarge,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular halo behind the image
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        // Quran image
                        Image.asset(
                          'assets/images/المصحف.png',
                          width: 280,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.menu_book_rounded,
                            size: 100,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // App Title
                  Text(
                    AppStrings.onboardingTitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: AppConstants.kPaddingSmall),

                  // Description
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.kPaddingMedium,
                    ),
                    child: Text(
                      AppStrings.onboardingDescription,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.kPaddingLarge),

                  // Get Started Button
                  Container(
                    width: double.infinity,
                    height: AppConstants.kButtonHeight,
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.kPaddingLarge,
                    ),
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.outline,
                          width: 1.2,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppConstants.kBorderRadiusLarge,
                          ),
                        ),
                        padding: EdgeInsets.zero, // Remove default padding
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.getStartedButton,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Test Mode Toggle (Developer Only - Hidden Feature)
                  if (_isTestMode) ...[
                    Container(
                      width: double.infinity,
                      height: AppConstants.kButtonHeight,
                      margin: const EdgeInsets.only(
                        bottom: AppConstants.kPaddingMedium,
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _scheduleTestAlarm,
                        icon: const Icon(Icons.alarm_add),
                        label: const Text('تجربة منبه بعد 5 دقائق'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Secret Test Mode Toggle Button (visible in corner)
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _toggleTestMode,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _isTestMode
                      ? Theme.of(context).colorScheme.errorContainer
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.bug_report,
                  size: 28,
                  color: _isTestMode
                      ? Theme.of(context).colorScheme.onErrorContainer
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
