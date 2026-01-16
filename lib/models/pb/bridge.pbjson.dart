// This is a generated file - do not edit.
//
// Generated from bridge.proto.

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

@$core.Deprecated('Use actionDescriptor instead')
const Action$json = {
  '1': 'Action',
  '2': [
    {'1': 'ACTION_UNSPECIFIED', '2': 0},
    {'1': 'ACTION_GET_NEARBY_SCHOOLS', '2': 1},
    {'1': 'ACTION_GET_FAVORITE_SCHOOLS', '2': 2},
    {'1': 'ACTION_ADD_FAVORITE', '2': 3},
    {'1': 'ACTION_REMOVE_FAVORITE', '2': 4},
    {'1': 'ACTION_SAVE_MAP_STATE', '2': 5},
    {'1': 'ACTION_GET_MAP_STATE', '2': 6},
    {'1': 'ACTION_SEARCH_BASIC', '2': 7},
    {'1': 'ACTION_SEARCH_ADVANCED', '2': 8},
    {'1': 'ACTION_GET_FILTER_OPTIONS', '2': 12},
    {'1': 'ACTION_GET_SCHOOL_DETAILS', '2': 9},
    {'1': 'ACTION_UPDATE_SETTINGS', '2': 10},
    {'1': 'ACTION_GET_SETTINGS', '2': 11},
    {'1': 'ACTION_RELOAD_DATA', '2': 13},
    {'1': 'ACTION_SET_DEBUG_MODE', '2': 14},
  ],
};

/// Descriptor for `Action`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List actionDescriptor = $convert.base64Decode(
    'CgZBY3Rpb24SFgoSQUNUSU9OX1VOU1BFQ0lGSUVEEAASHQoZQUNUSU9OX0dFVF9ORUFSQllfU0'
    'NIT09MUxABEh8KG0FDVElPTl9HRVRfRkFWT1JJVEVfU0NIT09MUxACEhcKE0FDVElPTl9BRERf'
    'RkFWT1JJVEUQAxIaChZBQ1RJT05fUkVNT1ZFX0ZBVk9SSVRFEAQSGQoVQUNUSU9OX1NBVkVfTU'
    'FQX1NUQVRFEAUSGAoUQUNUSU9OX0dFVF9NQVBfU1RBVEUQBhIXChNBQ1RJT05fU0VBUkNIX0JB'
    'U0lDEAcSGgoWQUNUSU9OX1NFQVJDSF9BRFZBTkNFRBAIEh0KGUFDVElPTl9HRVRfRklMVEVSX0'
    '9QVElPTlMQDBIdChlBQ1RJT05fR0VUX1NDSE9PTF9ERVRBSUxTEAkSGgoWQUNUSU9OX1VQREFU'
    'RV9TRVRUSU5HUxAKEhcKE0FDVElPTl9HRVRfU0VUVElOR1MQCxIWChJBQ1RJT05fUkVMT0FEX0'
    'RBVEEQDRIZChVBQ1RJT05fU0VUX0RFQlVHX01PREUQDg==');

@$core.Deprecated('Use setDebugModeRequestDescriptor instead')
const SetDebugModeRequest$json = {
  '1': 'SetDebugModeRequest',
  '2': [
    {'1': 'enabled', '3': 1, '4': 1, '5': 8, '10': 'enabled'},
  ],
};

/// Descriptor for `SetDebugModeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List setDebugModeRequestDescriptor =
    $convert.base64Decode(
        'ChNTZXREZWJ1Z01vZGVSZXF1ZXN0EhgKB2VuYWJsZWQYASABKAhSB2VuYWJsZWQ=');

@$core.Deprecated('Use requestEnvelopeDescriptor instead')
const RequestEnvelope$json = {
  '1': 'RequestEnvelope',
  '2': [
    {
      '1': 'action',
      '3': 1,
      '4': 1,
      '5': 14,
      '6': '.bridge.Action',
      '10': 'action'
    },
    {'1': 'payload', '3': 2, '4': 1, '5': 12, '10': 'payload'},
  ],
};

/// Descriptor for `RequestEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List requestEnvelopeDescriptor = $convert.base64Decode(
    'Cg9SZXF1ZXN0RW52ZWxvcGUSJgoGYWN0aW9uGAEgASgOMg4uYnJpZGdlLkFjdGlvblIGYWN0aW'
    '9uEhgKB3BheWxvYWQYAiABKAxSB3BheWxvYWQ=');

@$core.Deprecated('Use responseEnvelopeDescriptor instead')
const ResponseEnvelope$json = {
  '1': 'ResponseEnvelope',
  '2': [
    {'1': 'success', '3': 1, '4': 1, '5': 8, '10': 'success'},
    {'1': 'error', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'error', '17': true},
    {'1': 'payload', '3': 3, '4': 1, '5': 12, '10': 'payload'},
  ],
  '8': [
    {'1': '_error'},
  ],
};

/// Descriptor for `ResponseEnvelope`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List responseEnvelopeDescriptor = $convert.base64Decode(
    'ChBSZXNwb25zZUVudmVsb3BlEhgKB3N1Y2Nlc3MYASABKAhSB3N1Y2Nlc3MSGQoFZXJyb3IYAi'
    'ABKAlIAFIFZXJyb3KIAQESGAoHcGF5bG9hZBgDIAEoDFIHcGF5bG9hZEIICgZfZXJyb3I=');
