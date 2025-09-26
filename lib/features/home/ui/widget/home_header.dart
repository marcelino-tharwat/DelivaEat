// import 'package:deliva_eat/core/theme/light_dark_mode.dart';
// import 'package:flutter/material.dart';
// import 'dart:math';

// class HomeHeader extends StatelessWidget {
//   final VoidCallback onNotificationTap;

//   const HomeHeader({super.key, required this.onNotificationTap});

//   @override
//   Widget build(BuildContext context) {
//     final colors = context.colors;
//     final textStyles = context.textStyles;

//     return ClipPath(
//       clipper: WaveClipper(),
//       child: Container(
//         height: 180, // زودت الارتفاع شوية عشان الـ wave
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: colors.primary,
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
//           child: Row(
//             // عكست الـ Row للـ RTL
//             // textDirection: TextDirection.rtl,
//             children: [
//               // Location Icon - أول حاجة من اليمين
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.location_on,
//                   color: Colors.white,
//                   size: 24,
//                 ),
//               ),
//               const SizedBox(width: 12),
          
//               // Address - في النص
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'التوصيل إلى',
//                       style: textStyles.bodySmall?.copyWith(
//                         color: Colors.white.withOpacity(0.8),
//                         fontSize: 12,
//                       ),
//                       textAlign: TextAlign.start,
//                     ),
//                     const SizedBox(height: 2),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         // const Icon(
//                         //   Icons.keyboard_arrow_down,
//                         //   size: 20,
//                         //   color: Colors.white,
//                         // ),
//                         // const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             'الرياض, شارع الملك فهد',
//                             style: textStyles.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             textAlign: TextAlign.start,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 12),
          
//               // Notification - آخر حاجة من اليسار
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: IconButton(
//                   icon: Stack(
//                     children: [
//                       const Icon(
//                         Icons.notifications_none_rounded,
//                         color: Colors.white,
//                         size: 24,
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFFF6B6B),
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   onPressed: onNotificationTap,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class WaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
    
//     // بداية من أعلى يسار
//     path.moveTo(0, 0);
//     path.lineTo(0, size.height - 40); // نسيب مساحة للموجة
    
//     // عمل موجة في الأسفل
//     double waveHeight = 20;
//     double waveLength = size.width / 4;
    
//     for (int i = 0; i <= 4; i++) {
//       double x = i * waveLength;
//       if (i == 0) {
//         // أول نقطة
//         path.quadraticBezierTo(
//           x + waveLength / 2, 
//           size.height - 40 + waveHeight, 
//           x + waveLength, 
//           size.height - 40
//         );
//       } else if (i < 4) {
//         // النقط اللي في النص
//         path.quadraticBezierTo(
//           x + waveLength / 2, 
//           i % 2 == 1 ? size.height - 40 - waveHeight : size.height - 40 + waveHeight, 
//           x + waveLength, 
//           size.height - 40
//         );
//       }
//     }
    
//     // إكمال للنهاية
//     path.lineTo(size.width, 0);
//     path.close();
    
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
import 'package:flutter/material.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart'; 
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'categories_bar.dart';
import 'offer_slider.dart';


class HomeHeader extends StatelessWidget {
  final VoidCallback onNotificationTap;
  final Function(String) onSeeAllTap;
  final List<Map<String, dynamic>> categories;
  final PageController categoriesPageController;
  final Function(Map<String, dynamic>) onCategoryTap;
  final List<Map<String, dynamic>> offers;
  final PageController offersPageController;
  final int currentOfferSlide;
  final ValueChanged<int> onOfferPageChanged;
  final Function(Map<String, dynamic>) onOfferTap;

  const HomeHeader({
    super.key,
    required this.onNotificationTap,
    required this.onSeeAllTap,
    required this.categories,
    required this.categoriesPageController,
    required this.onCategoryTap,
    required this.offers,
    required this.offersPageController,
    required this.currentOfferSlide,
    required this.onOfferPageChanged,
    required this.onOfferTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final appLocalizations = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.63,
      width: double.infinity,
      decoration: BoxDecoration(color: colors.primary),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.deliveryTo,
                        style: textStyles.bodySmall?.copyWith(color: Colors.white.withOpacity(0.8)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appLocalizations.selected_address,
                        style: textStyles.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 24),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: Color(0xFFFF6B6B), shape: BoxShape.circle),
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
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalizations.categories,
                  style: textStyles.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          CategoriesBar(
            categories: categories,
            pageController: categoriesPageController,
            onCategoryTap: onCategoryTap,
          ),
          const SizedBox(height: 10),
          MediaQuery.removePadding(
            context: context,
            removeLeft: true,
            removeRight: true,
            removeTop: true,
            child: OffersSlider(
              currentPageIndex: currentOfferSlide,
              offers: offers,
              pageController: offersPageController,
              onPageChanged: onOfferPageChanged,
              onOfferTap: onOfferTap,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}