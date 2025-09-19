import 'package:deliva_eat/core/theme/provider.dart';
import 'package:deliva_eat/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Use the buttons below to change theme and language.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'theme_fab', // ضروري لتجنب الأخطاء
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
            icon: const Icon(Icons.palette),
            label: Text(l10n.changeTheme),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'lang_fab', // ضروري لتجنب الأخطاء
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
