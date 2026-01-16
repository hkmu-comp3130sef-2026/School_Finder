import 'dart:async';
import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';

import 'favorites_page.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'settings_page.dart';

/// Main app shell with bottom navigation.
///
/// Contains three tabs: Favorites (left), Home (center, default), Search (right).
/// AppBar has title on left and settings button on right.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  // Default to Home tab (index 1)
  int _currentIndex = 1;
  late final PageController _pageController;

  final List<Widget> _pages = const [FavoritesPage(), HomePage(), SearchPage()];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    // Smoothly animate to the selected page
    unawaited(
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  void _openSettings() {
    unawaited(
      Navigator.of(
        context,
      ).push(
        MaterialPageRoute<void>(builder: (context) => const SettingsPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _openSettings,
            tooltip: l10n.settingsTitle,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onTabTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.star_border),
            selectedIcon: const Icon(Icons.star),
            label: l10n.navFavorites,
          ),
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            selectedIcon: const Icon(Icons.search),
            label: l10n.navSearch,
          ),
        ],
      ),
    );
  }
}
