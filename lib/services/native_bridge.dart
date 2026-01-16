import 'dart:async';

import 'package:flutter/services.dart';
import 'package:protobuf/protobuf.dart';
import '../constants.dart';
import '../models/pb/bridge.pb.dart';
import '../utils/logger.dart';

/// Native bridge service for communicating with the Go backend via MethodChannel.
///
/// This service handles all Flutter <-> Native <-> Go communication using
/// Protobuf serialization.
class NativeBridge {
  static const MethodChannel _channel = MethodChannel(
    AppConstants.bridgeChannelName,
  );

  // Singleton instance
  static final NativeBridge _instance = NativeBridge._internal();

  factory NativeBridge() => _instance;

  NativeBridge._internal();

  /// Sends a request to the native bridge and returns the raw response bytes.
  ///
  /// [action] - The action enum value (int) to perform
  /// [request] - The protobuf request payload (optional)
  ///
  /// Returns the serialized protobuf response payload.
  /// Throws [PlatformException] or [BridgeException] if the native call fails.
  Future<Uint8List?> call(int action, [GeneratedMessage? request]) async {
    final actionName = _actionName(action);
    AppLogger.d('NativeBridge', 'Calling action: $actionName ($action)');

    try {
      // Create request envelope
      final reqEnvelope = RequestEnvelope(
        action: Action.valueOf(action) ?? Action.ACTION_UNSPECIFIED,
        payload: request?.writeToBuffer(),
      );

      // Invoke native method with serialized envelope
      final resultBytes = await _channel.invokeMethod<Uint8List>(
        'invoke',
        reqEnvelope.writeToBuffer(),
      );

      if (resultBytes == null) {
        throw BridgeException('Received null response from native bridge');
      }

      // Parse response envelope
      final respEnvelope = ResponseEnvelope.fromBuffer(resultBytes);

      if (!respEnvelope.success) {
        AppLogger.e(
          'NativeBridge',
          'Action $actionName failed: ${respEnvelope.error}',
        );
        throw BridgeException(respEnvelope.error);
      }

      AppLogger.d(
        'NativeBridge',
        'Action $actionName success, payload size: ${respEnvelope.payload.length}',
      );
      return Uint8List.fromList(respEnvelope.payload);
    } on PlatformException catch (e) {
      AppLogger.e('NativeBridge', 'Platform exception for $actionName', e);
      throw BridgeException('Bridge call failed: ${e.message}', e.code);
    }
  }

  /// Helper method to check if the bridge is available.
  Future<bool> isAvailable() async {
    try {
      await _channel.invokeMethod<bool>('ping');
      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  String _actionName(int action) {
    switch (action) {
      case BridgeAction.getNearbySchools:
        return 'getNearbySchools';
      case BridgeAction.getFavoriteSchools:
        return 'getFavoriteSchools';
      case BridgeAction.addFavorite:
        return 'addFavorite';
      case BridgeAction.removeFavorite:
        return 'removeFavorite';
      case BridgeAction.saveMapState:
        return 'saveMapState';
      case BridgeAction.getMapState:
        return 'getMapState';
      case BridgeAction.searchBasic:
        return 'searchBasic';
      case BridgeAction.searchAdvanced:
        return 'searchAdvanced';
      case BridgeAction.getSchoolDetails:
        return 'getSchoolDetails';
      case BridgeAction.updateSettings:
        return 'updateSettings';
      case BridgeAction.getSettings:
        return 'getSettings';
      case BridgeAction.getFilterOptions:
        return 'getFilterOptions';
      case BridgeAction.reloadData:
        return 'reloadData';
      case BridgeAction.setDebugMode:
        return 'setDebugMode';
      default:
        return 'Unknown($action)';
    }
  }

  /// Sets the debug mode on the native side.
  ///
  /// [enabled] - Whether debug logging should be enabled.
  Future<void> setDebugMode({required bool enabled}) {
    return call(
      BridgeAction.setDebugMode,
      SetDebugModeRequest(enabled: enabled),
    );
  }
}

/// Exception thrown when a bridge call fails.
class BridgeException implements Exception {
  final String message;
  final String? code;

  BridgeException(this.message, [this.code]);

  @override
  String toString() => 'BridgeException: $message (code: $code)';
}

/// Action enum values matching the protobuf Action enum in bridge.proto.
/// These must stay in sync with the proto definition.
abstract class BridgeAction {
  static const int unspecified = 0;

  // Home Page Actions
  static const int getNearbySchools = 1;

  // Favorites Page Actions
  static const int getFavoriteSchools = 2;
  static const int addFavorite = 3;
  static const int removeFavorite = 4;
  static const int saveMapState = 5;
  static const int getMapState = 6;

  // Search Page Actions
  static const int searchBasic = 7;
  static const int searchAdvanced = 8;

  // Details Page
  static const int getSchoolDetails = 9;

  // Settings
  static const int updateSettings = 10;
  static const int getSettings = 11;
  static const int getFilterOptions = 12;
  static const int reloadData = 13;
  static const int setDebugMode = 14;
}
