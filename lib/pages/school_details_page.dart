import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';

import '../models/school.dart';
import '../providers/favorites_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/favorite_star.dart';
import '../widgets/map_component.dart';
import 'package:url_launcher/url_launcher.dart';

/// School details page with static map and full school information.
class SchoolDetailsPage extends StatelessWidget {
  /// The school to display.
  final School school;

  const SchoolDetailsPage({required this.school, super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = context.watch<SettingsProvider>();
    final favorites = context.watch<FavoritesProvider>();
    final languageCode = settings.locale.languageCode;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.schoolDetailsTitle),
        actions: [
          FavoriteStar(
            isFavorite: favorites.isFavorite(school.id.toInt()),
            onToggle: () => unawaited(favorites.toggleFavorite(school)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Static map header (non-interactive, ~500m radius)
            SizedBox(
              height: 200,
              child: MapComponent(
                center: LatLng(school.latitude, school.longitude),
                zoom: 16, // ~500m visible radius
                interactive: false,
                schools: [school],
              ),
            ),

            // School name header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                school.getName(languageCode),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(height: 1),

            // Details section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.location_on,
                    label: l10n.labelAddress,
                    value: school.getAddress(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.map,
                    label: l10n.labelDistrict,
                    value: school.getDistrict(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.phone,
                    label: l10n.labelTelephone,
                    value: school.telephone,
                  ),
                  if (school.faxNumber.isNotEmpty)
                    _DetailRow(
                      icon: Icons.fax,
                      label: l10n.labelFax,
                      value: school.faxNumber,
                    ),
                  if (school.website.isNotEmpty)
                    _DetailRow(
                      icon: Icons.language,
                      label: l10n.labelWebsite,
                      value: school.website,
                      isLink: true,
                    ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Additional details
                  _DetailRow(
                    icon: Icons.account_balance,
                    label: l10n.labelFinanceType,
                    value: school.getFinanceType(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.school,
                    label: l10n.labelSchoolLevel,
                    value: school.getSchoolLevel(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.category,
                    label: l10n.labelCategory,
                    value: school.getCategory(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.people,
                    label: l10n.labelStudentGender,
                    value: school.getStudentGender(languageCode),
                  ),
                  _DetailRow(
                    icon: Icons.access_time,
                    label: l10n.labelSession,
                    value: school.getSession(languageCode),
                  ),
                  if (school.getReligion(languageCode).isNotEmpty)
                    _DetailRow(
                      icon: Icons.church,
                      label: l10n.labelReligion,
                      value: school.getReligion(languageCode),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchWebsite(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (!await launchUrl(url)) {
    throw Exception('can\'t open $url');
  }
}

/// A single detail row with icon, label, and value.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLink;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (value.isEmpty) return const SizedBox.shrink();

    Widget valueWidget = Text(
      value,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: isLink ? theme.colorScheme.primary : null,
        decoration: isLink ? TextDecoration.underline : null,
      ),
    );

    if (isLink) {
      valueWidget = InkWell(
        onTap: () => _launchWebsite(value),
        child: valueWidget,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 2),
                valueWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
