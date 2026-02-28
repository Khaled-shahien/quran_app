import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// A screen to showcase the implemented theme and colors
class ThemeShowcaseScreen extends StatelessWidget {
  const ThemeShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Theme Showcase',
          style: GoogleFonts.cairo(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Light mode colors section
            const Text(
              'Light Mode Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildColorCard(
              'Background',
              Theme.of(context).scaffoldBackgroundColor,
              AppColors.primaryText,
            ),
            _buildColorCard(
              'Secondary',
              Theme.of(context).colorScheme.secondary,
              AppColors.primaryText,
            ),
            _buildColorCard('Primary', Theme.of(context).colorScheme.primary, AppColors.white),
            _buildColorCard(
              'Page/Accent',
              AppColors.lightPageAccent,
              AppColors.primaryText,
            ),
            _buildColorCard(
              'Card Content',
              AppColors.lightCardContent,
              AppColors.primaryText,
            ),

            const SizedBox(height: 20),

            // Dark mode colors section
            const Text(
              'Dark Mode Colors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildColorCard(
              'Background',
              AppColors.darkBackground,
              AppColors.white,
            ),
            _buildColorCard(
              'Secondary',
              AppColors.darkSecondary,
              AppColors.white,
            ),
            _buildColorCard('Primary', AppColors.darkPrimary, AppColors.black),
            _buildColorCard(
              'Page/Accent',
              AppColors.darkPageAccent,
              AppColors.black,
            ),
            _buildColorCard(
              'Card Content',
              AppColors.darkCardContent,
              AppColors.primaryText,
            ),

            const SizedBox(height: 20),

            // Caption color
            _buildColorCard('Captions', AppColors.captions, AppColors.white),

            const SizedBox(height: 20),

            // Theme sample widgets
            const Text(
              'Theme Sample Widgets',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // Elevated button sample
            ElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),

            const SizedBox(height: 10),

            // Outlined button sample
            OutlinedButton(
              onPressed: () {},
              child: const Text('Outlined Button'),
            ),

            const SizedBox(height: 10),

            // Card sample
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Sample Card',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(String title, Color color, Color textColor) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                '$title: ${_colorToString(color)}',
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _colorToString(Color color) {
    // ignore: deprecated_member_use
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}
