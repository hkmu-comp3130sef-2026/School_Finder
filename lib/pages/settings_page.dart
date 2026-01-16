import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

/// Settings page for language, theme mode, and color seed.
///
/// Uses optimistic UI - changes apply immediately to local state,
/// then async sync to backend.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        children: [
          // Language Section
          _SectionHeader(title: l10n.settingsLanguage),
          _LanguageTile(
            title: l10n.languageEnglish,
            languageCode: 'en',
            isSelected: settings.locale.languageCode == 'en',
            onTap: () => settings.setLanguage('en'),
          ),
          _LanguageTile(
            title: l10n.languageChinese,
            languageCode: 'zh',
            isSelected: settings.locale.languageCode == 'zh',
            onTap: () => settings.setLanguage('zh'),
          ),

          const Divider(),

          // Theme Mode Section
          _SectionHeader(title: l10n.settingsThemeMode),
          _ThemeModeTile(
            title: l10n.themeModeSystem,
            icon: Icons.brightness_auto,
            isSelected: settings.themeMode == AppThemeMode.system,
            onTap: () => settings.setThemeMode(AppThemeMode.system),
          ),
          _ThemeModeTile(
            title: l10n.themeModeLight,
            icon: Icons.light_mode,
            isSelected: settings.themeMode == AppThemeMode.light,
            onTap: () => settings.setThemeMode(AppThemeMode.light),
          ),
          _ThemeModeTile(
            title: l10n.themeModeDark,
            icon: Icons.dark_mode,
            isSelected: settings.themeMode == AppThemeMode.dark,
            onTap: () => settings.setThemeMode(AppThemeMode.dark),
          ),

          const Divider(),

          // Color Seed Section
          _SectionHeader(title: l10n.settingsColorSeed),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ColorSeed.values.map((seed) {
                final isSelected = settings.colorSeed == seed;
                return GestureDetector(
                  onTap: () => settings.setColorSeed(seed),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: seed.color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: theme.colorScheme.onSurface,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: seed.color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            color: _getContrastColor(seed.color),
                          )
                        : null,
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        languageCode == 'en' ? '🇬🇧' : '🇭🇰',
        style: const TextStyle(fontSize: 24),
      ),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}

class _ThemeModeTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeModeTile({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: onTap,
    );
  }
}
