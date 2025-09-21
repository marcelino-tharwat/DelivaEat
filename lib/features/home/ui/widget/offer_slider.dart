import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math; // Import for PatternPainter

class OffersSlider extends StatelessWidget {
  final List<Map<String, dynamic>> offers;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final Function(Map<String, dynamic>) onOfferTap;

  const OffersSlider({
    super.key,
    required this.offers,
    required this.pageController,
    required this.onPageChanged,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenWidth * 0.5,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onPageChanged,
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Container(
            child: Hero(
              tag: 'offer_$index',
              child: Card(
                elevation: 8,
                shadowColor: offer['color'].withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [offer['color'], offer['color'].withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: PatternPainter(offer['color']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        offer['title'],
                                        style: context.textStyles.headlineSmall
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: screenWidth * 0.055,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        offer['subtitle'],
                                        style: context.textStyles.titleMedium
                                            ?.copyWith(
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontSize: screenWidth * 0.04,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 2,
                                                ),
                                              ],
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    '${offer['discount']}${offer['discount'] != appLocalizations.offerFreeDiscount ? '%' : ''}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => onOfferTap(offer),
                                  icon: const Icon(
                                    Icons.shopping_cart,
                                    size: 18,
                                  ),
                                  label: Text(appLocalizations.orderNow),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: offer['color'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                  ),
                                ),
                                Text(
                                  offer['icon'],
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.12,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final Color color;

  PatternPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
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
