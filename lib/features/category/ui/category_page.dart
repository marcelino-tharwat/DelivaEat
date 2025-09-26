// import 'package:deliva_eat/core/routing/routes.dart'; // تأكد من أن هذا المسار صحيح
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';

// class CategoriesPage extends StatefulWidget {
//   const CategoriesPage({super.key, this.title = ""});
//   final String title;
//   @override
//   State<CategoriesPage> createState() => _CategoriesPageState();
// }

// class _CategoriesPageState extends State<CategoriesPage> {
//   // تم حذف الـ searchController و searchQuery
//   String _selectedCategoryId = '';

//   // يمكنك أيضًا ترجمة البيانات هنا إذا أردت
//   final List<FoodCategory> _categories = [
//     FoodCategory(id: '1', name: 'برجر', icon: Icons.lunch_dining, color: const Color(0xFFFF6B35)),
//     FoodCategory(id: '2', name: 'بيتزا', icon: Icons.local_pizza, color: const Color(0xFFE63946)),
//     FoodCategory(id: '3', name: 'دجاج', icon: Icons.set_meal, color: const Color(0xFFFFB800)),
//     FoodCategory(id: '4', name: 'مصري', icon: Icons.restaurant, color: const Color(0xFF2ECC71)),
//     FoodCategory(id: '5', name: 'صيني', icon: Icons.ramen_dining, color: const Color(0xFF9B59B6)),
//     FoodCategory(id: '6', name: 'حلويات', icon: Icons.cake, color: const Color(0xFFE91E63)),
//     FoodCategory(id: '7', name: 'بحري', icon: Icons.set_meal_outlined, color: const Color(0xFF3498DB)),
//     FoodCategory(id: '8', name: 'صحي', icon: Icons.eco, color: const Color(0xFF27AE60)),
//   ];

//   final Map<String, List<Restaurant>> _restaurantsByCategory = {
//     '1': [
//       Restaurant(
//         id: '1', name: 'برجر كينج', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.5, reviewsCount: 1250, deliveryTime: '30-45', deliveryFee: 15, originalDeliveryFee: 20, cuisine: 'وجبات سريعة أمريكية', discount: 'خصم 10%', isFavorite: false, isPromoted: true, tags: ['وجبات سريعة', 'برجر', 'أمريكي'], minimumOrder: 50),
//       Restaurant(id: '2', name: 'ماكدونالدز', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.2, reviewsCount: 2100, deliveryTime: '25-40', deliveryFee: 12, cuisine: 'وجبات سريعة أمريكية', isFavorite: true, tags: ['وجبات سريعة', 'برجر', 'إفطار'], minimumOrder: 40),
//       Restaurant(id: '3', name: 'كايرو برجر', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.7, reviewsCount: 890, deliveryTime: '35-50', deliveryFee: 0, originalDeliveryFee: 18, cuisine: 'برجر محلي', discount: 'توصيل مجاني', isFavorite: false, tags: ['محلي', 'برجر', 'مصري'], minimumOrder: 60),
//     ],
//     // Add similar data for other categories...
//   };

//   List<Restaurant> get _filteredRestaurants {
//     if (_selectedCategoryId.isNotEmpty) {
//       return _restaurantsByCategory[_selectedCategoryId] ?? [];
//     }
//     // يعرض كل المطاعم إذا لم يتم اختيار فئة
//     return _restaurantsByCategory.values.expand((list) => list).toList();
//   }
  
//   // لا نحتاج للـ dispose بعد الآن
//   // @override
//   // void dispose() {
//   //   _searchController.dispose();
//   //   super.dispose();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 50),
//             // Title
//             const Text(
//               'قسم الطعام',
//               textAlign: TextAlign.start,
//               style: TextStyle(
//                 color: Color(0xFF2C3E50),
//                 fontWeight: FontWeight.bold,
//                 fontSize: 28,
//               ),
//             ),
//             // Search Bar
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.08),
//                       blurRadius: 12,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 // --- [ START OF CHANGES ] ---
//                 child: GestureDetector(
//                   onTap: () {
//                     HapticFeedback.lightImpact();
//                     context.go(AppRoutes.searchPage);
//                   },
//                   child: const TextField(
//                     enabled: false, // تعطيل الحقل
//                     decoration: InputDecoration(
//                       hintText: 'ابحث عن مطاعم، مأكولات...',
//                       hintStyle: TextStyle(
//                         color: Color(0xFF95A5A6),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w400,
//                       ),
//                       prefixIcon: Icon(
//                         Icons.search_rounded,
//                         color: Color(0xFF95A5A6),
//                         size: 24,
//                       ),
//                       border: InputBorder.none,
//                       disabledBorder: InputBorder.none, // مهم للحفاظ على الشكل
//                       contentPadding: EdgeInsets.symmetric(
//                         vertical: 18,
//                         horizontal: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // --- [ END OF CHANGES ] ---
//               ),
//             ),

//             // Categories Horizontal List
//             Container(
//               padding: const EdgeInsets.symmetric(vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text(
//                       'الأصناف',
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xFF2C3E50),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height: 110,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _categories.length,
//                       itemBuilder: (context, index) {
//                         final category = _categories[index];

//                         return GestureDetector(
//                           onTap: () {
//                             HapticFeedback.mediumImpact();
//                             setState(() {
//                               _selectedCategoryId =
//                                   _selectedCategoryId == category.id
//                                       ? ''
//                                       : category.id;
//                             });
//                           },
//                           child: Container(
//                             width: 85,
//                             margin: const EdgeInsets.symmetric(horizontal: 4),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.06),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                               border: Border.all(
//                                 color: _selectedCategoryId == category.id
//                                     ? category.color
//                                     : const Color(0xFFF0F0F0),
//                                 width: 1.5,
//                               ),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: category.color.withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Icon(
//                                     category.icon,
//                                     size: 28,
//                                     color: category.color,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   category.name,
//                                   style: const TextStyle(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF2C3E50),
//                                   ),
//                                   textAlign: TextAlign.center,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Header for restaurants
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
//               child: Row(
//                 children: [
//                   Text(
//                     _selectedCategoryId.isNotEmpty
//                         ? 'مطاعم ${_categories.firstWhere((c) => c.id == _selectedCategoryId).name}'
//                         : 'الأشهر بالقرب منك',
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2C3E50),
//                     ),
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3498DB).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       '${_filteredRestaurants.length} أماكن',
//                       style: const TextStyle(
//                         color: Color(0xFF3498DB),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Restaurants List
//             _filteredRestaurants.isEmpty
//                 ? const Center(
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 64.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.restaurant_menu_rounded, size: 80, color: Color(0xFFBDC3C7)),
//                           SizedBox(height: 16),
//                           Text(
//                             'لم يتم العثور على مطاعم',
//                             style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF7F8C8D)),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'حاول تعديل بحثك أو استكشف\nأصنافًا مختلفة.',
//                             style: TextStyle(fontSize: 16, color: Color(0xFFBDC3C7)),
//                             textAlign: TextAlign.center,
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Column(
//                       children: List.generate(
//                         _filteredRestaurants.length,
//                         (index) => _buildEnhancedRestaurantCard(context, _filteredRestaurants[index]),
//                       ),
//                     ),
//                   ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildEnhancedRestaurantCard(BuildContext context, Restaurant restaurant) {
//     // محتوى الكارت يبقى كما هو بدون تغيير
//     return Container(
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: () {
//             HapticFeedback.lightImpact();
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Row(
//                   children: [
//                     const Icon(Icons.restaurant, color: Colors.white),
//                     const SizedBox(width: 8),
//                     Text('جاري فتح ${restaurant.name}...'),
//                   ],
//                 ),
//                 backgroundColor: const Color(0xFF27AE60),
//                 behavior: SnackBarBehavior.floating,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 margin: const EdgeInsets.all(16),
//               ),
//             );
//           },
//           borderRadius: BorderRadius.circular(20),
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 16,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                       child: SizedBox(
//                         height: 180,
//                         width: double.infinity,
//                         child: Image.network(
//                           restaurant.image,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               color: const Color(0xFFF8F9FA),
//                               child: const Center(
//                                 child: Icon(Icons.broken_image_rounded, size: 60, color: Color(0xFFBDC3C7)),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Positioned.fill(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
//                           ),
//                         ),
//                       ),
//                     ),
//                     if (restaurant.discount != null)
//                       Positioned(
//                         top: 16, left: 16,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             gradient: const LinearGradient(colors: [Color(0xFFE63946), Color(0xFFFF4757)]),
//                             borderRadius: BorderRadius.circular(20),
//                             boxShadow: [BoxShadow(color: const Color(0xFFE63946).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
//                           ),
//                           child: Text(restaurant.discount!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                     if (restaurant.isPromoted == true)
//                       Positioned(
//                         top: 16, right: 16,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                           decoration: BoxDecoration(color: const Color(0xFFFFB800), borderRadius: BorderRadius.circular(12)),
//                           child: const Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Icon(Icons.star, size: 12, color: Colors.white),
//                               SizedBox(width: 2),
//                               Text('مُميّز', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
//                             ],
//                           ),
//                         ),
//                       ),
//                     Positioned(
//                       bottom: 16, right: 16,
//                       child: Container(
//                         decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
//                         child: IconButton(
//                           onPressed: () { HapticFeedback.lightImpact(); },
//                           icon: Icon(restaurant.isFavorite ? Icons.favorite : Icons.favorite_border, color: restaurant.isFavorite ? const Color(0xFFE63946) : const Color(0xFF95A5A6)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 16, left: 16,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                         decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const Icon(Icons.access_time, size: 14, color: Colors.white),
//                             const SizedBox(width: 4),
//                             Text('${restaurant.deliveryTime} دقيقة', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(restaurant.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)), maxLines: 1, overflow: TextOverflow.ellipsis),
//                           ),
//                           const SizedBox(width: 8),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(color: const Color(0xFFFFB800).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB800)),
//                                 const SizedBox(width: 2),
//                                 Text(restaurant.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFB800))),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Text(restaurant.cuisine, style: const TextStyle(color: Color(0xFF7F8C8D), fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
//                           ),
//                           Text('(${restaurant.reviewsCount}+ تقييم)', style: const TextStyle(color: Color(0xFF95A5A6), fontSize: 12)),
//                         ],
//                       ),
//                       const SizedBox(height: 12),
//                       if (restaurant.tags.isNotEmpty)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 12),
//                           child: Wrap(
//                             spacing: 6,
//                             runSpacing: 4,
//                             children: restaurant.tags.take(3).map((tag) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF3498DB).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(color: const Color(0xFF3498DB).withOpacity(0.2), width: 1),
//                                 ),
//                                 child: Text(tag, style: const TextStyle(color: Color(0xFF3498DB), fontSize: 11, fontWeight: FontWeight.w600)),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(12)),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(6),
//                                     decoration: BoxDecoration(color: const Color(0xFF27AE60).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
//                                     child: const Icon(Icons.delivery_dining_rounded, size: 18, color: Color(0xFF27AE60)),
//                                   ),
//                                   const SizedBox(width: 8),
//                                   Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         restaurant.deliveryFee == 0 ? 'توصيل مجاني' : '${restaurant.deliveryFee} جنيه',
//                                         style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: restaurant.deliveryFee == 0 ? const Color(0xFF27AE60) : const Color(0xFF2C3E50)),
//                                       ),
//                                       if (restaurant.originalDeliveryFee != null && restaurant.originalDeliveryFee! > restaurant.deliveryFee)
//                                         Text(
//                                           '${restaurant.originalDeliveryFee} جنيه',
//                                           style: const TextStyle(fontSize: 11, color: Color(0xFF95A5A6), decoration: TextDecoration.lineThrough),
//                                         ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               height: 30, width: 1, color: const Color(0xFFE0E6ED),
//                               margin: const EdgeInsets.symmetric(horizontal: 12),
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: [
//                                 const Text('الحد الأدنى', style: TextStyle(fontSize: 11, color: Color(0xFF95A5A6), fontWeight: FontWeight.w500)),
//                                 Text('${restaurant.minimumOrder} جنيه', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50))),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Data Models
// class FoodCategory {
//   final String id;
//   final String name;
//   final IconData icon;
//   final Color color;

//   FoodCategory({
//     required this.id,
//     required this.name,
//     required this.icon,
//     required this.color,
//   });
// }

// class Restaurant {
//   final String id;
//   final String name;
//   final String image;
//   final double rating;
//   final int reviewsCount;
//   final String deliveryTime;
//   final int deliveryFee;
//   final int? originalDeliveryFee;
//   final String cuisine;
//   final String? discount;
//   final bool isFavorite;
//   final bool isPromoted;
//   final List<String> tags;
//   final int minimumOrder;

//   Restaurant({
//     required this.id,
//     required this.name,
//     required this.image,
//     required this.rating,
//     required this.reviewsCount,
//     required this.deliveryTime,
//     required this.deliveryFee,
//     this.originalDeliveryFee,
//     required this.cuisine,
//     this.discount,
//     required this.isFavorite,
//     this.isPromoted = false,
//     required this.tags,
//     required this.minimumOrder,
//   });
// }
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key, this.title = ""});
  final String title;
  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String _selectedCategoryId = '';

  final List<FoodCategory> _categories = [
    FoodCategory(id: '1', name: 'برجر', icon: Icons.lunch_dining, color: const Color(0xFFFF6B35)),
    FoodCategory(id: '2', name: 'بيتزا', icon: Icons.local_pizza, color: const Color(0xFFE63946)),
    FoodCategory(id: '3', name: 'دجاج', icon: Icons.set_meal, color: const Color(0xFFFFB800)),
    FoodCategory(id: '4', name: 'مصري', icon: Icons.restaurant, color: const Color(0xFF2ECC71)),
    FoodCategory(id: '5', name: 'صيني', icon: Icons.ramen_dining, color: const Color(0xFF9B59B6)),
    FoodCategory(id: '6', name: 'حلويات', icon: Icons.cake, color: const Color(0xFFE91E63)),
    FoodCategory(id: '7', name: 'بحري', icon: Icons.set_meal_outlined, color: const Color(0xFF3498DB)),
    FoodCategory(id: '8', name: 'صحي', icon: Icons.eco, color: const Color(0xFF27AE60)),
  ];

  final Map<String, List<Restaurant>> _restaurantsByCategory = {
    '1': [
      Restaurant(
        id: '1', name: 'برجر كينج', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.5, reviewsCount: 1250, deliveryTime: '30-45', deliveryFee: 15, originalDeliveryFee: 20, cuisine: 'وجبات سريعة أمريكية', discount: 'خصم 10%', isFavorite: false, isPromoted: true, tags: ['وجبات سريعة', 'برجر', 'أمريكي'], minimumOrder: 50),
      Restaurant(id: '2', name: 'ماكدونالدز', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.2, reviewsCount: 2100, deliveryTime: '25-40', deliveryFee: 12, cuisine: 'وجبات سريعة أمريكية', isFavorite: true, tags: ['وجبات سريعة', 'برجر', 'إفطار'], minimumOrder: 40),
      Restaurant(id: '3', name: 'كايرو برجر', image: 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?q=80&w=2070&auto=format&fit=crop&ixlib-rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D', rating: 4.7, reviewsCount: 890, deliveryTime: '35-50', deliveryFee: 0, originalDeliveryFee: 18, cuisine: 'برجر محلي', discount: 'توصيل مجاني', isFavorite: false, tags: ['محلي', 'برجر', 'مصري'], minimumOrder: 60),
    ],
  };

  List<Restaurant> get _filteredRestaurants {
    if (_selectedCategoryId.isNotEmpty) {
      return _restaurantsByCategory[_selectedCategoryId] ?? [];
    }
    return _restaurantsByCategory.values.expand((list) => list).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Title
            Text(
              'قسم الطعام',
              textAlign: TextAlign.start,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: theme.dividerColor,
                    width: 1,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.push(AppRoutes.searchPage);
                  },
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن مطاعم، مأكولات...',
                      hintStyle: TextStyle(
                        color: theme.hintColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.hintColor,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Categories Horizontal List
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'الأصناف',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];

                        return GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            setState(() {
                              _selectedCategoryId =
                                  _selectedCategoryId == category.id
                                      ? ''
                                      : category.id;
                            });
                          },
                          child: Container(
                            width: 85,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: _selectedCategoryId == category.id
                                    ? category.color
                                    : theme.dividerColor,
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: category.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    category.icon,
                                    size: 28,
                                    color: category.color,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.name,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Header for restaurants
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  Text(
                    _selectedCategoryId.isNotEmpty
                        ? 'مطاعم ${_categories.firstWhere((c) => c.id == _selectedCategoryId).name}'
                        : 'الأشهر بالقرب منك',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_filteredRestaurants.length} أماكن',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Restaurants List
            _filteredRestaurants.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.restaurant_menu_rounded, 
                            size: 80, 
                            color: theme.hintColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'لم يتم العثور على مطاعم',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.hintColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'حاول تعديل بحثك أو استكشف\nأصنافًا مختلفة.',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        _filteredRestaurants.length,
                        (index) => _buildEnhancedRestaurantCard(context, _filteredRestaurants[index]),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedRestaurantCard(BuildContext context, Restaurant restaurant) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.restaurant, color: Colors.white),
                    const SizedBox(width: 8),
                    Text('جاري فتح ${restaurant.name}...'),
                  ],
                ),
                backgroundColor: const Color(0xFF27AE60),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: SizedBox(
                        height: 180,
                        width: double.infinity,
                        child: Image.network(
                          restaurant.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: theme.cardColor,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_rounded, 
                                  size: 60, 
                                  color: theme.hintColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.1)],
                          ),
                        ),
                      ),
                    ),
                    if (restaurant.discount != null)
                      Positioned(
                        top: 16, left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFE63946), Color(0xFFFF4757)]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: const Color(0xFFE63946).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                          ),
                          child: Text(restaurant.discount!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    if (restaurant.isPromoted == true)
                      Positioned(
                        top: 16, right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFFFB800), borderRadius: BorderRadius.circular(12)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 12, color: Colors.white),
                              SizedBox(width: 2),
                              Text('مُميّز', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 16, right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.9), 
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          onPressed: () { HapticFeedback.lightImpact(); },
                          icon: Icon(
                            restaurant.isFavorite ? Icons.favorite : Icons.favorite_border, 
                            color: restaurant.isFavorite ? const Color(0xFFE63946) : theme.hintColor,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16, left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text('${restaurant.deliveryTime} دقيقة', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name, 
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ), 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFB800).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Color(0xFFFFB800)),
                                const SizedBox(width: 2),
                                Text(restaurant.rating.toString(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFFFB800))),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.cuisine, 
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                                fontWeight: FontWeight.w500,
                              ), 
                              maxLines: 1, 
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '(${restaurant.reviewsCount}+ تقييم)', 
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (restaurant.tags.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: restaurant.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: theme.primaryColor.withOpacity(0.2), width: 1),
                                ),
                                child: Text(
                                  tag, 
                                  style: TextStyle(
                                    color: theme.primaryColor, 
                                    fontSize: 11, 
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark 
                              ? theme.colorScheme.surfaceVariant.withOpacity(0.3)
                              : theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(color: const Color(0xFF27AE60).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(Icons.delivery_dining_rounded, size: 18, color: Color(0xFF27AE60)),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.deliveryFee == 0 ? 'توصيل مجاني' : '${restaurant.deliveryFee} جنيه',
                                        style: TextStyle(
                                          fontSize: 14, 
                                          fontWeight: FontWeight.bold, 
                                          color: restaurant.deliveryFee == 0 
                                              ? const Color(0xFF27AE60) 
                                              : theme.colorScheme.onSurface,
                                        ),
                                      ),
                                      if (restaurant.originalDeliveryFee != null && restaurant.originalDeliveryFee! > restaurant.deliveryFee)
                                        Text(
                                          '${restaurant.originalDeliveryFee} جنيه',
                                          style: TextStyle(
                                            fontSize: 11, 
                                            color: theme.hintColor, 
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30, 
                              width: 1, 
                              color: theme.dividerColor,
                              margin: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'الحد الأدنى', 
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.hintColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${restaurant.minimumOrder} جنيه', 
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Data Models
class FoodCategory {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  FoodCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

class Restaurant {
  final String id;
  final String name;
  final String image;
  final double rating;
  final int reviewsCount;
  final String deliveryTime;
  final int deliveryFee;
  final int? originalDeliveryFee;
  final String cuisine;
  final String? discount;
  final bool isFavorite;
  final bool isPromoted;
  final List<String> tags;
  final int minimumOrder;

  Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTime,
    required this.deliveryFee,
    this.originalDeliveryFee,
    required this.cuisine,
    this.discount,
    required this.isFavorite,
    this.isPromoted = false,
    required this.tags,
    required this.minimumOrder,
  });
}