import 'dart:math';
import 'package:flutter/material.dart';

/// A widget that paints a subtle noise texture over its child.
/// This fulfills the visual design rule for a premium, tactile feel.
class NoiseBackground extends StatelessWidget {
  final Widget child;

  const NoiseBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NoisePainter(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
        opacity: 0.015,
      ),
      child: child,
    );
  }
}

class _NoisePainter extends CustomPainter {
  final Color color;
  final double opacity;
  final Random _random = Random();

  _NoisePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;

    // To optimize performance, we don't draw noise on every single pixel.
    // We draw random noise points across the canvas.
    final path = Path();
    for (int i = 0; i < (size.width * size.height * 0.05).toInt(); i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      path.addRect(Rect.fromLTWH(x, y, 1, 1));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.opacity != opacity;
  }
}
