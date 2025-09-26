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
import 'package:deliva_eat/features/category/ui/category_page.dart';
import 'package:deliva_eat/features/home/ui/home_page_wrapper.dart';
import 'package:deliva_eat/features/search/ui/search_page.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          path: AppRoutes.categoryPage,
          builder: (BuildContext context, GoRouterState state) {
            final String title = state.extra as String;
            return CategoriesPage(title: title);
          },
        ),
        GoRoute(
          path: AppRoutes.searchPage,
          builder: (BuildContext context, GoRouterState state) {
            return const SearchPage();
          },
        ),
      ],
    ),
  ],
);
