import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MediaTilesWidget extends StatelessWidget {
  const MediaTilesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        _mediaTile('المقالات', const Color(0xFF235347)),
        _mediaTile('الصوتيات', const Color(0xFF2D2D2D)),
        _mediaTile('الفيديوهات', const Color(0xFF8B4242)),
      ]),
    );
  }

  Widget _mediaTile(String title, Color color) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Text(
      title,
      style: GoogleFonts.cairo(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}
