import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/school.dart';
import '../providers/settings_provider.dart';
import 'favorite_star.dart';

/// School list item widget.
///
/// Displays school name with optional distance and favorite star.
class SchoolListItem extends StatelessWidget {
  /// The school to display.
  final School school;

  /// Optional distance in meters (for nearby lists).
  final double? distance;

  /// Whether the school is favorited.
  final bool isFavorite;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Callback when the favorite star is tapped.
  final VoidCallback? onFavoriteToggle;

  const SchoolListItem({
    required this.school,
    required this.isFavorite,
    super.key,
    this.distance,
    this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final languageCode = settings.locale.languageCode;
    final theme = Theme.of(context);

    return ListTile(
      title: Text(
        school.getName(languageCode),
        style: theme.textTheme.bodyLarge,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: distance != null
          ? Text(
              _formatDistance(distance!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            )
          : null,
      trailing: FavoriteStar(
        isFavorite: isFavorite,
        onToggle: onFavoriteToggle,
      ),
      onTap: onTap,
    );
  }

  /// Formats distance for display.
  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
  }
}
