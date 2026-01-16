import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/school.dart';
import '../services/native_bridge.dart';
import '../theme/app_theme.dart';

/// Provider managing user settings with optimistic UI updates.
///
/// Settings are immediately applied locally and asynchronously
/// persisted to SharedPreferences + backend.
class SettingsProvider extends ChangeNotifier {
  static const String _keyLanguage = 'settings_language';
  static const String _keyThemeMode = 'settings_theme_mode';
  static const String _keyColorSeed = 'settings_color_seed';

  Locale _locale = const Locale('en');
  AppThemeMode _themeMode = AppThemeMode.system;
  ColorSeed _colorSeed = ColorSeed.blue;

  bool _isInitialized = false;

  Locale get locale => _locale;
  AppThemeMode get themeMode => _themeMode;
  ColorSeed get colorSeed => _colorSeed;
  bool get isInitialized => _isInitialized;

  /// Initializes settings from local storage.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = SharedPreferencesAsync();

      // Load language
      final languageCode = await prefs.getString(_keyLanguage) ?? 'en';
      _locale = Locale(languageCode);

      // Load theme mode
      final themeModeValue = await prefs.getString(_keyThemeMode) ?? 'system';
      _themeMode = AppThemeMode.fromString(themeModeValue);

      // Load color seed
      final colorSeedValue = await prefs.getString(_keyColorSeed) ?? 'blue';
      _colorSeed = ColorSeed.fromString(colorSeedValue);

      _isInitialized = true;
      notifyListeners();
    } on Exception catch (e) {
      debugPrint('Failed to initialize settings: $e');
      // Use defaults on error
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Sets the app language.
  ///
  /// Optimistically updates the UI immediately, then persists.
  void setLanguage(String languageCode) {
    if (_locale.languageCode == languageCode) return;

    _locale = Locale(languageCode);
    notifyListeners();

    // Persist asynchronously
    unawaited(_persistSetting(_keyLanguage, languageCode));
    unawaited(_syncToBackend());
  }

  /// Sets the theme mode.
  void setThemeMode(AppThemeMode mode) {
    if (_themeMode == mode) return;

    _themeMode = mode;
    notifyListeners();

    unawaited(_persistSetting(_keyThemeMode, mode.toStringValue()));
    unawaited(_syncToBackend());
  }

  /// Sets the color seed.
  void setColorSeed(ColorSeed seed) {
    if (_colorSeed == seed) return;

    _colorSeed = seed;
    notifyListeners();

    unawaited(_persistSetting(_keyColorSeed, seed.value));
    unawaited(_syncToBackend());
  }

  /// Persists a single setting to SharedPreferences.
  Future<void> _persistSetting(String key, String value) async {
    try {
      await SharedPreferencesAsync().setString(key, value);
    } on Exception catch (e) {
      debugPrint('Failed to persist setting $key: $e');
      // Silently fail - optimistic update already done
    }
  }

  /// Syncs current settings to the backend asynchronously.
  /// This is fire-and-forget for optimistic UI.
  Future<void> _syncToBackend() async {
    try {
      if (await NativeBridge().isAvailable()) {
        final request = UserSettings(
          language: _locale.languageCode,
          themeMode: _themeMode.toStringValue(),
          colorSeed: _colorSeed.value,
        );

        await NativeBridge().call(BridgeAction.updateSettings, request);
      }
    } on Exception catch (e) {
      debugPrint('Failed to sync settings: $e');
    }
  }
}
