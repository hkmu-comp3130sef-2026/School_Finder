// This is a generated file - do not edit.
//
// Generated from school.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use schoolDescriptor instead')
const School$json = {
  '1': 'School',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'original_ids', '3': 25, '4': 3, '5': 3, '10': 'originalIds'},
    {'1': 'name_en', '3': 2, '4': 1, '5': 9, '10': 'nameEn'},
    {'1': 'name_zh', '3': 3, '4': 1, '5': 9, '10': 'nameZh'},
    {'1': 'address_en', '3': 4, '4': 1, '5': 9, '10': 'addressEn'},
    {'1': 'address_zh', '3': 5, '4': 1, '5': 9, '10': 'addressZh'},
    {'1': 'latitude', '3': 6, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 7, '4': 1, '5': 1, '10': 'longitude'},
    {'1': 'district_en', '3': 8, '4': 1, '5': 9, '10': 'districtEn'},
    {'1': 'district_zh', '3': 9, '4': 1, '5': 9, '10': 'districtZh'},
    {'1': 'finance_types_en', '3': 10, '4': 3, '5': 9, '10': 'financeTypesEn'},
    {'1': 'finance_types_zh', '3': 11, '4': 3, '5': 9, '10': 'financeTypesZh'},
    {'1': 'school_level_en', '3': 12, '4': 1, '5': 9, '10': 'schoolLevelEn'},
    {'1': 'school_level_zh', '3': 13, '4': 1, '5': 9, '10': 'schoolLevelZh'},
    {'1': 'category_en', '3': 14, '4': 1, '5': 9, '10': 'categoryEn'},
    {'1': 'category_zh', '3': 15, '4': 1, '5': 9, '10': 'categoryZh'},
    {
      '1': 'student_gender_en',
      '3': 16,
      '4': 1,
      '5': 9,
      '10': 'studentGenderEn'
    },
    {
      '1': 'student_gender_zh',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'studentGenderZh'
    },
    {'1': 'sessions_en', '3': 18, '4': 3, '5': 9, '10': 'sessionsEn'},
    {'1': 'sessions_zh', '3': 19, '4': 3, '5': 9, '10': 'sessionsZh'},
    {'1': 'religion_en', '3': 20, '4': 1, '5': 9, '10': 'religionEn'},
    {'1': 'religion_zh', '3': 21, '4': 1, '5': 9, '10': 'religionZh'},
    {'1': 'telephone', '3': 22, '4': 1, '5': 9, '10': 'telephone'},
    {'1': 'fax_number', '3': 23, '4': 1, '5': 9, '10': 'faxNumber'},
    {'1': 'website', '3': 24, '4': 1, '5': 9, '10': 'website'},
  ],
};

/// Descriptor for `School`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schoolDescriptor = $convert.base64Decode(
    'CgZTY2hvb2wSDgoCaWQYASABKANSAmlkEiEKDG9yaWdpbmFsX2lkcxgZIAMoA1ILb3JpZ2luYW'
    'xJZHMSFwoHbmFtZV9lbhgCIAEoCVIGbmFtZUVuEhcKB25hbWVfemgYAyABKAlSBm5hbWVaaBId'
    'CgphZGRyZXNzX2VuGAQgASgJUglhZGRyZXNzRW4SHQoKYWRkcmVzc196aBgFIAEoCVIJYWRkcm'
    'Vzc1poEhoKCGxhdGl0dWRlGAYgASgBUghsYXRpdHVkZRIcCglsb25naXR1ZGUYByABKAFSCWxv'
    'bmdpdHVkZRIfCgtkaXN0cmljdF9lbhgIIAEoCVIKZGlzdHJpY3RFbhIfCgtkaXN0cmljdF96aB'
    'gJIAEoCVIKZGlzdHJpY3RaaBIoChBmaW5hbmNlX3R5cGVzX2VuGAogAygJUg5maW5hbmNlVHlw'
    'ZXNFbhIoChBmaW5hbmNlX3R5cGVzX3poGAsgAygJUg5maW5hbmNlVHlwZXNaaBImCg9zY2hvb2'
    'xfbGV2ZWxfZW4YDCABKAlSDXNjaG9vbExldmVsRW4SJgoPc2Nob29sX2xldmVsX3poGA0gASgJ'
    'Ug1zY2hvb2xMZXZlbFpoEh8KC2NhdGVnb3J5X2VuGA4gASgJUgpjYXRlZ29yeUVuEh8KC2NhdG'
    'Vnb3J5X3poGA8gASgJUgpjYXRlZ29yeVpoEioKEXN0dWRlbnRfZ2VuZGVyX2VuGBAgASgJUg9z'
    'dHVkZW50R2VuZGVyRW4SKgoRc3R1ZGVudF9nZW5kZXJfemgYESABKAlSD3N0dWRlbnRHZW5kZX'
    'JaaBIfCgtzZXNzaW9uc19lbhgSIAMoCVIKc2Vzc2lvbnNFbhIfCgtzZXNzaW9uc196aBgTIAMo'
    'CVIKc2Vzc2lvbnNaaBIfCgtyZWxpZ2lvbl9lbhgUIAEoCVIKcmVsaWdpb25FbhIfCgtyZWxpZ2'
    'lvbl96aBgVIAEoCVIKcmVsaWdpb25aaBIcCgl0ZWxlcGhvbmUYFiABKAlSCXRlbGVwaG9uZRId'
    'CgpmYXhfbnVtYmVyGBcgASgJUglmYXhOdW1iZXISGAoHd2Vic2l0ZRgYIAEoCVIHd2Vic2l0ZQ'
    '==');

@$core.Deprecated('Use schoolListResponseDescriptor instead')
const SchoolListResponse$json = {
  '1': 'SchoolListResponse',
  '2': [
    {
      '1': 'schools',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.school.School',
      '10': 'schools'
    },
  ],
};

/// Descriptor for `SchoolListResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List schoolListResponseDescriptor = $convert.base64Decode(
    'ChJTY2hvb2xMaXN0UmVzcG9uc2USKAoHc2Nob29scxgBIAMoCzIOLnNjaG9vbC5TY2hvb2xSB3'
    'NjaG9vbHM=');

@$core.Deprecated('Use getSchoolByIdRequestDescriptor instead')
const GetSchoolByIdRequest$json = {
  '1': 'GetSchoolByIdRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
  ],
};

/// Descriptor for `GetSchoolByIdRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List getSchoolByIdRequestDescriptor = $convert
    .base64Decode('ChRHZXRTY2hvb2xCeUlkUmVxdWVzdBIOCgJpZBgBIAEoA1ICaWQ=');

@$core.Deprecated('Use searchRequestDescriptor instead')
const SearchRequest$json = {
  '1': 'SearchRequest',
  '2': [
    {'1': 'keyword', '3': 1, '4': 1, '5': 9, '10': 'keyword'},
  ],
};

/// Descriptor for `SearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List searchRequestDescriptor = $convert
    .base64Decode('Cg1TZWFyY2hSZXF1ZXN0EhgKB2tleXdvcmQYASABKAlSB2tleXdvcmQ=');

@$core.Deprecated('Use advancedSearchRequestDescriptor instead')
const AdvancedSearchRequest$json = {
  '1': 'AdvancedSearchRequest',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    {'1': 'address', '3': 2, '4': 1, '5': 9, '10': 'address'},
    {'1': 'district', '3': 3, '4': 1, '5': 9, '10': 'district'},
    {'1': 'finance_type', '3': 4, '4': 1, '5': 9, '10': 'financeType'},
    {'1': 'session', '3': 5, '4': 1, '5': 9, '10': 'session'},
  ],
};

/// Descriptor for `AdvancedSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List advancedSearchRequestDescriptor = $convert.base64Decode(
    'ChVBZHZhbmNlZFNlYXJjaFJlcXVlc3QSEgoEbmFtZRgBIAEoCVIEbmFtZRIYCgdhZGRyZXNzGA'
    'IgASgJUgdhZGRyZXNzEhoKCGRpc3RyaWN0GAMgASgJUghkaXN0cmljdBIhCgxmaW5hbmNlX3R5'
    'cGUYBCABKAlSC2ZpbmFuY2VUeXBlEhgKB3Nlc3Npb24YBSABKAlSB3Nlc3Npb24=');

@$core.Deprecated('Use filterOptionsResponseDescriptor instead')
const FilterOptionsResponse$json = {
  '1': 'FilterOptionsResponse',
  '2': [
    {'1': 'finance_types', '3': 1, '4': 3, '5': 9, '10': 'financeTypes'},
    {'1': 'sessions', '3': 2, '4': 3, '5': 9, '10': 'sessions'},
    {'1': 'districts', '3': 3, '4': 3, '5': 9, '10': 'districts'},
  ],
};

/// Descriptor for `FilterOptionsResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List filterOptionsResponseDescriptor = $convert.base64Decode(
    'ChVGaWx0ZXJPcHRpb25zUmVzcG9uc2USIwoNZmluYW5jZV90eXBlcxgBIAMoCVIMZmluYW5jZV'
    'R5cGVzEhoKCHNlc3Npb25zGAIgAygJUghzZXNzaW9ucxIcCglkaXN0cmljdHMYAyADKAlSCWRp'
    'c3RyaWN0cw==');

@$core.Deprecated('Use rangeSearchRequestDescriptor instead')
const RangeSearchRequest$json = {
  '1': 'RangeSearchRequest',
  '2': [
    {'1': 'user_latitude', '3': 1, '4': 1, '5': 1, '10': 'userLatitude'},
    {'1': 'user_longitude', '3': 2, '4': 1, '5': 1, '10': 'userLongitude'},
    {'1': 'range', '3': 3, '4': 1, '5': 1, '10': 'range'},
  ],
};

/// Descriptor for `RangeSearchRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rangeSearchRequestDescriptor = $convert.base64Decode(
    'ChJSYW5nZVNlYXJjaFJlcXVlc3QSIwoNdXNlcl9sYXRpdHVkZRgBIAEoAVIMdXNlckxhdGl0dW'
    'RlEiUKDnVzZXJfbG9uZ2l0dWRlGAIgASgBUg11c2VyTG9uZ2l0dWRlEhQKBXJhbmdlGAMgASgB'
    'UgVyYW5nZQ==');

@$core.Deprecated('Use rangeSearchResponseDescriptor instead')
const RangeSearchResponse$json = {
  '1': 'RangeSearchResponse',
  '2': [
    {
      '1': 'schools',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.school.RangeSearchResponseDTO',
      '10': 'schools'
    },
  ],
};

/// Descriptor for `RangeSearchResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rangeSearchResponseDescriptor = $convert.base64Decode(
    'ChNSYW5nZVNlYXJjaFJlc3BvbnNlEjgKB3NjaG9vbHMYASADKAsyHi5zY2hvb2wuUmFuZ2VTZW'
    'FyY2hSZXNwb25zZURUT1IHc2Nob29scw==');

@$core.Deprecated('Use rangeSearchResponseDTODescriptor instead')
const RangeSearchResponseDTO$json = {
  '1': 'RangeSearchResponseDTO',
  '2': [
    {
      '1': 'school',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.school.School',
      '10': 'school'
    },
    {'1': 'distance', '3': 2, '4': 1, '5': 1, '10': 'distance'},
  ],
};

/// Descriptor for `RangeSearchResponseDTO`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List rangeSearchResponseDTODescriptor =
    $convert.base64Decode(
        'ChZSYW5nZVNlYXJjaFJlc3BvbnNlRFRPEiYKBnNjaG9vbBgBIAEoCzIOLnNjaG9vbC5TY2hvb2'
        'xSBnNjaG9vbBIaCghkaXN0YW5jZRgCIAEoAVIIZGlzdGFuY2U=');

@$core.Deprecated('Use favoriteRequestDescriptor instead')
const FavoriteRequest$json = {
  '1': 'FavoriteRequest',
  '2': [
    {'1': 'school_id', '3': 1, '4': 1, '5': 3, '10': 'schoolId'},
  ],
};

/// Descriptor for `FavoriteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favoriteRequestDescriptor = $convert.base64Decode(
    'Cg9GYXZvcml0ZVJlcXVlc3QSGwoJc2Nob29sX2lkGAEgASgDUghzY2hvb2xJZA==');

@$core.Deprecated('Use mapStateDescriptor instead')
const MapState$json = {
  '1': 'MapState',
  '2': [
    {'1': 'center_latitude', '3': 1, '4': 1, '5': 1, '10': 'centerLatitude'},
    {'1': 'center_longitude', '3': 2, '4': 1, '5': 1, '10': 'centerLongitude'},
    {'1': 'zoom_level', '3': 3, '4': 1, '5': 1, '10': 'zoomLevel'},
  ],
};

/// Descriptor for `MapState`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List mapStateDescriptor = $convert.base64Decode(
    'CghNYXBTdGF0ZRInCg9jZW50ZXJfbGF0aXR1ZGUYASABKAFSDmNlbnRlckxhdGl0dWRlEikKEG'
    'NlbnRlcl9sb25naXR1ZGUYAiABKAFSD2NlbnRlckxvbmdpdHVkZRIdCgp6b29tX2xldmVsGAMg'
    'ASgBUgl6b29tTGV2ZWw=');

@$core.Deprecated('Use userSettingsDescriptor instead')
const UserSettings$json = {
  '1': 'UserSettings',
  '2': [
    {'1': 'language', '3': 1, '4': 1, '5': 9, '10': 'language'},
    {'1': 'theme_mode', '3': 2, '4': 1, '5': 9, '10': 'themeMode'},
    {'1': 'color_seed', '3': 3, '4': 1, '5': 9, '10': 'colorSeed'},
  ],
};

/// Descriptor for `UserSettings`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List userSettingsDescriptor = $convert.base64Decode(
    'CgxVc2VyU2V0dGluZ3MSGgoIbGFuZ3VhZ2UYASABKAlSCGxhbmd1YWdlEh0KCnRoZW1lX21vZG'
    'UYAiABKAlSCXRoZW1lTW9kZRIdCgpjb2xvcl9zZWVkGAMgASgJUgljb2xvclNlZWQ=');
