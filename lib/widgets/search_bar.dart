import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

/// Search bar widget with filter button for advanced search.
class AppSearchBar extends StatefulWidget {
  /// Callback when search is submitted.
  final void Function(String query)? onSearch;

  /// Callback when filter button is tapped.
  final VoidCallback? onFilterTap;

  /// Initial search query.
  final String? initialQuery;

  /// Whether to autofocus the search field.
  final bool autofocus;

  const AppSearchBar({
    super.key,
    this.onSearch,
    this.onFilterTap,
    this.initialQuery,
    this.autofocus = false,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) {
    widget.onSearch?.call(value.trim());
  }

  void _onClear() {
    _controller.clear();
    widget.onSearch?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SearchBar(
        controller: _controller,
        hintText: l10n.searchHint,
        leading: Icon(Icons.search, color: theme.colorScheme.outline),
        trailing: [
          // Clear button
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _controller,
            builder: (context, value, child) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _onClear,
              );
            },
          ),

          // Filter button
          IconButton(
            icon: Icon(Icons.tune, color: theme.colorScheme.primary),
            onPressed: widget.onFilterTap,
            tooltip: l10n.advancedSearchTitle,
          ),
        ],
        onSubmitted: _onSubmitted,
        autoFocus: widget.autofocus,
      ),
    );
  }
}
