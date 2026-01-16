import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_app/models/school.dart';

void main() {
  group('SchoolWithDistance.fromProto', () {
    test('correctly converts from RangeSearchResponseDTO', () {
      final schoolId = Int64(123);
      final protoSchool = School(
        id: schoolId,
        nameEn: 'Test School',
        addressEn: '123 Test St',
      );

      final protoDto = RangeSearchResponseDTO(
        school: protoSchool,
        distance: 500.5,
      );

      final result = SchoolWithDistance.fromProto(protoDto);

      expect(result.school.id, equals(schoolId));
      expect(result.school.nameEn, equals('Test School'));
      expect(result.distance, equals(500.5));
    });
  });
}
