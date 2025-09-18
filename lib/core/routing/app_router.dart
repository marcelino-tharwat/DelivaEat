import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/forget_password/cubit/forgot_password_cubit.dart';
import 'package:deliva_eat/features/auth/forget_password/ui/forget_password_page.dart';
import 'package:deliva_eat/features/auth/login/cubit/login_cubit.dart';
import 'package:deliva_eat/features/auth/login/ui/login_page.dart';
import 'package:deliva_eat/features/auth/signup/ui/signup_page.dart';
import 'package:deliva_eat/features/auth/signup/cubit/signup_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return BlocProvider(
          create: (context) => getIt<LoginCubit>(),
          child: LoginPage(),
        );
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
            return
            BlocProvider(
              create: (_) => getIt<ForgotPasswordCubit>(),
              child:
            const ForgotPasswordPage()
            );
          },
        ),
      ],
    ),
  ],
);
