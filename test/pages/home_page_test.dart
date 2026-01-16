import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:school_app/constants.dart';
import 'package:school_app/l10n/generated/app_localizations.dart';
import 'package:school_app/models/pb/bridge.pb.dart';
import 'package:school_app/models/school.dart';
import 'package:school_app/pages/home_page.dart';
import 'package:school_app/providers/favorites_provider.dart';
import 'package:school_app/providers/settings_provider.dart';
import 'package:school_app/services/native_bridge.dart';
import 'package:school_app/theme/app_theme.dart';

// Mock SettingsProvider since SchoolListItem requires it
class MockSettingsProvider extends ChangeNotifier implements SettingsProvider {
  Locale _locale = const Locale('en');
  @override
  Locale get locale => _locale;

  AppThemeMode _themeMode = AppThemeMode.system;
  @override
  AppThemeMode get themeMode => _themeMode;

  ColorSeed _colorSeed = ColorSeed.blue;
  @override
  ColorSeed get colorSeed => _colorSeed;

  @override
  bool get isInitialized => true;

  @override
  Future<void> initialize() async {}

  @override
  void setLanguage(String languageCode) {
    _locale = Locale(languageCode);
    notifyListeners();
  }

  @override
  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  @override
  void setColorSeed(ColorSeed seed) {
    _colorSeed = seed;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(AppConstants.bridgeChannelName);

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'ping') {
            return true;
          }

          if (methodCall.method == 'invoke') {
            final args = methodCall.arguments as Uint8List;
            final reqEnvelope = RequestEnvelope.fromBuffer(args);

            if (reqEnvelope.action.value == BridgeAction.getNearbySchools) {
              final response = RangeSearchResponse(
                schools: [
                  RangeSearchResponseDTO(
                    school: School(
                      id: Int64(1),
                      nameEn: 'Nearby School',
                      latitude: 22.3,
                      longitude: 114.2,
                    ),
                    distance: 100,
                  ),
                ],
              );
              return ResponseEnvelope(
                success: true,
                payload: response.writeToBuffer(),
              ).writeToBuffer();
            }

            if (reqEnvelope.action.value == BridgeAction.getFavoriteSchools) {
              final response = SchoolListResponse(schools: []);
              return ResponseEnvelope(
                success: true,
                payload: response.writeToBuffer(),
              ).writeToBuffer();
            }
          }
          return null;
        });

    // Mock Geolocator channel to fail immediately so LocationService uses default
    const geolocatorChannel = MethodChannel(
      'flutter.baseflow.com/geolocator',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, (
          MethodCall methodCall,
        ) async {
          throw PlatformException(code: 'TEST_ERROR', message: 'Mock error');
        });
    // Mock path_provider for flutter_map cache
    const pathProviderChannel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathProviderChannel, (
          MethodCall methodCall,
        ) async {
          return '.';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter.baseflow.com/geolocator'),
          null,
        );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
  });

  testWidgets('HomePage loads and displays items', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<FavoritesProvider>(
            create: (_) => FavoritesProvider(),
          ),
          ChangeNotifierProvider<SettingsProvider>(
            create: (_) => MockSettingsProvider(),
          ),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: HomePage()),
        ),
      ),
    );

    // Initial loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for async operations (LocationService failure -> Default Location -> Bridge Call -> List Update)
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(); // Ensure rebuild after async op finishes

    // Check if loading is gone
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Check if list item is present
    expect(find.text('Nearby School'), findsOneWidget);
  });
}
