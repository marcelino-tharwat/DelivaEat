import 'package:deliva_eat/core/theme/app_colors.dart';
import 'package:deliva_eat/core/widgets/app_button.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';
import 'package:deliva_eat/features/home/cubit/home_state.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:dio/dio.dart';
import 'package:deliva_eat/core/network/dio_factory.dart';
import 'package:deliva_eat/core/network/api_constant.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FoodOrderPage extends StatefulWidget {
  final String foodId;
  final String title;
  final String image;
  final String priceText;
  final bool isFavorite;

  const FoodOrderPage({
    super.key,
    this.foodId = '',
    this.title = '',
    this.image = '',
    this.priceText = '',
    this.isFavorite = false,
  });

  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  // ValueNotifiers for reactive state management
  late final ValueNotifier<bool> _extraChickenNotifier;
  late final ValueNotifier<bool> _colaNotifier;
  late final ValueNotifier<bool> _isFavoriteNotifier;
  late final ValueNotifier<bool> _isAddingToCartNotifier;

  late final int basePrice;
  static const int extraChickenPrice = 10;
  static const int colaPrice = 15;

  // Cache localization
  late bool _isArabic;

  @override
  void initState() {
    super.initState();

    // Initialize ValueNotifiers
    _extraChickenNotifier = ValueNotifier<bool>(false);
    _colaNotifier = ValueNotifier<bool>(false);
    _isFavoriteNotifier = ValueNotifier<bool>(widget.isFavorite);
    _isAddingToCartNotifier = ValueNotifier<bool>(false);

    // Parse base price once
    basePrice = _parseBasePrice(widget.priceText);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isArabic = Localizations.localeOf(context).languageCode == 'ar';
  }

  @override
  void dispose() {
    // Dispose all ValueNotifiers
    _extraChickenNotifier.dispose();
    _colaNotifier.dispose();
    _isFavoriteNotifier.dispose();
    _isAddingToCartNotifier.dispose();
    super.dispose();
  }

  int _parseBasePrice(String priceText) {
    final digits = RegExp(r"[0-9]+(\.[0-9]+)?").firstMatch(priceText);
    if (digits != null) {
      final p = double.tryParse(digits.group(0) ?? '');
      if (p != null) return p.round();
    }
    return 30; // Default
  }

  int _calculateTotalPrice() {
    int total = basePrice;
    if (_extraChickenNotifier.value) total += extraChickenPrice;
    if (_colaNotifier.value) total += colaPrice;
    return total;
  }

  Future<void> _addToCart() async {
    if (_isAddingToCartNotifier.value) return;

    _isAddingToCartNotifier.value = true;

    final lang = Localizations.localeOf(context).languageCode;
    final dio = DioFactory.getDio();

    final options = <Map<String, dynamic>>[];
    if (_extraChickenNotifier.value) {
      options.add({'code': 'extra_chicken', 'price': extraChickenPrice});
    }
    if (_colaNotifier.value) {
      options.add({'code': 'cola', 'price': colaPrice});
    }

    final payload = {
      'foodId': widget.foodId,
      'quantity': 1,
      'options': options,
    };

    try {
      final res = await dio.post(
        ApiConstant.cartAddItemUrl,
        data: payload,
        queryParameters: {'lang': lang},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (!mounted) return;

      final ok = res.data is Map && (res.data['success'] == true);
      if (ok) {
        final msg = _isArabic ? 'تمت الإضافة إلى السلة' : 'Added to cart';
        _showSnackBar(msg);
      } else {
        String err = 'failed add to cart';
        if (res.data is Map && res.data['error'] is Map) {
          err = (res.data['error']['message'] ?? err).toString();
        }
        throw Exception(err);
      }
    } catch (e) {
      if (!mounted) return;
      final msg = _isArabic ? 'فشل الإضافة إلى السلة' : 'Failed to add to cart';
      _showSnackBar(msg);
    } finally {
      if (mounted) {
        _isAddingToCartNotifier.value = false;
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _toggleFavorite() async {
    final newVal = !_isFavoriteNotifier.value;
    _isFavoriteNotifier.value = newVal;

    final lang = Localizations.localeOf(context).languageCode;
    bool ok = false;

    try {
      final base = FoodModel(
        id: widget.foodId,
        name: widget.title,
        nameAr: widget.title,
        description: null,
        descriptionAr: null,
        image: widget.image,
        price: basePrice.toDouble(),
        originalPrice: null,
        rating: null,
        reviewCount: null,
        preparationTime: null,
        isAvailable: true,
        isPopular: false,
        isBestSelling: false,
        isFavorite: newVal,
        restaurant: null,
        ingredients: null,
        allergens: null,
        tags: null,
      );

      await context.read<HomeCubit>().toggleFoodFavorite(
        foodId: widget.foodId,
        lang: lang,
        baseOverride: base,
      );
      ok = true;
    } catch (_) {
      // Silently fail
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    final message = _isFavoriteNotifier.value
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
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // الصورة في الخلفية
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CachedNetworkImage(
              imageUrl: widget.image.isNotEmpty
                  ? widget.image
                  : 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=800',
              width: double.infinity,
              height: 280.h,
              fit: BoxFit.cover,
              memCacheWidth: 800, // Correct: controls memory cache size
              // maxWidthDiskCache: 800, // Incorrect: This parameter does not exist. Remove it.
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: 280.h,
                color: colorScheme.surfaceVariant,
                // Using a simpler placeholder can feel faster than a spinner
                // child: const Center(child: CircularProgressIndicator()),
              ),

              // Corrected parameter name from errorBuilder to errorWidget
              errorWidget: (context, url, error) {
                // You can log the error here if you want
                // print(error);
                return Container(
                  width: double.infinity,
                  height: 280.h,
                  color: colorScheme.surfaceVariant,
                  child: const Center(child: Icon(Icons.broken_image)),
                );
              },
            ),
          ),

          // المحتوى القابل للسحب
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 260.h), // مساحة فارغة للتداخل
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24.r),
                        topRight: Radius.circular(24.r),
                      ),
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline,
                          width: 1.5.w,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // العنوان والسعر (reactive with ValueNotifier)
                          ValueListenableBuilder<bool>(
                            valueListenable: _extraChickenNotifier,
                            builder: (context, extraChicken, child) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: _colaNotifier,
                                builder: (context, cola, child) {
                                  final totalPrice = _calculateTotalPrice();
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 250.w,
                                        child: Text(
                                          (widget.title.isNotEmpty
                                              ? widget.title
                                              : AppLocalizations.of(
                                                  context,
                                                )!.foodChickenSchezwanFriedRice),
                                          style: theme.textTheme.headlineSmall
                                              ?.copyWith(
                                                height: 1.3,
                                                color: colorScheme.onSurface,
                                              ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(
                                            0.9,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: Text(
                                          'EGP $totalPrice',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            AppLocalizations.of(
                              context,
                            )!.foodChickenSchezwanFriedRiceDesc,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
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
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(1,205)',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  context.push(
                                    AppRoutes.reviewsPage,
                                    extra: {
                                      'foodId': widget.foodId,
                                      'title': widget.title,
                                    },
                                  );
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.seeAllReviews,
                                  style: TextStyle(
                                    color: colorScheme.onSurface,
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
                          ValueListenableBuilder<bool>(
                            valueListenable: _extraChickenNotifier,
                            builder: (context, isSelected, child) {
                              return _buildOptionCard(
                                context: context,
                                image:
                                    'https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=400',
                                title: AppLocalizations.of(
                                  context,
                                )!.addExtraChicken('10'),
                                isSelected: isSelected,
                                onChanged: (bool? value) {
                                  _extraChickenNotifier.value = value ?? false;
                                },
                              );
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
                          ValueListenableBuilder<bool>(
                            valueListenable: _colaNotifier,
                            builder: (context, isSelected, child) {
                              return _buildOptionCard(
                                context: context,
                                image:
                                    'https://images.unsplash.com/photo-1554866585-cd94860890b7?w=400',
                                title: AppLocalizations.of(
                                  context,
                                )!.addCocaCola('15'),
                                isSelected: isSelected,
                                onChanged: (bool? value) {
                                  _colaNotifier.value = value ?? false;
                                },
                              );
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

          // زر Add to cart في الأسفل (reactive)
          Positioned(
            bottom: 10.h,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _extraChickenNotifier,
              builder: (context, extraChicken, child) {
                return ValueListenableBuilder<bool>(
                  valueListenable: _colaNotifier,
                  builder: (context, cola, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _isAddingToCartNotifier,
                      builder: (context, isAdding, child) {
                        final totalPrice = _calculateTotalPrice();
                        return Container(
                          color: colorScheme.surface,
                          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
                          child: AppButton(
                            onPressed: isAdding ? null : _addToCart,
                            text: AppLocalizations.of(
                              context,
                            )!.addToCart(totalPrice.toString()),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // أزرار الرجوع والمفضلة في الأعلى (فوق كل شيء)
          Positioned(
            top: 50.h,
            left: 16.w,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.onSurface,
                    width: 1.5.w,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 20.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ),
          Positioned(
            top: 50.h,
            right: 16.w,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isFavoriteNotifier,
              builder: (context, isFavorite, child) {
                return Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: isFavorite ? const Color(0xFFFF6B6B) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4.r,
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: _toggleFavorite,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 26.sp,
                      color: isFavorite
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required BuildContext context,
    required String image,
    required String title,
    required bool isSelected,
    required ValueChanged<bool?> onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => onChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.2),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: image,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                memCacheWidth: 100,
                maxWidthDiskCache: 100,
                placeholder: (context, url) => Container(
                  width: 50,
                  height: 50,
                  color: colorScheme.surfaceVariant,
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 50,
                  height: 50,
                  color: colorScheme.surfaceVariant,
                  child: const Icon(Icons.broken_image, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: colorScheme.primary,
              mouseCursor: SystemMouseCursors.click,
            ),
          ],
        ),
      ),
    );
  }
}
