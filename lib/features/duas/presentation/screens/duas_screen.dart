import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/duas_provider.dart';

class DuasScreen extends StatelessWidget {
  const DuasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'الأدعية',
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Consumer<DuasProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              if (provider.errorMessage != null) {
                return Center(
                  child: Text(
                    'حدث خطأ في تحميل الأدعية',
                    style: GoogleFonts.cairo(color: Colors.red, fontSize: 18),
                  ),
                );
              }

              // The JSON has one category ("أدعية قرآنية"),
              // so let's grab it directly.
              final category = provider.getCategoryByName('أدعية قرآنية');

              if (category == null || category.items.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد أدعية حالياً',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: category.items.length,
                itemBuilder: (context, index) {
                  final item = category.items[index];
                  return _DuasItemCard(item: item);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DuasItemCard extends StatelessWidget {
  final dynamic item;

  const _DuasItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              item.title,
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Duas Text
            Text(
              item.text,
              style: GoogleFonts.amiri(
                fontSize: 22,
                height: 2.0,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Reference if available
            if (item.reference != null && item.reference.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(thickness: 0.5),
              const SizedBox(height: 8),
              Text(
                item.reference,
                style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.left,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
