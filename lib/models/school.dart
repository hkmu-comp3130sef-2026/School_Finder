/// School domain model.
library;

import './pb/school.pb.dart';

// Export the generated protobuf classes so they can be used directly
export './pb/school.pb.dart';

/// Extension methods to add localization logic to the generated School class.
extension SchoolLocalization on School {
  /// Helper to get a safe int ID (converting from Int64).
  int get idInt => id.toInt();

  /// Returns the school name based on locale.
  String getName(String languageCode) {
    if (languageCode == 'zh' && hasNameZh() && nameZh.isNotEmpty) {
      return nameZh;
    }
    return (hasNameEn() && nameEn.isNotEmpty) ? nameEn : nameZh;
  }

  /// Returns the address based on locale.
  String getAddress(String languageCode) {
    if (languageCode == 'zh' && hasAddressZh() && addressZh.isNotEmpty) {
      return addressZh;
    }
    return (hasAddressEn() && addressEn.isNotEmpty) ? addressEn : addressZh;
  }

  /// Returns the district based on locale.
  String getDistrict(String languageCode) {
    if (languageCode == 'zh' && hasDistrictZh() && districtZh.isNotEmpty) {
      return districtZh;
    }
    return (hasDistrictEn() && districtEn.isNotEmpty) ? districtEn : districtZh;
  }

  /// Returns the finance types based on locale.
  String getFinanceType(String languageCode) {
    if (languageCode == 'zh' && financeTypesZh.isNotEmpty) {
      return financeTypesZh.join(' / ');
    }
    return financeTypesEn.isNotEmpty
        ? financeTypesEn.join(' / ')
        : financeTypesZh.join(' / ');
  }

  /// Returns the school level based on locale.
  String getSchoolLevel(String languageCode) {
    if (languageCode == 'zh' &&
        hasSchoolLevelZh() &&
        schoolLevelZh.isNotEmpty) {
      return schoolLevelZh;
    }
    return (hasSchoolLevelEn() && schoolLevelEn.isNotEmpty)
        ? schoolLevelEn
        : schoolLevelZh;
  }

  /// Returns the category based on locale.
  String getCategory(String languageCode) {
    if (languageCode == 'zh' && hasCategoryZh() && categoryZh.isNotEmpty) {
      return categoryZh;
    }
    return (hasCategoryEn() && categoryEn.isNotEmpty) ? categoryEn : categoryZh;
  }

  /// Returns the student gender based on locale.
  String getStudentGender(String languageCode) {
    if (languageCode == 'zh' &&
        hasStudentGenderZh() &&
        studentGenderZh.isNotEmpty) {
      return studentGenderZh;
    }
    return (hasStudentGenderEn() && studentGenderEn.isNotEmpty)
        ? studentGenderEn
        : studentGenderZh;
  }

  /// Returns the sessions based on locale.
  String getSession(String languageCode) {
    if (languageCode == 'zh' && sessionsZh.isNotEmpty) {
      return sessionsZh.join(' / ');
    }
    return sessionsEn.isNotEmpty
        ? sessionsEn.join(' / ')
        : sessionsZh.join(' / ');
  }

  /// Returns the religion based on locale.
  String getReligion(String languageCode) {
    if (languageCode == 'zh' && hasReligionZh() && religionZh.isNotEmpty) {
      return religionZh;
    }
    return (hasReligionEn() && religionEn.isNotEmpty) ? religionEn : religionZh;
  }
}

/// School with distance information for nearby lists.
/// This matches the previous manual implementation but uses the generated School class.
class SchoolWithDistance {
  final School school;
  final double distance; // in meters

  const SchoolWithDistance({required this.school, required this.distance});

  /// Creates a SchoolWithDistance from a Protobuf RangeSearchResponseDTO.
  factory SchoolWithDistance.fromProto(RangeSearchResponseDTO dto) {
    return SchoolWithDistance(school: dto.school, distance: dto.distance);
  }

  /// Formats distance for display.
  String formatDistance() {
    if (distance < 1000) {
      return '${distance.round()} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }
}
