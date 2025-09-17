import 'package:deliva_eat/core/routing/app_router.dart';
import 'package:deliva_eat/core/theme/provider.dart';
import 'package:deliva_eat/core/widgets/mobile_only_layout.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
            designSize: const Size(412, 1000),
            minTextAdapt: true,
            child: MobileOnlyLayout(
              child: MaterialApp.router(
                routerConfig: router,
                debugShowCheckedModeBanner: false,
                // Theme Configuration
                theme: themeProvider.lightTheme,
                darkTheme: themeProvider.darkTheme,
                themeMode: themeProvider.isDarkMode
                    ? ThemeMode.dark
                    : ThemeMode.light,

                // --- التغييرات هنا ---
                // 2. استخدام المندوبين من الكلاس الجديد
                localizationsDelegates: AppLocalizations.localizationsDelegates,

                // 3. استخدام اللغات المدعومة من الكلاس الجديد
                supportedLocales: AppLocalizations.supportedLocales,

                // 4. هذا السطر صحيح ويجعل Provider يتحكم في اللغة
                locale: localeProvider.locale,
              ),
            ),
          );
        },
      ),
    );
  }
}
