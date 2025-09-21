import 'package:flutter/material.dart';

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    // ... محتوى الكلاس PatternPainter كما هو
       final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2;

    final path = Path();

    // Draw decorative circles
    for (int i = 0; i < 3; i++) {
      final radius = 20.0 + (i * 10);
      final center = Offset(
        size.width * 0.85 + (i * 15),
        size.height * 0.2 + (i * 20),
      );

      paint.style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, paint);
    }

    // Draw some diagonal lines
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 5; i++) {
      final startX = size.width * 0.7;
      final startY = i * 25.0;
      final endX = size.width * 0.9;
      final endY = startY + 15;

      path.moveTo(startX, startY);
      path.lineTo(endX, endY);
    }

    canvas.drawPath(path, paint);

    // Add some dots pattern
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 3; j++) {
        final x = size.width * 0.75 + (i * 8);
        final y = size.height * 0.6 + (j * 8);
        canvas.drawCircle(Offset(x, y), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}