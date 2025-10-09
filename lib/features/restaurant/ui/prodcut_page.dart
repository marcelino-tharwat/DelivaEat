import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  bool extraChickenSelected = false;
  bool colaSelected = false;

  int basePrice = 30;
  int extraChickenPrice = 10;
  int colaPrice = 15;

  int get totalPrice {
    int total = basePrice;
    if (extraChickenSelected) total += extraChickenPrice;
    if (colaSelected) total += colaPrice;
    return total;
  }

  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });

    // إزالة أي رسالة سابقة لمنع تراكمها
    ScaffoldMessenger.of(context).clearSnackBars();

    // إظهار رسالة جديدة لتأكيد الإجراء
    final message = _isFavorite
        ? AppLocalizations.of(context)!.addedToFavorites
        : AppLocalizations.of(context)!.removedFromFavorites;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final safeAreaTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // الصورة في الخلفية
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800',
              width: double.infinity,
              height: 280.h,
              fit: BoxFit.cover,
            ),
          ),

          // المحتوى القابل للسحب
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 250.h), // مساحة فارغة للتداخل
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.light
                          ? Colors.white
                          : Colors.grey[900],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: theme.brightness == Brightness.light
                              ? Colors.grey.shade300
                              : Colors.grey.shade700,
                          width: 1.5.w,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ... باقي المحتوى هنا ...
                          // العنوان والسعر
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250.w,
                                child: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.foodChickenSchezwanFriedRice,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        height: 1.3,
                                        color:
                                            theme.brightness == Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.primaryColor.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'EGP $basePrice',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: theme.brightness == Brightness.light
                                        ? Colors.black87
                                        : Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.foodChickenSchezwanFriedRiceDesc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.brightness == Brightness.light
                                  ? Colors.grey
                                  : Colors.grey[400],
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: theme.primaryColor,
                                size: 20.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '4.9',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(1,205)',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.brightness == Brightness.light
                                      ? Colors.grey
                                      : Colors.grey[400],
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.seeAllReviews,
                                  style: TextStyle(
                                    color: theme.brightness == Brightness.light
                                        ? Colors.black87
                                        : Colors.white70,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            AppLocalizations.of(context)!.extras,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          _buildOptionCard(
                            context: context,
                            image:
                                'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400',
                            title: AppLocalizations.of(
                              context,
                            )!.addExtraChicken('10'),
                            isSelected: extraChickenSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                extraChickenSelected = value ?? false;
                              });
                            },
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            AppLocalizations.of(context)!.addons,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          _buildOptionCard(
                            context: context,
                            image:
                                'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
                            title: AppLocalizations.of(
                              context,
                            )!.addCocaCola('15'),
                            isSelected: colaSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                colaSelected = value ?? false;
                              });
                            },
                          ),
                          SizedBox(height: 100.h), // مساحة إضافية للزر العائم
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // زر Add to cart في الأسفل
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
              child: AppButton(
                onPressed: () {},
                text: AppLocalizations.of(
                  context,
                )!.addToCart(totalPrice.toString()),
              ),
            ),
          ),

          // أزرار الرجوع والمفضلة في الأعلى (فوق كل شيء)
          Positioned(
            top:
                safeAreaTop +
                10.h, // استخدام safeArea لضمان عدم التداخل مع شريط الحالة
            left: 16.w,
            child: InkWell(
              onTap: () =>
                  Navigator.of(context).pop(), // <-- هنا تشغيل زر الرجوع
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: safeAreaTop + 10.h, // استخدام safeArea
            right: 16.w,
            child: InkWell(
              onTap: _toggleFavorite, // <-- هنا تشغيل زر المفضلة
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... دالة _buildOptionCard كما هي ...
  Widget _buildOptionCard({
    required BuildContext context,
    required String image,
    required String title,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: Theme.of(context).primaryColor,
              mouseCursor: SystemMouseCursors.click,
            ),
          ],
        ),
      ),
    );
  }
}
