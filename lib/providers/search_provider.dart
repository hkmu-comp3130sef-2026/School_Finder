import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import '../constants.dart';
import '../models/school.dart';
import '../services/native_bridge.dart';

/// Provider managing search state.
class SearchProvider extends ChangeNotifier {
  List<School> _results = [];
  bool _isLoading = false;
  String? _error;
  String _lastQuery = '';

  // Advanced search filters
  String _filterName = '';
  String _filterAddress = '';
  String _filterDistrict = '';
  String _filterFinanceType = '';
  String _filterSession = '';
  String _filterGender = '';
  String _currentLanguageCode = '';

  List<String> _availableFinanceTypes = AppConstants.availableFinanceTypes;

  List<String> _availableSessions = AppConstants.availableSessions;

  List<String> _availableDistricts = [];
  List<String> _availableGenders = [];

  bool _isLoadingOptions = false;

  List<School> get results => List.unmodifiable(_results);
  bool get isLoading => _isLoading;
  bool get isLoadingOptions => _isLoadingOptions;
  String? get error => _error;
  String get lastQuery => _lastQuery;

  // Filter getters
  String get filterName => _filterName;
  String get filterAddress => _filterAddress;
  String get filterDistrict => _filterDistrict;
  String get filterFinanceType => _filterFinanceType;
  String get filterSession => _filterSession;
  String get filterGender => _filterGender;

  List<String> get availableFinanceTypes =>
      List.unmodifiable(_availableFinanceTypes);
  List<String> get availableSessions => List.unmodifiable(_availableSessions);
  List<String> get availableDistricts => List.unmodifiable(_availableDistricts);
  List<String> get availableGenders => List.unmodifiable(_availableGenders);

  /// Gets the locations for map display.
  List<LatLng> get resultLocations {
    return _results.map((s) => LatLng(s.latitude, s.longitude)).toList();
  }

  /// Performs a basic keyword search.
  Future<void> searchBasic(String keyword) async {
    if (keyword.isEmpty) {
      _results = [];
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _lastQuery = keyword;
    notifyListeners();

    try {
      if (!await NativeBridge().isAvailable()) {
        throw Exception('Backend service unavailable');
      }

      final request = SearchRequest(keyword: keyword);
      final responseBytes = await NativeBridge().call(
        BridgeAction.searchBasic,
        request,
      );

      if (responseBytes == null) {
        throw Exception('Empty response from backend');
      }

      final response = await (Platform.environment.containsKey('FLUTTER_TEST')
          ? Future.value(parseSchoolListResponse(responseBytes))
          : compute(parseSchoolListResponse, responseBytes));
      _results = response.schools;

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sets advanced search filters.
  /// Sets advanced search filters.
  void setFilters({
    String? name,
    String? address,
    String? district,
    String? financeType,
    String? session,
    String? gender,
  }) {
    if (name != null) _filterName = name;
    if (address != null) _filterAddress = address;
    if (district != null) _filterDistrict = district;
    if (financeType != null) _filterFinanceType = financeType;
    if (session != null) _filterSession = session;
    if (gender != null) _filterGender = gender;
    notifyListeners();
  }

  void onLanguageChanged(String newLanguageCode) {
    if (_currentLanguageCode == '') {
      _currentLanguageCode = newLanguageCode;
      return;
    }

    if (_currentLanguageCode != newLanguageCode) {
      _currentLanguageCode = newLanguageCode;
      
      resetFilters();
      clearResults();
      
      unawaited(loadFilterOptions());
      
      notifyListeners();
    }
  }

  /// Resets all filters.
  void resetFilters() {
    _filterName = '';
    _filterAddress = '';
    _filterDistrict = '';
    _filterFinanceType = '';
    _filterSession = '';
    _filterGender = '';
    notifyListeners();
  }

  /// Loads available filter options from backend.
  Future<void> loadFilterOptions() async {
    if (_isLoadingOptions) return;

    _isLoadingOptions = true;
    notifyListeners();

    try {
      if (!await NativeBridge().isAvailable()) {
        // Silently fail or use defaults if bridge not ready
        _isLoadingOptions = false;
        notifyListeners();
        return;
      }

      final responseBytes = await NativeBridge().call(
        BridgeAction.getFilterOptions,
      );

      if (responseBytes != null) {
        
        final response = FilterOptionsResponse.fromBuffer(responseBytes);

        //print('DEBUG: Genders from backend: ${response.genders}');
        //print('DEBUG: Districts from backend: ${response.districts}');
        _availableFinanceTypes = response.financeTypes;
        _availableSessions = response.sessions;
        _availableDistricts = response.districts;
        if (response.genders.isEmpty) {
          _availableGenders = ['BOYS', 'GIRLS', 'CO-ED'];
        } else {
          _availableGenders = response.genders;
        }

      }

      _isLoadingOptions = false;
      notifyListeners();
    } on Exception catch (e) {
      // Keep defaults on error
      debugPrint('Error loading filter options: $e');
      _isLoadingOptions = false;
      notifyListeners();
    }
  }

  /// Performs an advanced search with current filters.
  Future<void> searchAdvanced() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!await NativeBridge().isAvailable()) {
        throw Exception('Backend service unavailable');
      }

      final request = AdvancedSearchRequest(
        name: _filterName,
        address: _filterAddress,
        district: _filterDistrict,
        financeType: _filterFinanceType,
        session: _filterSession,
        gender: _filterGender,
      );

      final responseBytes = await NativeBridge().call(
        BridgeAction.searchAdvanced,
        request,
      );

      if (responseBytes == null) {
        throw Exception('Empty response from backend');
      }

      final response = await (Platform.environment.containsKey('FLUTTER_TEST')
          ? Future.value(parseSchoolListResponse(responseBytes))
          : compute(parseSchoolListResponse, responseBytes));
      _results = response.schools;

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> performAdvancedSearch() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final request = AdvancedSearchRequest()
        ..name = _filterName
        ..address = _filterAddress
        ..district = _filterDistrict
        ..financeType = _filterFinanceType
        ..session = _filterSession
        ..gender = _filterGender;

      final responseBytes = await NativeBridge().call(
        BridgeAction.searchAdvanced,
        request,
      );

      if (responseBytes == null) throw Exception('Empty response');
      final response = SchoolListResponse.fromBuffer(responseBytes);
      
      List<School> filteredList = response.schools;

      if (_filterGender.isNotEmpty) {
        filteredList = filteredList.where((school) {
          return school.studentGenderEn == _filterGender || 
                school.studentGenderZh == _filterGender;
        }).toList();
      }

      _results.clear();
      _results.addAll(filteredList);
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears search results.
  void clearResults() {
    _results = [];
    _lastQuery = '';
    _error = null;
    notifyListeners();
  }

  /// Clears any error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// Top-level function for isolate
SchoolListResponse parseSchoolListResponse(Uint8List bytes) {
  return SchoolListResponse.fromBuffer(bytes);
}
