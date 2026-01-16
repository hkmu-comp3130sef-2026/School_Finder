import 'package:flutter/material.dart';

/// Animated favorite star toggle widget.
class FavoriteStar extends StatelessWidget {
  /// Whether the item is favorited.
  final bool isFavorite;

  /// Callback when the star is tapped.
  final VoidCallback? onToggle;

  /// Size of the icon.
  final double size;

  const FavoriteStar({
    required this.isFavorite,
    super.key,
    this.onToggle,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          key: ValueKey<bool>(isFavorite),
          color: isFavorite
              ? Colors.amber
              : Theme.of(context).colorScheme.outline,
          size: size,
        ),
      ),
      onPressed: onToggle,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
    );
  }
}
