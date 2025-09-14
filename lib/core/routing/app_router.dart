import 'package:deliva_eat/core/routing/routes.dart';
import 'package:deliva_eat/features/auth/login/ui/login_page.dart';
import 'package:deliva_eat/features/auth/signup/ui/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return  LoginPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: AppRoutes.signupPage,
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpPage();
          },
        ),
      ],
    ),
  ],
);