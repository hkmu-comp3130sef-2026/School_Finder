import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/constants.dart';
import 'package:school_app/main.dart';
import 'package:school_app/models/pb/bridge.pb.dart';
import 'package:school_app/models/pb/school.pb.dart';
import 'package:school_app/providers/settings_provider.dart';
import 'package:school_app/services/native_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel(AppConstants.bridgeChannelName);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          null,
        );
  });

  testWidgets('App renders correctly', (WidgetTester tester) async {
    // Mock NativeBridge
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          if (methodCall.method == 'ping') return true;
          if (methodCall.method == 'invoke') {
            final reqEnvelope = RequestEnvelope.fromBuffer(
              methodCall.arguments as Uint8List,
            );
            if (reqEnvelope.action.value == BridgeAction.getNearbySchools) {
              final response = RangeSearchResponse(schools: []);
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

    // Mock path_provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (methodCall) async => '.',
        );

    // Create a mock settings provider
    final settingsProvider = SettingsProvider();

    // Build our app and trigger a frame
    await tester.pumpWidget(SchoolApp(settingsProvider: settingsProvider));
    await tester.pump();

    // Verify the app renders without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
