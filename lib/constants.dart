/// App-wide constants.
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  /// Platform Channel names
  static const String bridgeChannelName = 'school_app/bridge';

  /// Available Finance Types for Search
  static const List<String> availableFinanceTypes = [
    'Aided',
    'Government',
    'Direct Subsidy',
    'Private',
    'Private Independent',
  ];

  /// Available Sessions for Search
  static const List<String> availableSessions = ['AM', 'PM', 'Whole Day'];
}
