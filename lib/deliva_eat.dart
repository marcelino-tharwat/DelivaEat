import 'package:deliva_eat/core/routing/app_router.dart';
import 'package:deliva_eat/core/theme/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'generated/l10n.dart';

class DelivaEat extends StatelessWidget {
  const DelivaEat({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return ScreenUtilInit(
      designSize: const Size(412 , 1000 ),
            minTextAdapt: true,
            child: MaterialApp.router(
              routerConfig: router,
              debugShowCheckedModeBanner: false,
              // Theme Configuration
              theme: themeProvider.lightTheme,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.isDarkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

              // Localization Configuration
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              locale: localeProvider.locale,
            ),
          );
        },
      ),
    );
  }
}
