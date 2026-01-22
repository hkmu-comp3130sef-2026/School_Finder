import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/generated/app_localizations.dart';

import '../providers/search_provider.dart';

/// Advanced search page with filter fields.
///
/// Filters: name (regex), address (regex), district, finance type (exact), session (exact).
/// Apply applies filters and returns to search page.
/// Reset clears all filters.
class AdvancedSearchPage extends StatefulWidget {
  const AdvancedSearchPage({super.key});

  @override
  State<AdvancedSearchPage> createState() => _AdvancedSearchPageState();
}

class _AdvancedSearchPageState extends State<AdvancedSearchPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;

  String? _selectedFinanceType;
  String? _selectedSession;
  String? _selectedGender = '';
  String? _selectedDistrict;

  @override
  void initState() {
    super.initState();
    final search = context.read<SearchProvider>();
    // Load options if not loaded
    unawaited(search.loadFilterOptions());

    _nameController = TextEditingController(text: search.filterName);
    _addressController = TextEditingController(text: search.filterAddress);
    _selectedFinanceType = search.filterFinanceType.isEmpty 
        ? null 
        : search.filterFinanceType;
    _selectedSession = search.filterSession.isEmpty 
        ? null 
        : search.filterSession;
    _selectedGender = search.filterGender.isEmpty 
        ? '' 
        : search.filterGender;
    _selectedDistrict = search.filterDistrict.isEmpty 
        ? null 
        : search.filterDistrict;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _apply() {
    final search = context.read<SearchProvider>();
    unawaited(
      (search
            ..setFilters(
              name: _nameController.text.trim(),
              address: _addressController.text.trim(),
              district: _selectedDistrict ?? '', 
              financeType: _selectedFinanceType ?? '',
              session: _selectedSession ?? '',
              gender: _selectedGender ?? '', 
            ))
          .performAdvancedSearch(), 
    );
    Navigator.of(context).pop(true);
  }

  void _reset() {
    setState(() {
      _nameController.clear();
      _addressController.clear();
      _selectedFinanceType = null;
      _selectedSession = null;
      _selectedGender = '';
      _selectedDistrict = null;
    });

    context.read<SearchProvider>().resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Watch for options changes
    final search = context.watch<SearchProvider>();
    final isZh = Localizations.localeOf(context).languageCode == 'zh';

    // Show loading if options are being fetched
    if (search.isLoadingOptions) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.advancedSearchTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.advancedSearchTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _apply, // Back button applies filters per doc.md
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Name filter (regex)
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.filterName,
              hintText: 'e.g., St. Mary',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.school),
            ),
          ),
          const SizedBox(height: 16),

          // Address filter (regex)
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              labelText: l10n.filterAddress,
              hintText: 'e.g., Queen Road',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.location_on),
            ),
          ),
          const SizedBox(height: 16),

          // District filter (regex))
          DropdownButtonFormField<String>(
            initialValue: _selectedDistrict,
            decoration: InputDecoration(
              labelText: l10n.filterDistrict,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.map),
            ),
            items: [
              DropdownMenuItem<String>(value: null, child: Text(l10n.filterAny)),
              ...search.availableDistricts.map(
                (d) => DropdownMenuItem(value: d, child: Text(d)),
              ),
            ],
            onChanged: (value) => setState(() => _selectedDistrict = value),
          ),
          const SizedBox(height: 16),

          // Gender filter (regex)
          DropdownButtonFormField<String>(
            initialValue: _selectedGender,
            decoration: InputDecoration(
              labelText: l10n.filterGender,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.people),
            ),
            items: [
              DropdownMenuItem(
                value: '', 
                child: Text(l10n.filterAny),
              ),
              DropdownMenuItem(
                value: 'BOYS', 
                child: Text(isZh ? '男校' : 'Boys'),
              ),
              DropdownMenuItem(
                value: 'GIRLS', 
                child: Text(isZh ? '女校' : 'Girls'),
              ),
              DropdownMenuItem(
                value: 'CO-ED', 
                child: Text(isZh ? '男女校' : 'Co-ed'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedGender = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Finance type filter (exact match dropdown from provider)
          DropdownButtonFormField<String>(
            initialValue: _selectedFinanceType,
            decoration: InputDecoration(
              labelText: l10n.filterFinanceType,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.account_balance),
            ),
            items: [
              DropdownMenuItem<String>(
                child: Text(l10n.filterAny),
              ),
              ...search.availableFinanceTypes.map(
                (type) => DropdownMenuItem(value: type, child: Text(type)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedFinanceType = value;
              });
            },
          ),
          const SizedBox(height: 16),

          // Session filter (exact match dropdown from provider)
          DropdownButtonFormField<String>(
            initialValue: _selectedSession,
            decoration: InputDecoration(
              labelText: l10n.filterSession,
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.access_time),
            ),
            items: [
              DropdownMenuItem<String>(
                child: Text(l10n.filterAny),
              ),
              ...search.availableSessions.map(
                (session) =>
                    DropdownMenuItem(value: session, child: Text(session)),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSession = value;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Reset button
              Expanded(
                child: OutlinedButton(
                  onPressed: _reset,
                  child: Text(l10n.buttonReset),
                ),
              ),
              const SizedBox(width: 16),
              // Apply button
              Expanded(
                child: FilledButton(
                  onPressed: _apply,
                  child: Text(l10n.buttonApply),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
