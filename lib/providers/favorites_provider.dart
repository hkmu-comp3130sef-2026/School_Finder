import 'dart:async';
import 'dart:io';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

import '../models/school.dart';
import '../services/native_bridge.dart';

/// Provider managing favorites state.
class FavoritesProvider extends ChangeNotifier {
  final List<School> _favorites = [];
  bool _isLoading = false;
  String? _error;

  List<School> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Checks if a school is in favorites.
  bool isFavorite(int schoolId) {
    return _favorites.any((school) => school.id.toInt() == schoolId);
  }

  /// Loads favorites from backend.
  Future<void> loadFavorites() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (!await NativeBridge().isAvailable()) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      final responseBytes = await NativeBridge().call(
        BridgeAction.getFavoriteSchools,
      );

      if (responseBytes == null) {
        throw Exception('Empty response from backend');
      }

      final response = await (Platform.environment.containsKey('FLUTTER_TEST')
          ? Future.value(parseFavoritesResponse(responseBytes))
          : compute(parseFavoritesResponse, responseBytes));
      _favorites
        ..clear()
        ..addAll(response.schools);

      _isLoading = false;
      notifyListeners();
    } on Exception catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Adds a school to favorites.
  /// Uses optimistic update - adds locally first, then syncs to backend.
  Future<void> addFavorite(School school) async {
    if (isFavorite(school.id.toInt())) return;

    // Optimistic update
    _favorites.add(school);
    notifyListeners();

    try {
      if (await NativeBridge().isAvailable()) {
        final request = FavoriteRequest(schoolId: school.id);

        await NativeBridge().call(BridgeAction.addFavorite, request);

        // NativeBridge.call() already handles errors via BridgeException
        // No additional parsing needed for response
      }
    } on Exception catch (e) {
      // Rollback on error
      _favorites.removeWhere((s) => s.id == school.id);
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Removes a school from favorites.
  /// Uses optimistic update - removes locally first, then syncs to backend.
  /// Returns the removed school for undo functionality.
  Future<School?> removeFavorite(int schoolId) async {
    final index = _favorites.indexWhere((s) => s.id.toInt() == schoolId);
    if (index == -1) return null;

    // Optimistic update
    final removed = _favorites.removeAt(index);
    notifyListeners();

    try {
      if (await NativeBridge().isAvailable()) {
        final request = FavoriteRequest(schoolId: Int64(schoolId));

        await NativeBridge().call(BridgeAction.removeFavorite, request);

        // NativeBridge.call() already handles errors via BridgeException
        // No additional parsing needed for response
      }
      return removed;
    } on Exception catch (e) {
      // Rollback on error
      _favorites.insert(index, removed);
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  /// Toggles favorite status for a school.
  Future<void> toggleFavorite(School school) async {
    if (isFavorite(school.id.toInt())) {
      await removeFavorite(school.id.toInt());
    } else {
      await addFavorite(school);
    }
  }

  /// Restores a removed favorite (for undo functionality).
  Future<void> restoreFavorite(School school) async {
    if (!isFavorite(school.id.toInt())) {
      // Reuse addFavorite which handles integration
      await addFavorite(school);
    }
  }

  /// Clears any error state.
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Top-level function for isolate
  SchoolListResponse parseFavoritesResponse(Uint8List bytes) {
    return SchoolListResponse.fromBuffer(bytes);
  }
}
