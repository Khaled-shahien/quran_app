import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../widgets/notification_permission_dialog.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
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
                    'assets/images/'
                    'بسم الله الرحمن الرحيم.png',
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
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final hasSeenP =
                            prefs.getBool('has_seen_notification_permission') ??
                            false;

                        if (!hasSeenP && context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) => NotificationPermissionDialog(
                              onFinish: () {
                                Navigator.of(ctx).pop();
                                context.go('/home');
                              },
                            ),
                          );
                        } else {
                          if (context.mounted) {
                            context.go('/home');
                          }
                        }
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
