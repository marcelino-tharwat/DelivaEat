import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/widgets/skeleton_loader.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:deliva_eat/features/search/ui/widgets/section_header.dart';
import 'package:deliva_eat/features/search/ui/widgets/restaurant_card.dart';
import 'package:deliva_eat/features/search/ui/widgets/food_card.dart';

class SearchResults extends StatelessWidget {
  final SearchSuccess state;
  final Function() onRefresh;
  final String? categoryType;

  const SearchResults({
    super.key,
    required this.state,
    required this.onRefresh,
    this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض المطاعم مع منتجاتها
              if (state.restaurants.isNotEmpty) ...[
                SectionHeader(
                  title: categoryType == 'pharmacies'
                      ? AppLocalizations.of(context)!.pharmacies
                      : AppLocalizations.of(context)!.restaurants,
                  count: state.restaurants.length,
                ),
                SizedBox(height: 16.h),
                ...state.restaurants.map(
                  (restaurant) => _buildRestaurantWithProducts(
                    context, // <<< CHANGED: Pass context here
                    restaurant,
                    state.foods,
                  ),
                ),
                SizedBox(height: 24.h),
              ],

              // عرض المنتجات المنفصلة (التي لا تنتمي لمطاعم في النتائج)
              if (_getIndependentFoods(
                state.foods,
                state.restaurants,
              ).isNotEmpty) ...[
                SectionHeader(
                  title: AppLocalizations.of(context)!.otherProducts,
                  count: _getIndependentFoods(
                    state.foods,
                    state.restaurants,
                  ).length,
                ),
                SizedBox(height: 16.h),
                _buildFoodHorizontalList(
                  _getIndependentFoods(state.foods, state.restaurants),
                ),
                SizedBox(height: 24.h),
              ],

              if (state.restaurants.isEmpty && state.foods.isEmpty)
                _buildEmptySearchResult(
                  context,
                  state.query,
                ), // <<< CHANGED: Pass context here

              if (state.page < state.totalPages)
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: const SkeletonLoader(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<FoodModel> _getIndependentFoods(
    List<FoodModel> allFoods,
    List<RestaurantModel> restaurants,
  ) {
    final restaurantIds = restaurants.map((r) => r.id).toSet();
    return allFoods
        .where(
          (food) =>
              food.restaurant == null ||
              !restaurantIds.contains(food.restaurant!.id),
        )
        .toList();
  }

  // <<< CHANGED: Accept BuildContext as a parameter
  Widget _buildRestaurantWithProducts(
    BuildContext context,
    RestaurantModel restaurant,
    List<FoodModel> allFoods,
  ) {
    final restaurantFoods = allFoods
        .where((food) => food.restaurant?.id == restaurant.id)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // بطاقة المطعم
        RestaurantCard(restaurant: restaurant),

        // منتجات المطعم إذا وُجدت
        if (restaurantFoods.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              AppLocalizations.of(
                context,
              )!.restaurantProducts(restaurant.nameAr),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          _buildFoodHorizontalList(restaurantFoods),
        ],
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildFoodHorizontalList(List<FoodModel> foods) {
    return SizedBox(
      height: 180.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: foods.length,
        itemBuilder: (context, index) {
          return FoodCard(food: foods[index], index: index);
        },
      ),
    );
  }

  // <<< CHANGED: Accept BuildContext as a parameter
  Widget _buildEmptySearchResult(BuildContext context, String query) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64.sp,
                color: Theme.of(context).hintColor,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.noSearchResults,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
                ),
                children: [
                  TextSpan(text: AppLocalizations.of(context)!.noResultsFor),
                  TextSpan(
                    text: '"$query"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.tryDifferentWords,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
