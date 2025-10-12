import 'package:deliva_eat/core/routing/app_router.dart';

import 'package:deliva_eat/core/theme/light_dark_mode.dart';
import 'package:deliva_eat/core/theme/provider.dart';
import 'package:deliva_eat/core/widgets/mobile_only_layout.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:deliva_eat/core/di/dependency_injection.dart';
import 'package:deliva_eat/features/home/cubit/home_cubit.dart';

class DelivaEat extends StatelessWidget {
  const DelivaEat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        BlocProvider<HomeCubit>(create: (context) => getIt<HomeCubit>()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(412, 1000),
            minTextAdapt: true,
            child: MobileOnlyLayout(
              child: MaterialApp.router(
                routerConfig: router, // تأكد من أن متغير router معرّف لديك
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme, // استخدام الثيم المضيء المفصّل
                darkTheme: AppTheme.darkTheme, // استخدام الثيم المظلم المفصّل
                themeMode: themeProvider.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,

                // Localization Configuration
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                locale: localeProvider.locale,
              ),
            ),
          );
        },
      ),
    );
  }
}
