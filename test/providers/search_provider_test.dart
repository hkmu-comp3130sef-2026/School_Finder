import 'package:fixnum/fixnum.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/constants.dart';
import 'package:school_app/models/pb/bridge.pb.dart';
import 'package:school_app/models/school.dart';
import 'package:school_app/providers/search_provider.dart';
import 'package:school_app/services/native_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SearchProvider provider;
  const channel = MethodChannel(AppConstants.bridgeChannelName);
  final log = <MethodCall>[];

  setUp(() {
    provider = SearchProvider();
    log.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          log.add(methodCall);

          if (methodCall.method == 'ping') {
            return true;
          }

          if (methodCall.method == 'invoke') {
            final args = methodCall.arguments as Uint8List;
            final reqEnvelope = RequestEnvelope.fromBuffer(args);

            if (reqEnvelope.action.value == BridgeAction.searchBasic) {
              final requestBytes = reqEnvelope.payload;
              // payload is List<int>, need Uint8List
              final request = SearchRequest.fromBuffer(requestBytes);

              if (request.keyword == 'error') {
                final envelope = ResponseEnvelope(
                  success: false,
                  error: 'Simulated error',
                );
                return envelope.writeToBuffer();
              }

              final response = SchoolListResponse(
                schools: [
                  School(id: Int64(1), nameEn: 'Test School', nameZh: '測試學校'),
                ],
              );

              final envelope = ResponseEnvelope(
                success: true,
                payload: response.writeToBuffer(),
              );
              return envelope.writeToBuffer();
            }
          }
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('searchBasic updates results on success', () async {
    expect(provider.results.length, 0);
    expect(provider.isLoading, false);

    final future = provider.searchBasic('Test');
    expect(provider.isLoading, true);

    await future;

    expect(provider.isLoading, false);
    expect(provider.results.length, 1);
    expect(provider.results.first.nameEn, 'Test School');
    expect(provider.error, null);
  });

  test('searchBasic sets error on failure', () async {
    await provider.searchBasic('error');

    expect(provider.isLoading, false);
    expect(provider.results.length, 0);
    expect(provider.error, contains('Simulated error'));
  });

  test('searchBasic clears results on empty query', () async {
    // Setup initial results
    await provider.searchBasic('Test');
    expect(provider.results.length, 1);

    // Clear
    await provider.searchBasic('');
    expect(provider.results.length, 0);
  });
}
