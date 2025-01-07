// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/rpc.dart';

class UUID extends rpc_uuid_t {
  static final int codeUnitZero = '0'.codeUnitAt(0);
  static final int codeUnitBigA = 'A'.codeUnitAt(0);
  static final int codeUnitSmallA = 'a'.codeUnitAt(0);

  static int _hex_to_bin(String arr, int offset, int length) {
    int value = 0;
    int ai, count;

    count = 0;
    for (ai = offset; ai < arr.length && count < length; ai++) {
      value <<= 4;
      switch (arr[ai]) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
          value += arr.codeUnitAt(ai) - codeUnitZero;
          break;
        case 'A':
        case 'B':
        case 'C':
        case 'D':
        case 'E':
        case 'F':
          value += 10 + arr.codeUnitAt(ai) - codeUnitBigA;
          break;
        case 'a':
        case 'b':
        case 'c':
        case 'd':
        case 'e':
        case 'f':
          value += 10 + arr.codeUnitAt(ai) - codeUnitSmallA;
          break;
        default:
          throw SmbIllegalArgumentException(arr.substring(offset, length));
      }
      count++;
    }

    return value;
  }

  static final List<String> HEXCHARS = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F'
  ];

  static String _bin_to_hex(int value, int length) {
    String res = "";
    int ai = length;
    while (ai-- > 0) {
      res = HEXCHARS[value & 0xF] + res;
      value >>>= 4;
    }
    return res;
  }

  static int _B(int i) {
    return (i & 0xFF);
  }

  static int _S(int i) {
    return (i & 0xFFFF);
  }

  // UUID.uuid(rpc_uuid_t uuid) {
  //   time_low = uuid.time_low;
  //   time_mid = uuid.time_mid;
  //   time_hi_and_version = uuid.time_hi_and_version;
  //   clock_seq_hi_and_reserved = uuid.clock_seq_hi_and_reserved;
  //   clock_seq_low = uuid.clock_seq_low;
  //   node = Uint8List(6);
  //   node![0] = uuid.node![0];
  //   node![1] = uuid.node![1];
  //   node![2] = uuid.node![2];
  //   node![3] = uuid.node![3];
  //   node![4] = uuid.node![4];
  //   node![5] = uuid.node![5];
  // }

  /// Construct a UUID from string
  UUID.str(String str) {
    var arr = str;
    time_low = _hex_to_bin(arr, 0, 8);
    time_mid = _S(_hex_to_bin(arr, 9, 4));
    time_hi_and_version = _S(_hex_to_bin(arr, 14, 4));
    clock_seq_hi_and_reserved = _B(_hex_to_bin(arr, 19, 2));
    clock_seq_low = _B(_hex_to_bin(arr, 21, 2));
    node = Uint8List(6);
    node![0] = _B(_hex_to_bin(arr, 24, 2));
    node![1] = _B(_hex_to_bin(arr, 26, 2));
    node![2] = _B(_hex_to_bin(arr, 28, 2));
    node![3] = _B(_hex_to_bin(arr, 30, 2));
    node![4] = _B(_hex_to_bin(arr, 32, 2));
    node![5] = _B(_hex_to_bin(arr, 34, 2));
  }

  @override
  String toString() {
    return _bin_to_hex(time_low, 8) +
        '-' +
        _bin_to_hex(time_mid, 4) +
        '-' +
        _bin_to_hex(time_hi_and_version, 4) +
        '-' +
        _bin_to_hex(clock_seq_hi_and_reserved, 2) +
        _bin_to_hex(clock_seq_low, 2) +
        '-' +
        _bin_to_hex(node![0], 2) +
        _bin_to_hex(node![1], 2) +
        _bin_to_hex(node![2], 2) +
        _bin_to_hex(node![3], 2) +
        _bin_to_hex(node![4], 2) +
        _bin_to_hex(node![5], 2);
  }
}
