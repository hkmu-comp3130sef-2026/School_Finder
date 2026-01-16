import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:provider/provider.dart';

import 'l10n/generated/app_localizations.dart';
import 'pages/app_shell.dart';
import 'providers/favorites_provider.dart';
import 'providers/search_provider.dart';
import 'providers/settings_provider.dart';
import 'services/native_bridge.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize settings provider
  final settingsProvider = SettingsProvider();
  await settingsProvider.initialize();

  // Initialize native bridge debug mode
  await NativeBridge().setDebugMode(enabled: kDebugMode);

  runApp(SchoolApp(settingsProvider: settingsProvider));
}

/// Main application widget.
class SchoolApp extends StatelessWidget {
  final SettingsProvider settingsProvider;

  const SchoolApp({required this.settingsProvider, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Settings provider (already initialized)
        ChangeNotifierProvider.value(value: settingsProvider),

        // Favorites provider
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),

        // Search provider
        ChangeNotifierProvider(create: (_) => SearchProvider()),

        // Theme provider (derived from settings)
        ChangeNotifierProxyProvider<SettingsProvider, ThemeProvider>(
          create: (_) => ThemeProvider(),
          update: (_, settings, themeProvider) {
            return themeProvider ??= ThemeProvider()
              ..setThemeMode(settings.themeMode)
              ..setColorSeed(settings.colorSeed);
          },
        ),
      ],
      child: Consumer2<SettingsProvider, ThemeProvider>(
        builder: (context, settings, themeProvider, _) {
          return MaterialApp(
            title: 'School Finder',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: themeProvider.lightTheme,
            darkTheme: themeProvider.darkTheme,
            themeMode: themeProvider.flutterThemeMode,

            // Localization configuration
            locale: settings.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('zh')],

            // Home page
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
