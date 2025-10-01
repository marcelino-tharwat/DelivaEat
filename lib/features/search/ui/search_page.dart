import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/search/cubit/search_cubit.dart';
import 'package:deliva_eat/features/search/cubit/search_state.dart';
import 'package:go_router/go_router.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  late SearchCubit _searchCubit;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchCubit = getIt<SearchCubit>();
    _scrollController.addListener(_onScroll);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _searchFocusNode.addListener(() {
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final currentState = _searchCubit.state;
      if (currentState is SearchSuccess &&
          currentState.page < currentState.totalPages) {
        _searchCubit.loadMore(
          query: currentState.query,
          nextPage: currentState.page + 1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider<SearchCubit>.value(
      value: _searchCubit..getPopularSearches(),
      child: Scaffold(
        backgroundColor: isDark
            ? Colors.grey[900]
            : theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchHeader(context, theme, isDark),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  bloc: _searchCubit,
                  builder: (context, state) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: _buildSearchContent(context, state),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.fromLTRB(
        16.w,
        8.h,
        16.w,
        _isSearchFocused ? 8.h : 16.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: _isSearchFocused
            ? [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios, size: 20.sp),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                  padding: EdgeInsets.all(8.r),
                ),
              ),
              SizedBox(width: 12.w),
              if (!_isSearchFocused) ...[
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _isSearchFocused ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      AppLocalizations.of(context)!.searchTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          _buildSearchBar(context, theme, isDark),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16.sp),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchRestaurantsFoodsHint,
          hintStyle: TextStyle(color: theme.hintColor, fontSize: 14.sp),
          prefixIcon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.search,
              color: _isSearchFocused ? theme.primaryColor : theme.hintColor,
              size: 24.sp,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? AnimatedScale(
                  scale: 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: theme.hintColor,
                      size: 20.sp,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _searchCubit.clearSearch();
                      setState(() {});
                    },
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(color: theme.primaryColor, width: 2.w),
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[800] : Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 16.h,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isNotEmpty && value.length >= 2) {
            _searchCubit.searchRealTime(query: value);
            _searchCubit.getSuggestionsRealTime(query: value);
          } else if (value.isEmpty) {
            _searchCubit.clearSearch();
          }
        },
        onSubmitted: (value) {
          if (value.isNotEmpty && value.length >= 2) {
            _searchCubit.search(query: value);
            _searchFocusNode.unfocus();
          }
        },
      ),
    );
  }

  Widget _buildSearchContent(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return _buildLoadingState();
    }
    if (state is SearchError) {
      return _buildErrorState(state.message);
    }
    if (state is SearchSuccess) {
      return _buildSearchResults(context, state);
    }
    if (state is SearchSuggestionsSuccess &&
        _searchController.text.isNotEmpty) {
      return _buildSuggestions(context, state);
    }
    if (state is PopularSearchesSuccess) {
      return _buildPopularSearches(context, state);
    }
    return _buildEmptyState();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.w,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            AppLocalizations.of(context)!.searching,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16.sp,
              color: Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 48.sp,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              AppLocalizations.of(context)!.errorOccurred,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
            SizedBox(height: 24.h),
            FilledButton.icon(
              onPressed: () {
                if (_searchController.text.isNotEmpty) {
                  _searchCubit.search(query: _searchController.text);
                }
              },
              icon: Icon(Icons.refresh, size: 18.sp),
              label: Text(AppLocalizations.of(context)!.retry),
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, SearchSuccess state) {
    return RefreshIndicator(
      onRefresh: () async {
        await _searchCubit.search(query: state.query);
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // عرض المطاعم مع منتجاتها
              if (state.restaurants.isNotEmpty) ...[
                _buildSectionHeader(AppLocalizations.of(context)!.restaurants, state.restaurants.length),
                SizedBox(height: 16.h),
                ...state.restaurants.map(
                  (restaurant) =>
                      _buildRestaurantWithProducts(restaurant, state.foods),
                ),
                SizedBox(height: 24.h),
              ],

              // عرض المنتجات المنفصلة (التي لا تنتمي لمطاعم في النتائج)
              if (_getIndependentFoods(
                state.foods,
                state.restaurants,
              ).isNotEmpty) ...[
                _buildSectionHeader(
                  AppLocalizations.of(context)!.otherProducts,
                  _getIndependentFoods(state.foods, state.restaurants).length,
                ),
                SizedBox(height: 16.h),
                _buildFoodHorizontalList(
                  _getIndependentFoods(state.foods, state.restaurants),
                ),
                SizedBox(height: 24.h),
              ],

              if (state.restaurants.isEmpty && state.foods.isEmpty)
                _buildEmptySearchResult(state.query),

              if (state.page < state.totalPages)
                Container(
                  padding: EdgeInsets.all(24.w),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
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

  Widget _buildRestaurantWithProducts(
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
        _buildRestaurantCard(restaurant),

        // منتجات المطعم إذا وُجدت
        if (restaurantFoods.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              AppLocalizations.of(context)!.restaurantProducts(restaurant.nameAr),
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

  Widget _buildRestaurantCard(RestaurantModel restaurant) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isArabic ? restaurant.nameAr : restaurant.name;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to restaurant details
          },
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Hero(
                  tag: 'restaurant-${restaurant.id}',
                  child: Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8.r,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.network(
                        restaurant.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary.withOpacity(0.3),
                                colors.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text('🏪', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: textStyles.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16.sp),
                          SizedBox(width: 4.w),
                          Text(
                            restaurant.rating!.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.access_time,
                            color: Colors.grey[600],
                            size: 16.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              restaurant.deliveryTime ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          "رسوم التوصيل: ${restaurant.deliveryFee} ريال",
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ),
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
          return _buildFoodCard(foods[index], index);
        },
      ),
    );
  }

  Widget _buildFoodCard(FoodModel food, int index) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isArabic ? food.nameAr : food.name;
    final hasDiscount =
        food.originalPrice != null && food.originalPrice! > food.price!.toInt();

    return Container(
      width: 150.w,
      margin: EdgeInsets.only(left: 12.w),
      child: Card(
        elevation: 6,
        shadowColor: colors.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () {
            // Navigate to food details
          },
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'food-item-${food.id}-$index',
                      child: Image.network(
                        food.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                colors.primary.withOpacity(0.3),
                                colors.primary.withOpacity(0.1),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Text('🍕', style: TextStyle(fontSize: 30)),
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "خصم",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        displayName,
                        style: textStyles.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                          color: colors.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${food.price} ريال",
                                style: TextStyle(
                                  color: colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                ),
                              ),
                              if (hasDiscount)
                                Text(
                                  "${food.originalPrice} ريال",
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 10.sp,
                                  ),
                                ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 12.sp,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  food.rating!.toStringAsFixed(1),
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptySearchResult(String query) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off,
                size: 64.sp,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'لا توجد نتائج للبحث',
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
                  const TextSpan(text: 'لم نجد أي نتائج لـ '),
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
              "جرب كلمات مختلفة أو تحقق من الإملاء",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions(
    BuildContext context,
    SearchSuggestionsSuccess state,
  ) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: state.suggestions.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1.h, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final suggestion = state.suggestions[index];
        return ListTile(
          leading: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              suggestion.type == "restaurant"
                  ? Icons.restaurant
                  : Icons.fastfood,
              color: Theme.of(context).primaryColor,
              size: 20.sp,
            ),
          ),
          title: Text(
            suggestion.name,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
          ),
          subtitle: suggestion.restaurant != null
              ? Text(
                  "من: ${suggestion.restaurant}",
                  style: TextStyle(fontSize: 14.sp),
                )
              : null,
          trailing: Icon(
            Icons.north_west,
            color: Colors.grey[400],
            size: 16.sp,
          ),
          onTap: () {
            _searchController.text = suggestion.name;
            _searchCubit.search(query: suggestion.name);
          },
        );
      },
    );
  }

  Widget _buildPopularSearches(
    BuildContext context,
    PopularSearchesSuccess state,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 4.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  "البحث الشائع",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: state.popularSearches
                  .map(
                    (search) => InkWell(
                      onTap: () {
                        _searchController.text = search.term;
                        _searchCubit.search(query: search.term);
                      },
                      borderRadius: BorderRadius.circular(20.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 16.sp,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              search.term,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search,
                size: 80.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              "ابدأ البحث",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "ابحث عن مطاعمك المفضلة وأطعمتك المفضلة",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
