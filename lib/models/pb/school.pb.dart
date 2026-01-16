// This is a generated file - do not edit.
//
// Generated from school.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class School extends $pb.GeneratedMessage {
  factory School({
    $fixnum.Int64? id,
    $core.String? nameEn,
    $core.String? nameZh,
    $core.String? addressEn,
    $core.String? addressZh,
    $core.double? latitude,
    $core.double? longitude,
    $core.String? districtEn,
    $core.String? districtZh,
    $core.Iterable<$core.String>? financeTypesEn,
    $core.Iterable<$core.String>? financeTypesZh,
    $core.String? schoolLevelEn,
    $core.String? schoolLevelZh,
    $core.String? categoryEn,
    $core.String? categoryZh,
    $core.String? studentGenderEn,
    $core.String? studentGenderZh,
    $core.Iterable<$core.String>? sessionsEn,
    $core.Iterable<$core.String>? sessionsZh,
    $core.String? religionEn,
    $core.String? religionZh,
    $core.String? telephone,
    $core.String? faxNumber,
    $core.String? website,
    $core.Iterable<$fixnum.Int64>? originalIds,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (nameEn != null) result.nameEn = nameEn;
    if (nameZh != null) result.nameZh = nameZh;
    if (addressEn != null) result.addressEn = addressEn;
    if (addressZh != null) result.addressZh = addressZh;
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    if (districtEn != null) result.districtEn = districtEn;
    if (districtZh != null) result.districtZh = districtZh;
    if (financeTypesEn != null) result.financeTypesEn.addAll(financeTypesEn);
    if (financeTypesZh != null) result.financeTypesZh.addAll(financeTypesZh);
    if (schoolLevelEn != null) result.schoolLevelEn = schoolLevelEn;
    if (schoolLevelZh != null) result.schoolLevelZh = schoolLevelZh;
    if (categoryEn != null) result.categoryEn = categoryEn;
    if (categoryZh != null) result.categoryZh = categoryZh;
    if (studentGenderEn != null) result.studentGenderEn = studentGenderEn;
    if (studentGenderZh != null) result.studentGenderZh = studentGenderZh;
    if (sessionsEn != null) result.sessionsEn.addAll(sessionsEn);
    if (sessionsZh != null) result.sessionsZh.addAll(sessionsZh);
    if (religionEn != null) result.religionEn = religionEn;
    if (religionZh != null) result.religionZh = religionZh;
    if (telephone != null) result.telephone = telephone;
    if (faxNumber != null) result.faxNumber = faxNumber;
    if (website != null) result.website = website;
    if (originalIds != null) result.originalIds.addAll(originalIds);
    return result;
  }

  School._();

  factory School.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory School.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'School',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'nameEn')
    ..aOS(3, _omitFieldNames ? '' : 'nameZh')
    ..aOS(4, _omitFieldNames ? '' : 'addressEn')
    ..aOS(5, _omitFieldNames ? '' : 'addressZh')
    ..aD(6, _omitFieldNames ? '' : 'latitude')
    ..aD(7, _omitFieldNames ? '' : 'longitude')
    ..aOS(8, _omitFieldNames ? '' : 'districtEn')
    ..aOS(9, _omitFieldNames ? '' : 'districtZh')
    ..pPS(10, _omitFieldNames ? '' : 'financeTypesEn')
    ..pPS(11, _omitFieldNames ? '' : 'financeTypesZh')
    ..aOS(12, _omitFieldNames ? '' : 'schoolLevelEn')
    ..aOS(13, _omitFieldNames ? '' : 'schoolLevelZh')
    ..aOS(14, _omitFieldNames ? '' : 'categoryEn')
    ..aOS(15, _omitFieldNames ? '' : 'categoryZh')
    ..aOS(16, _omitFieldNames ? '' : 'studentGenderEn')
    ..aOS(17, _omitFieldNames ? '' : 'studentGenderZh')
    ..pPS(18, _omitFieldNames ? '' : 'sessionsEn')
    ..pPS(19, _omitFieldNames ? '' : 'sessionsZh')
    ..aOS(20, _omitFieldNames ? '' : 'religionEn')
    ..aOS(21, _omitFieldNames ? '' : 'religionZh')
    ..aOS(22, _omitFieldNames ? '' : 'telephone')
    ..aOS(23, _omitFieldNames ? '' : 'faxNumber')
    ..aOS(24, _omitFieldNames ? '' : 'website')
    ..p<$fixnum.Int64>(
        25, _omitFieldNames ? '' : 'originalIds', $pb.PbFieldType.K6)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  School clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  School copyWith(void Function(School) updates) =>
      super.copyWith((message) => updates(message as School)) as School;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static School create() => School._();
  @$core.override
  School createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static School getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<School>(create);
  static School? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nameEn => $_getSZ(1);
  @$pb.TagNumber(2)
  set nameEn($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNameEn() => $_has(1);
  @$pb.TagNumber(2)
  void clearNameEn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nameZh => $_getSZ(2);
  @$pb.TagNumber(3)
  set nameZh($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNameZh() => $_has(2);
  @$pb.TagNumber(3)
  void clearNameZh() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get addressEn => $_getSZ(3);
  @$pb.TagNumber(4)
  set addressEn($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAddressEn() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddressEn() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get addressZh => $_getSZ(4);
  @$pb.TagNumber(5)
  set addressZh($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasAddressZh() => $_has(4);
  @$pb.TagNumber(5)
  void clearAddressZh() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get latitude => $_getN(5);
  @$pb.TagNumber(6)
  set latitude($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasLatitude() => $_has(5);
  @$pb.TagNumber(6)
  void clearLatitude() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.double get longitude => $_getN(6);
  @$pb.TagNumber(7)
  set longitude($core.double value) => $_setDouble(6, value);
  @$pb.TagNumber(7)
  $core.bool hasLongitude() => $_has(6);
  @$pb.TagNumber(7)
  void clearLongitude() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get districtEn => $_getSZ(7);
  @$pb.TagNumber(8)
  set districtEn($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasDistrictEn() => $_has(7);
  @$pb.TagNumber(8)
  void clearDistrictEn() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get districtZh => $_getSZ(8);
  @$pb.TagNumber(9)
  set districtZh($core.String value) => $_setString(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDistrictZh() => $_has(8);
  @$pb.TagNumber(9)
  void clearDistrictZh() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$core.String> get financeTypesEn => $_getList(9);

  @$pb.TagNumber(11)
  $pb.PbList<$core.String> get financeTypesZh => $_getList(10);

  @$pb.TagNumber(12)
  $core.String get schoolLevelEn => $_getSZ(11);
  @$pb.TagNumber(12)
  set schoolLevelEn($core.String value) => $_setString(11, value);
  @$pb.TagNumber(12)
  $core.bool hasSchoolLevelEn() => $_has(11);
  @$pb.TagNumber(12)
  void clearSchoolLevelEn() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get schoolLevelZh => $_getSZ(12);
  @$pb.TagNumber(13)
  set schoolLevelZh($core.String value) => $_setString(12, value);
  @$pb.TagNumber(13)
  $core.bool hasSchoolLevelZh() => $_has(12);
  @$pb.TagNumber(13)
  void clearSchoolLevelZh() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get categoryEn => $_getSZ(13);
  @$pb.TagNumber(14)
  set categoryEn($core.String value) => $_setString(13, value);
  @$pb.TagNumber(14)
  $core.bool hasCategoryEn() => $_has(13);
  @$pb.TagNumber(14)
  void clearCategoryEn() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get categoryZh => $_getSZ(14);
  @$pb.TagNumber(15)
  set categoryZh($core.String value) => $_setString(14, value);
  @$pb.TagNumber(15)
  $core.bool hasCategoryZh() => $_has(14);
  @$pb.TagNumber(15)
  void clearCategoryZh() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get studentGenderEn => $_getSZ(15);
  @$pb.TagNumber(16)
  set studentGenderEn($core.String value) => $_setString(15, value);
  @$pb.TagNumber(16)
  $core.bool hasStudentGenderEn() => $_has(15);
  @$pb.TagNumber(16)
  void clearStudentGenderEn() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.String get studentGenderZh => $_getSZ(16);
  @$pb.TagNumber(17)
  set studentGenderZh($core.String value) => $_setString(16, value);
  @$pb.TagNumber(17)
  $core.bool hasStudentGenderZh() => $_has(16);
  @$pb.TagNumber(17)
  void clearStudentGenderZh() => $_clearField(17);

  @$pb.TagNumber(18)
  $pb.PbList<$core.String> get sessionsEn => $_getList(17);

  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get sessionsZh => $_getList(18);

  @$pb.TagNumber(20)
  $core.String get religionEn => $_getSZ(19);
  @$pb.TagNumber(20)
  set religionEn($core.String value) => $_setString(19, value);
  @$pb.TagNumber(20)
  $core.bool hasReligionEn() => $_has(19);
  @$pb.TagNumber(20)
  void clearReligionEn() => $_clearField(20);

  @$pb.TagNumber(21)
  $core.String get religionZh => $_getSZ(20);
  @$pb.TagNumber(21)
  set religionZh($core.String value) => $_setString(20, value);
  @$pb.TagNumber(21)
  $core.bool hasReligionZh() => $_has(20);
  @$pb.TagNumber(21)
  void clearReligionZh() => $_clearField(21);

  @$pb.TagNumber(22)
  $core.String get telephone => $_getSZ(21);
  @$pb.TagNumber(22)
  set telephone($core.String value) => $_setString(21, value);
  @$pb.TagNumber(22)
  $core.bool hasTelephone() => $_has(21);
  @$pb.TagNumber(22)
  void clearTelephone() => $_clearField(22);

  @$pb.TagNumber(23)
  $core.String get faxNumber => $_getSZ(22);
  @$pb.TagNumber(23)
  set faxNumber($core.String value) => $_setString(22, value);
  @$pb.TagNumber(23)
  $core.bool hasFaxNumber() => $_has(22);
  @$pb.TagNumber(23)
  void clearFaxNumber() => $_clearField(23);

  @$pb.TagNumber(24)
  $core.String get website => $_getSZ(23);
  @$pb.TagNumber(24)
  set website($core.String value) => $_setString(23, value);
  @$pb.TagNumber(24)
  $core.bool hasWebsite() => $_has(23);
  @$pb.TagNumber(24)
  void clearWebsite() => $_clearField(24);

  @$pb.TagNumber(25)
  $pb.PbList<$fixnum.Int64> get originalIds => $_getList(24);
}

class SchoolListResponse extends $pb.GeneratedMessage {
  factory SchoolListResponse({
    $core.Iterable<School>? schools,
  }) {
    final result = create();
    if (schools != null) result.schools.addAll(schools);
    return result;
  }

  SchoolListResponse._();

  factory SchoolListResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SchoolListResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SchoolListResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..pPM<School>(1, _omitFieldNames ? '' : 'schools',
        subBuilder: School.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchoolListResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SchoolListResponse copyWith(void Function(SchoolListResponse) updates) =>
      super.copyWith((message) => updates(message as SchoolListResponse))
          as SchoolListResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SchoolListResponse create() => SchoolListResponse._();
  @$core.override
  SchoolListResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SchoolListResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SchoolListResponse>(create);
  static SchoolListResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<School> get schools => $_getList(0);
}

class GetSchoolByIdRequest extends $pb.GeneratedMessage {
  factory GetSchoolByIdRequest({
    $fixnum.Int64? id,
  }) {
    final result = create();
    if (id != null) result.id = id;
    return result;
  }

  GetSchoolByIdRequest._();

  factory GetSchoolByIdRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory GetSchoolByIdRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GetSchoolByIdRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSchoolByIdRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GetSchoolByIdRequest copyWith(void Function(GetSchoolByIdRequest) updates) =>
      super.copyWith((message) => updates(message as GetSchoolByIdRequest))
          as GetSchoolByIdRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GetSchoolByIdRequest create() => GetSchoolByIdRequest._();
  @$core.override
  GetSchoolByIdRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static GetSchoolByIdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GetSchoolByIdRequest>(create);
  static GetSchoolByIdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);
}

class SearchRequest extends $pb.GeneratedMessage {
  factory SearchRequest({
    $core.String? keyword,
  }) {
    final result = create();
    if (keyword != null) result.keyword = keyword;
    return result;
  }

  SearchRequest._();

  factory SearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'keyword')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest))
          as SearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SearchRequest create() => SearchRequest._();
  @$core.override
  SearchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchRequest>(create);
  static SearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get keyword => $_getSZ(0);
  @$pb.TagNumber(1)
  set keyword($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasKeyword() => $_has(0);
  @$pb.TagNumber(1)
  void clearKeyword() => $_clearField(1);
}

class AdvancedSearchRequest extends $pb.GeneratedMessage {
  factory AdvancedSearchRequest({
    $core.String? name,
    $core.String? address,
    $core.String? district,
    $core.String? financeType,
    $core.String? session,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (address != null) result.address = address;
    if (district != null) result.district = district;
    if (financeType != null) result.financeType = financeType;
    if (session != null) result.session = session;
    return result;
  }

  AdvancedSearchRequest._();

  factory AdvancedSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AdvancedSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AdvancedSearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'address')
    ..aOS(3, _omitFieldNames ? '' : 'district')
    ..aOS(4, _omitFieldNames ? '' : 'financeType')
    ..aOS(5, _omitFieldNames ? '' : 'session')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancedSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AdvancedSearchRequest copyWith(
          void Function(AdvancedSearchRequest) updates) =>
      super.copyWith((message) => updates(message as AdvancedSearchRequest))
          as AdvancedSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AdvancedSearchRequest create() => AdvancedSearchRequest._();
  @$core.override
  AdvancedSearchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AdvancedSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AdvancedSearchRequest>(create);
  static AdvancedSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get address => $_getSZ(1);
  @$pb.TagNumber(2)
  set address($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAddress() => $_has(1);
  @$pb.TagNumber(2)
  void clearAddress() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get district => $_getSZ(2);
  @$pb.TagNumber(3)
  set district($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDistrict() => $_has(2);
  @$pb.TagNumber(3)
  void clearDistrict() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get financeType => $_getSZ(3);
  @$pb.TagNumber(4)
  set financeType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasFinanceType() => $_has(3);
  @$pb.TagNumber(4)
  void clearFinanceType() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get session => $_getSZ(4);
  @$pb.TagNumber(5)
  set session($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSession() => $_has(4);
  @$pb.TagNumber(5)
  void clearSession() => $_clearField(5);
}

class FilterOptionsResponse extends $pb.GeneratedMessage {
  factory FilterOptionsResponse({
    $core.Iterable<$core.String>? financeTypes,
    $core.Iterable<$core.String>? sessions,
    $core.Iterable<$core.String>? districts,
  }) {
    final result = create();
    if (financeTypes != null) result.financeTypes.addAll(financeTypes);
    if (sessions != null) result.sessions.addAll(sessions);
    if (districts != null) result.districts.addAll(districts);
    return result;
  }

  FilterOptionsResponse._();

  factory FilterOptionsResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FilterOptionsResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FilterOptionsResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'financeTypes')
    ..pPS(2, _omitFieldNames ? '' : 'sessions')
    ..pPS(3, _omitFieldNames ? '' : 'districts')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilterOptionsResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FilterOptionsResponse copyWith(
          void Function(FilterOptionsResponse) updates) =>
      super.copyWith((message) => updates(message as FilterOptionsResponse))
          as FilterOptionsResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FilterOptionsResponse create() => FilterOptionsResponse._();
  @$core.override
  FilterOptionsResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FilterOptionsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FilterOptionsResponse>(create);
  static FilterOptionsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get financeTypes => $_getList(0);

  @$pb.TagNumber(2)
  $pb.PbList<$core.String> get sessions => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get districts => $_getList(2);
}

class RangeSearchRequest extends $pb.GeneratedMessage {
  factory RangeSearchRequest({
    $core.double? userLatitude,
    $core.double? userLongitude,
    $core.double? range,
  }) {
    final result = create();
    if (userLatitude != null) result.userLatitude = userLatitude;
    if (userLongitude != null) result.userLongitude = userLongitude;
    if (range != null) result.range = range;
    return result;
  }

  RangeSearchRequest._();

  factory RangeSearchRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RangeSearchRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RangeSearchRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'userLatitude')
    ..aD(2, _omitFieldNames ? '' : 'userLongitude')
    ..aD(3, _omitFieldNames ? '' : 'range')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchRequest copyWith(void Function(RangeSearchRequest) updates) =>
      super.copyWith((message) => updates(message as RangeSearchRequest))
          as RangeSearchRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RangeSearchRequest create() => RangeSearchRequest._();
  @$core.override
  RangeSearchRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RangeSearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RangeSearchRequest>(create);
  static RangeSearchRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get userLatitude => $_getN(0);
  @$pb.TagNumber(1)
  set userLatitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUserLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get userLongitude => $_getN(1);
  @$pb.TagNumber(2)
  set userLongitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasUserLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get range => $_getN(2);
  @$pb.TagNumber(3)
  set range($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRange() => $_has(2);
  @$pb.TagNumber(3)
  void clearRange() => $_clearField(3);
}

class RangeSearchResponse extends $pb.GeneratedMessage {
  factory RangeSearchResponse({
    $core.Iterable<RangeSearchResponseDTO>? schools,
  }) {
    final result = create();
    if (schools != null) result.schools.addAll(schools);
    return result;
  }

  RangeSearchResponse._();

  factory RangeSearchResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RangeSearchResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RangeSearchResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..pPM<RangeSearchResponseDTO>(1, _omitFieldNames ? '' : 'schools',
        subBuilder: RangeSearchResponseDTO.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchResponse copyWith(void Function(RangeSearchResponse) updates) =>
      super.copyWith((message) => updates(message as RangeSearchResponse))
          as RangeSearchResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RangeSearchResponse create() => RangeSearchResponse._();
  @$core.override
  RangeSearchResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RangeSearchResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RangeSearchResponse>(create);
  static RangeSearchResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<RangeSearchResponseDTO> get schools => $_getList(0);
}

class RangeSearchResponseDTO extends $pb.GeneratedMessage {
  factory RangeSearchResponseDTO({
    School? school,
    $core.double? distance,
  }) {
    final result = create();
    if (school != null) result.school = school;
    if (distance != null) result.distance = distance;
    return result;
  }

  RangeSearchResponseDTO._();

  factory RangeSearchResponseDTO.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory RangeSearchResponseDTO.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RangeSearchResponseDTO',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aOM<School>(1, _omitFieldNames ? '' : 'school', subBuilder: School.create)
    ..aD(2, _omitFieldNames ? '' : 'distance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchResponseDTO clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RangeSearchResponseDTO copyWith(
          void Function(RangeSearchResponseDTO) updates) =>
      super.copyWith((message) => updates(message as RangeSearchResponseDTO))
          as RangeSearchResponseDTO;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RangeSearchResponseDTO create() => RangeSearchResponseDTO._();
  @$core.override
  RangeSearchResponseDTO createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static RangeSearchResponseDTO getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RangeSearchResponseDTO>(create);
  static RangeSearchResponseDTO? _defaultInstance;

  @$pb.TagNumber(1)
  School get school => $_getN(0);
  @$pb.TagNumber(1)
  set school(School value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSchool() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchool() => $_clearField(1);
  @$pb.TagNumber(1)
  School ensureSchool() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get distance => $_getN(1);
  @$pb.TagNumber(2)
  set distance($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDistance() => $_has(1);
  @$pb.TagNumber(2)
  void clearDistance() => $_clearField(2);
}

/// Favorite management
class FavoriteRequest extends $pb.GeneratedMessage {
  factory FavoriteRequest({
    $fixnum.Int64? schoolId,
  }) {
    final result = create();
    if (schoolId != null) result.schoolId = schoolId;
    return result;
  }

  FavoriteRequest._();

  factory FavoriteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavoriteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavoriteRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'schoolId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoriteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavoriteRequest copyWith(void Function(FavoriteRequest) updates) =>
      super.copyWith((message) => updates(message as FavoriteRequest))
          as FavoriteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavoriteRequest create() => FavoriteRequest._();
  @$core.override
  FavoriteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavoriteRequest>(create);
  static FavoriteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get schoolId => $_getI64(0);
  @$pb.TagNumber(1)
  set schoolId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasSchoolId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSchoolId() => $_clearField(1);
}

/// Map state persistence
class MapState extends $pb.GeneratedMessage {
  factory MapState({
    $core.double? centerLatitude,
    $core.double? centerLongitude,
    $core.double? zoomLevel,
  }) {
    final result = create();
    if (centerLatitude != null) result.centerLatitude = centerLatitude;
    if (centerLongitude != null) result.centerLongitude = centerLongitude;
    if (zoomLevel != null) result.zoomLevel = zoomLevel;
    return result;
  }

  MapState._();

  factory MapState.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory MapState.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'MapState',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'centerLatitude')
    ..aD(2, _omitFieldNames ? '' : 'centerLongitude')
    ..aD(3, _omitFieldNames ? '' : 'zoomLevel')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MapState clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MapState copyWith(void Function(MapState) updates) =>
      super.copyWith((message) => updates(message as MapState)) as MapState;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MapState create() => MapState._();
  @$core.override
  MapState createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static MapState getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MapState>(create);
  static MapState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get centerLatitude => $_getN(0);
  @$pb.TagNumber(1)
  set centerLatitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCenterLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearCenterLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get centerLongitude => $_getN(1);
  @$pb.TagNumber(2)
  set centerLongitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasCenterLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearCenterLongitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get zoomLevel => $_getN(2);
  @$pb.TagNumber(3)
  set zoomLevel($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasZoomLevel() => $_has(2);
  @$pb.TagNumber(3)
  void clearZoomLevel() => $_clearField(3);
}

/// User settings
class UserSettings extends $pb.GeneratedMessage {
  factory UserSettings({
    $core.String? language,
    $core.String? themeMode,
    $core.String? colorSeed,
  }) {
    final result = create();
    if (language != null) result.language = language;
    if (themeMode != null) result.themeMode = themeMode;
    if (colorSeed != null) result.colorSeed = colorSeed;
    return result;
  }

  UserSettings._();

  factory UserSettings.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UserSettings.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UserSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'school'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'language')
    ..aOS(2, _omitFieldNames ? '' : 'themeMode')
    ..aOS(3, _omitFieldNames ? '' : 'colorSeed')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UserSettings copyWith(void Function(UserSettings) updates) =>
      super.copyWith((message) => updates(message as UserSettings))
          as UserSettings;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserSettings create() => UserSettings._();
  @$core.override
  UserSettings createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UserSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UserSettings>(create);
  static UserSettings? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get language => $_getSZ(0);
  @$pb.TagNumber(1)
  set language($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLanguage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLanguage() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get themeMode => $_getSZ(1);
  @$pb.TagNumber(2)
  set themeMode($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasThemeMode() => $_has(1);
  @$pb.TagNumber(2)
  void clearThemeMode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get colorSeed => $_getSZ(2);
  @$pb.TagNumber(3)
  set colorSeed($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasColorSeed() => $_has(2);
  @$pb.TagNumber(3)
  void clearColorSeed() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
