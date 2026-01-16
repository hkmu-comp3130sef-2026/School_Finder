import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/models/pb/school.pb.dart';
import 'package:school_app/pages/home_page.dart';
import 'package:school_app/providers/search_provider.dart';

void main() {
  group('Performance Logic Tests', () {
    test('calculateRange scales correctly with zoom', () {
      // Zoom 14 -> ~5km
      expect(calculateRange(14), closeTo(5000, 100));

      // Zoom 10 -> ~50km (clamped max)
      expect(calculateRange(10), closeTo(50000, 1));

      // Zoom 18 -> Very small (clamped min)
      // 81920000 / 2^18 = ~312
      expect(calculateRange(18), closeTo(312.5, 1));
    });

    test('getCacheKey formats correctly', () {
      final key = getCacheKey(22.31234, 114.12345, 5000);

      // 3 decimal places + int range
      expect(key, '22.312_114.123_5000');
    });

    test('Isolate Parsers handle valid protobuf data', () {
      final schools = [School(id: Int64(1), nameEn: 'Test School')];
      final response = SchoolListResponse(schools: schools);
      final bytes = response.writeToBuffer();

      final parsed = parseSchoolListResponse(bytes);
      expect(parsed.schools.length, 1);
      expect(parsed.schools.first.nameEn, 'Test School');
    });
  });
}

// Helper to access visibleForTesting methods without subclassing if they were static,
// but they are instance methods. We need to subclass state or make them static mixins.
// Since they don't depend on state, let's just make valid testable wrappers.
// Actually, they are on _HomePageState (private).
// I need to check if I can instantiate the keys for testing or if I should refactor to static.
// Refactoring to static is cleaner for these pure functions.
