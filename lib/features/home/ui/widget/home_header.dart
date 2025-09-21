import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;

  const HomeHeader({super.key, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;

    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 180, // زودت الارتفاع شوية عشان الـ wave
        width: double.infinity,
        decoration: BoxDecoration(
          color: colors.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          child: Row(
            // عكست الـ Row للـ RTL
            // textDirection: TextDirection.rtl,
            children: [
              // Location Icon - أول حاجة من اليمين
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
          
              // Address - في النص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'التوصيل إلى',
                      style: textStyles.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // const Icon(
                        //   Icons.keyboard_arrow_down,
                        //   size: 20,
                        //   color: Colors.white,
                        // ),
                        // const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'الرياض, شارع الملك فهد',
                            style: textStyles.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
          
              // Notification - آخر حاجة من اليسار
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Stack(
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B6B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: onNotificationTap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    
    // بداية من أعلى يسار
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 40); // نسيب مساحة للموجة
    
    // عمل موجة في الأسفل
    double waveHeight = 20;
    double waveLength = size.width / 4;
    
    for (int i = 0; i <= 4; i++) {
      double x = i * waveLength;
      if (i == 0) {
        // أول نقطة
        path.quadraticBezierTo(
          x + waveLength / 2, 
          size.height - 40 + waveHeight, 
          x + waveLength, 
          size.height - 40
        );
      } else if (i < 4) {
        // النقط اللي في النص
        path.quadraticBezierTo(
          x + waveLength / 2, 
          i % 2 == 1 ? size.height - 40 - waveHeight : size.height - 40 + waveHeight, 
          x + waveLength, 
          size.height - 40
        );
      }
    }
    
    // إكمال للنهاية
    path.lineTo(size.width, 0);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}