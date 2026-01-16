import 'package:flutter/material.dart';

/// Available theme modes for the app.
enum AppThemeMode {
  system,
  light,
  dark
  ;

  /// Converts to Flutter's ThemeMode.
  ThemeMode toThemeMode() {
    switch (this) {
      case AppThemeMode.system:
        return ThemeMode.system;
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
    }
  }

  /// Creates from a string value.
  static AppThemeMode fromString(String value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  /// Converts to string for storage.
  String toStringValue() {
    switch (this) {
      case AppThemeMode.system:
        return 'system';
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
    }
  }
}

/// Available color seeds for Material 3 theming.
enum ColorSeed {
  blue(Colors.blue, 'blue'),
  green(Colors.green, 'green'),
  purple(Colors.purple, 'purple'),
  orange(Colors.orange, 'orange'),
  teal(Colors.teal, 'teal')
  ;

  final Color color;
  final String value;

  const ColorSeed(this.color, this.value);

  /// Creates from a string value.
  static ColorSeed fromString(String value) {
    return ColorSeed.values.firstWhere(
      (seed) => seed.value == value,
      orElse: () => ColorSeed.blue,
    );
  }
}

/// Theme provider managing app theme state.
class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  ColorSeed _colorSeed = ColorSeed.blue;

  AppThemeMode get themeMode => _themeMode;
  ColorSeed get colorSeed => _colorSeed;
  ThemeMode get flutterThemeMode => _themeMode.toThemeMode();

  /// Sets the theme mode and notifies listeners.
  void setThemeMode(AppThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }

  /// Sets the color seed and notifies listeners.
  void setColorSeed(ColorSeed seed) {
    if (_colorSeed != seed) {
      _colorSeed = seed;
      notifyListeners();
    }
  }

  /// Creates a light theme with the current color seed.
  ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colorSeed.color,
      ),
    );
  }

  /// Creates a dark theme with the current color seed.
  ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _colorSeed.color,
        brightness: Brightness.dark,
      ),
    );
  }
}
