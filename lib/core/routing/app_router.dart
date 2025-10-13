import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/forget_password_page.dart';
import 'package:deliva_eat/features/auth/new_password/cubit/new_password_cubit.dart';
import 'package:deliva_eat/features/auth/new_password/ui/new_password_page.dart';
import 'package:deliva_eat/features/auth/otp/cubit/otp_cubit.dart';
import 'package:deliva_eat/features/auth/otp/ui/otp_page.dart';
import 'package:deliva_eat/features/auth/signup/ui/signup_page.dart';
import 'package:deliva_eat/features/auth/signup/cubit/signup_cubit.dart';
import 'package:deliva_eat/features/category/ui/widget/food_category_page.dart';
import 'package:deliva_eat/features/category/ui/widget/pharmacies_category_page.dart';
import 'package:deliva_eat/features/category/ui/widget/grocery_category_page.dart';
import 'package:deliva_eat/features/category/ui/widget/markets_category_page.dart';
import 'package:deliva_eat/features/home/data/models/food_model.dart';
import 'package:deliva_eat/features/home/data/models/restaurant_model.dart';
import 'package:deliva_eat/features/home/ui/favorites_page.dart';
import 'package:deliva_eat/features/home/ui/home_page_wrapper.dart';
import 'package:deliva_eat/features/restaurant/ui/prodcut_page.dart';
import 'package:deliva_eat/features/restaurant/ui/restaurant_menu_page.dart';
import 'package:deliva_eat/features/restaurant/ui/restaurant_page.dart';
import 'package:deliva_eat/features/reviews/ui/reviews_page.dart';
import 'package:deliva_eat/features/reviews/cubit/reviews_cubit.dart';
import 'package:deliva_eat/features/search/ui/search_page.dart';
import 'package:deliva_eat/setting.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/features/restaurant/cubit/restaurant_cubit.dart';
import 'package:deliva_eat/features/restaurant/cubit/restaurant_state.dart';
import 'package:deliva_eat/features/restaurant/data/repos/restaurant_repo.dart';
import 'package:deliva_eat/features/restaurant/cubit/product_cubit.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomePageWrapper();
        //  BlocProvider(
        //   create: (context) => getIt<LoginCubit>(),
        //   child: LoginPage(),
        // );
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.signupPage,
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => getIt<SignupCubit>(),
              child: const SignUpPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.forgetPasswordPage,
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(
              create: (_) => getIt<ForgotPasswordCubit>(),
              child: const ForgotPasswordPage(),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.otpPage,
          builder: (BuildContext context, GoRouterState state) {
            final String email = state.extra as String;

            return BlocProvider(
              create: (_) => getIt<OtpCubit>(),
              child: OtpPage(email: email),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.newPasswordPage,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> data =
                state.extra as Map<String, dynamic>;

            final String email = data['email'] as String;
            final String code = data['otp'] as String;

            return BlocProvider(
              create: (context) => getIt<NewPasswordCubit>(),
              child: NewPasswordPage(email: email, token: code),
            );
          },
        ),
        GoRoute(
          // المسار يبقى كما هو
          path: AppRoutes.categoryPage, // مثال: '/category'
          // نستخدم builder لاستدعاء الصفحة الصحيحة وهي FoodCategoriesPage
          builder: (BuildContext context, GoRouterState state) {
            // 1. استخراج البيانات (extra) بنفس الطريقة
            // إذا لم يتم تمرير أي بيانات، استخدم خريطة فارغة لتجنب الأخطاء
            final data = state.extra as Map<String, dynamic>? ?? {};

            // هذا المعرف سيتم تمريره للصفحة لكي تعرف أي فئة يجب تحديدها مسبقاً
            final String categoryId = data['id'] as String? ?? '';

            return FoodCategoriesPage(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: AppRoutes.pharmaciesPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            final String categoryId = data['id'] as String? ?? '';
            return PharmaciesCategoriesPage(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: AppRoutes.groceryPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            final String categoryId = data['id'] as String? ?? '';
            return GroceryCategoriesPage(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: AppRoutes.marketsCategoryPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            final String categoryId = data['categoryId'] as String? ?? '';
            return MarketsCategoriesPage(categoryId: categoryId);
          },
        ),
        GoRoute(
          path: AppRoutes.searchPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>?;
            final String? categoryId = data != null
                ? data['categoryId'] as String?
                : null;
            final String? type = data != null ? data['type'] as String? : null;
            final String? categoryType = data != null
                ? data['categoryType'] as String?
                : null;
            return SearchPage(
              categoryId: categoryId,
              type: type,
              categoryType: categoryType,
            );
          },
        ),
        GoRoute(
          // ✅ استخدام الاسم الفريد من AppRoutes
          name: AppRoutes.restaurantMenuPage,

          // ✅ تعريف المسار الكامل ]
          path: '/restaurant-menu/:restaurantId',

          builder: (BuildContext context, GoRouterState state) {
            final String restaurantId =
                state.pathParameters['restaurantId'] ?? '';
            final String restaurantName = state.extra as String? ?? 'القائمة';

            return RestaurantMenuPage(
              restaurantId: restaurantId,
              restaurantName: restaurantName,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.favoritesPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>? ?? {};
            final favoriteRestaurants =
                (data['favoriteRestaurants'] as List<dynamic>?)
                    ?.cast<RestaurantModel>() ??
                [];
            final favoriteFoods =
                (data['favoriteFoods'] as List<dynamic>?)?.cast<FoodModel>() ??
                [];
            return FavoritesPage(
              favoriteRestaurants: favoriteRestaurants,
              favoriteFoods: favoriteFoods,
            );
          },
        ),
        GoRoute(
          path: AppRoutes.restaurantPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = state.extra as Map<String, dynamic>?;
            final String restaurantId = (data?['restaurantId'] ?? '')
                .toString();
            final String restaurantName = (data?['restaurantName'] ?? '')
                .toString();
            return BlocProvider(
              create: (_) => RestaurantCubit(
                repo: getIt<RestaurantRepo>(),
                restaurantId: restaurantId,
              )..loadDetails(),
              child: RestaurantHomePage(
                restaurantId: restaurantId,
                restaurantName: restaurantName.isEmpty
                    ? 'المطعم'
                    : restaurantName,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.productDetailsPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = (state.extra as Map<String, dynamic>?) ?? {};
            return BlocProvider<ProductCubit>(
              create: (_) => getIt<ProductCubit>(),
              child: FoodOrderPage(
                foodId: (data['foodId'] ?? '').toString(),
                title: (data['title'] ?? '').toString(),
                image: (data['image'] ?? '').toString(),
                priceText: (data['price'] ?? '').toString(),
                isFavorite: data['isFavorite'] == true,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.reviewsPage,
          builder: (BuildContext context, GoRouterState state) {
            final data = (state.extra as Map<String, dynamic>?) ?? {};
            final String? foodId = (data['foodId']?.toString().isNotEmpty == true)
                ? data['foodId'].toString()
                : null;
            final String? restaurantId = (data['restaurantId']?.toString().isNotEmpty == true)
                ? data['restaurantId'].toString()
                : null;
            return BlocProvider(
              create: (_) => getIt<ReviewsCubit>()
                ..setContext(foodId: foodId, restaurantId: restaurantId)
                ..fetchReviews(page: 1),
              child: const RatingReviewsPage(),
            );
          },
        ),
      ],
    ),
  ],
);
