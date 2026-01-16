import 'package:flutter/foundation.dart';

/// Global application logger for consistent debug output.
class AppLogger {
  AppLogger._();

  /// Log a debug message.
  ///
  /// [tag] identifies the source (class/component).
  /// [message] is the log content.
  static void d(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] DEBUG: $message');
    }
  }

  /// Log an info message.
  static void i(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] INFO: $message');
    }
  }

  /// Log an error message with optional error object and stack trace.
  static void e(
    String tag,
    String message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    debugPrint('[$tag] ERROR: $message');
    if (error != null) {
      debugPrint('[$tag] Exception: $error');
    }
    if (stackTrace != null) {
      debugPrint('[$tag] Stack: $stackTrace');
    }
  }
}
