// This is a generated file - do not edit.
//
// Generated from bridge.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Defines all actions that the frontend can trigger
class Action extends $pb.ProtobufEnum {
  static const Action ACTION_UNSPECIFIED =
      Action._(0, _omitEnumNames ? '' : 'ACTION_UNSPECIFIED');

  /// Home Page Actions
  static const Action ACTION_GET_NEARBY_SCHOOLS =
      Action._(1, _omitEnumNames ? '' : 'ACTION_GET_NEARBY_SCHOOLS');

  /// Favorites Page Actions
  static const Action ACTION_GET_FAVORITE_SCHOOLS =
      Action._(2, _omitEnumNames ? '' : 'ACTION_GET_FAVORITE_SCHOOLS');
  static const Action ACTION_ADD_FAVORITE =
      Action._(3, _omitEnumNames ? '' : 'ACTION_ADD_FAVORITE');
  static const Action ACTION_REMOVE_FAVORITE =
      Action._(4, _omitEnumNames ? '' : 'ACTION_REMOVE_FAVORITE');
  static const Action ACTION_SAVE_MAP_STATE =
      Action._(5, _omitEnumNames ? '' : 'ACTION_SAVE_MAP_STATE');
  static const Action ACTION_GET_MAP_STATE =
      Action._(6, _omitEnumNames ? '' : 'ACTION_GET_MAP_STATE');

  /// Search Page Actions
  static const Action ACTION_SEARCH_BASIC =
      Action._(7, _omitEnumNames ? '' : 'ACTION_SEARCH_BASIC');
  static const Action ACTION_SEARCH_ADVANCED =
      Action._(8, _omitEnumNames ? '' : 'ACTION_SEARCH_ADVANCED');
  static const Action ACTION_GET_FILTER_OPTIONS =
      Action._(12, _omitEnumNames ? '' : 'ACTION_GET_FILTER_OPTIONS');

  /// Details Page
  static const Action ACTION_GET_SCHOOL_DETAILS =
      Action._(9, _omitEnumNames ? '' : 'ACTION_GET_SCHOOL_DETAILS');

  /// Settings
  static const Action ACTION_UPDATE_SETTINGS =
      Action._(10, _omitEnumNames ? '' : 'ACTION_UPDATE_SETTINGS');
  static const Action ACTION_GET_SETTINGS =
      Action._(11, _omitEnumNames ? '' : 'ACTION_GET_SETTINGS');
  static const Action ACTION_RELOAD_DATA =
      Action._(13, _omitEnumNames ? '' : 'ACTION_RELOAD_DATA');
  static const Action ACTION_SET_DEBUG_MODE =
      Action._(14, _omitEnumNames ? '' : 'ACTION_SET_DEBUG_MODE');

  static const $core.List<Action> values = <Action>[
    ACTION_UNSPECIFIED,
    ACTION_GET_NEARBY_SCHOOLS,
    ACTION_GET_FAVORITE_SCHOOLS,
    ACTION_ADD_FAVORITE,
    ACTION_REMOVE_FAVORITE,
    ACTION_SAVE_MAP_STATE,
    ACTION_GET_MAP_STATE,
    ACTION_SEARCH_BASIC,
    ACTION_SEARCH_ADVANCED,
    ACTION_GET_FILTER_OPTIONS,
    ACTION_GET_SCHOOL_DETAILS,
    ACTION_UPDATE_SETTINGS,
    ACTION_GET_SETTINGS,
    ACTION_RELOAD_DATA,
    ACTION_SET_DEBUG_MODE,
  ];

  static final $core.List<Action?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 14);
  static Action? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Action._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
