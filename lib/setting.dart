import 'package:deliva_eat/generated/l10n.dart';
import 'package:deliva_eat/core/theme/provider.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n =  AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      // body:
      //  ListView(
      //   padding: const EdgeInsets.all(16.0),
      //   children: [
      //     // Theme Section
      //     Card(
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               l10n.theme,
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             const SizedBox(height: 16),
      //             Consumer<ThemeProvider>(
      //               builder: (context, themeProvider, child) {
      //                 return SwitchListTile(
      //                   title: Text(l10n.darkMode),
      //                   subtitle: Text(
      //                     themeProvider.isDarkMode
      //                         ? l10n.darkMode
      //                         : l10n.lightMode,
      //                   ),
      //                   value: themeProvider.isDarkMode,
      //                   onChanged: (value) {
      //                     themeProvider.toggleTheme();
      //                   },
      //                   secondary: Icon(
      //                     themeProvider.isDarkMode
      //                         ? Icons.dark_mode
      //                         : Icons.light_mode,
      //                   ),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),

      //     const SizedBox(height: 16),

      //     // Language Section
      //     Card(
      //       child: Padding(
      //         padding: const EdgeInsets.all(16.0),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               l10n.language,
      //               style: Theme.of(context).textTheme.titleLarge,
      //             ),
      //             const SizedBox(height: 16),
      //             Consumer<LocaleProvider>(
      //               builder: (context, localeProvider, child) {
      //                 return Column(
      //                   children: [
      //                     RadioListTile<String>(
      //                       title: Text(l10n.arabic),
      //                       value: 'ar',
      //                       groupValue: localeProvider.locale.languageCode,
      //                       onChanged: (value) {
      //                         if (value != null) {
      //                           localeProvider.setLocale(Locale(value));
      //                         }
      //                       },
      //                       secondary: const Icon(Icons.flag),
      //                     ),
      //                     RadioListTile<String>(
      //                       title: Text(l10n.english),
      //                       value: 'en',
      //                       groupValue: localeProvider.locale.languageCode,
      //                       onChanged: (value) {
      //                         if (value != null) {
      //                           localeProvider.setLocale(Locale(value));
      //                         }
      //                       },
      //                       secondary: const Icon(Icons.flag),
      //                     ),
      //                   ],
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),

      // ✅ الاتنين FAB هنا
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'theme_fab',
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: const Icon(Icons.palette),
            label: Text(l10n.changeTheme),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'lang_fab',
            onPressed: () {
              final currentLocale = context.read<LocaleProvider>().locale;
              final newLocale = currentLocale.languageCode == 'ar'
                  ? const Locale('en')
                  : const Locale('ar');
              context.read<LocaleProvider>().setLocale(newLocale);
            },
            icon: const Icon(Icons.language),
            label: Text(l10n.changeLanguage),
          ),
        ],
      ),
    );
  }
}