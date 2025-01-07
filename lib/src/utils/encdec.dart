import 'dart:convert';
import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/smb_constants.dart';

class Encdec {
  static const int SEC_BETWEEEN_1904_AND_1970 = 2082844800;
  static const int TIME_1970_SEC_32BE = 1;
  static const int TIME_1970_SEC_32LE = 2;
  static const int TIME_1904_SEC_32BE = 3;
  static const int TIME_1904_SEC_32LE = 4;
  static const int TIME_1601_NANOS_64LE = 5;
  static const int TIME_1601_NANOS_64BE = 6;
  static const int TIME_1970_MILLIS_64BE = 7;
  static const int TIME_1970_MILLIS_64LE = 8;

  // private Encdec () {}

  /*
     * Encode integers
     */

  static int enc_uint16be(int s, Uint8List dst, int di) {
    dst[di++] = ((s >> 8) & 0xFF);
    dst[di] = (s & 0xFF);
    return 2;
  }

  static int enc_uint32be(int i, Uint8List dst, int di) {
    dst[di++] = ((i >> 24) & 0xFF);
    dst[di++] = ((i >> 16) & 0xFF);
    dst[di++] = ((i >> 8) & 0xFF);
    dst[di] = (i & 0xFF);
    return 4;
  }

  static int enc_uint16le(int s, Uint8List dst, int di) {
    dst[di++] = (s & 0xFF);
    dst[di] = ((s >> 8) & 0xFF);
    return 2;
  }

  static int enc_uint32le(int i, Uint8List dst, int di) {
    dst[di++] = (i & 0xFF);
    dst[di++] = ((i >> 8) & 0xFF);
    dst[di++] = ((i >> 16) & 0xFF);
    dst[di] = ((i >> 24) & 0xFF);
    return 4;
  }

  /*
     * Decode integers
     */

  static int dec_uint16be(Uint8List src, int si) {
    return (((src[si] & 0xFF) << 8) | (src[si + 1] & 0xFF));
  }

  static int dec_uint32be(Uint8List src, int si) {
    return ((src[si] & 0xFF) << 24) |
        ((src[si + 1] & 0xFF) << 16) |
        ((src[si + 2] & 0xFF) << 8) |
        (src[si + 3] & 0xFF);
  }

  static int dec_uint16le(Uint8List src, int si) {
    return ((src[si] & 0xFF) | ((src[si + 1] & 0xFF) << 8));
  }

  static int dec_uint32le(Uint8List src, int si) {
    return (src[si] & 0xFF) |
        ((src[si + 1] & 0xFF) << 8) |
        ((src[si + 2] & 0xFF) << 16) |
        ((src[si + 3] & 0xFF) << 24);
  }

  /*
     * Encode and decode 64 bit integers
     */

  static int enc_uint64be(int l, Uint8List dst, int di) {
    enc_uint32be((l & 0xFFFFFFFF), dst, di + 4);
    enc_uint32be(((l >> 32) & 0xFFFFFFFF), dst, di);
    return 8;
  }

  static int enc_uint64le(int l, Uint8List dst, int di) {
    enc_uint32le((l & 0xFFFFFFFF), dst, di);
    enc_uint32le(((l >> 32) & 0xFFFFFFFF), dst, di + 4);
    return 8;
  }

  static int dec_uint64be(Uint8List src, int si) {
    int l;
    l = dec_uint32be(src, si) & 0xFFFFFFFF;
    l <<= 32;
    l |= dec_uint32be(src, si + 4) & 0xFFFFFFFF;
    return l;
  }

  static int dec_uint64le(Uint8List src, int si) {
    int l;
    l = dec_uint32le(src, si + 4) & 0xFFFFFFFF;
    l <<= 32;
    l |= dec_uint32le(src, si) & 0xFFFFFFFF;
    return l;
  }

  /*
     * Encode floats
     */

  static int enc_floatle(double f, Uint8List dst, int di) {
    var buff = ByteData(4);
    buff.setFloat32(0, f);
    return enc_uint32le(buff.getInt32(0), dst, di); //Float.floatToIntBits(f)
  }

  static int enc_floatbe(double f, Uint8List dst, int di) {
    var buff = ByteData(4);
    buff.setFloat32(0, f);
    return enc_uint32be(buff.getUint32(0), dst, di); //Float.floatToIntBits(f)
  }

  /*
     * Decode floating point numbers
     */

  static double dec_floatle(Uint8List src, int si) {
    var buff = ByteData.view(src.buffer, si, 4);
    return buff.getFloat32(
        0, Endian.little); // Float.intBitsToFloat(dec_uint32le(src, si));
  }

  static double dec_floatbe(Uint8List src, int si) {
    var buff = ByteData.view(src.buffer, si, 4);
    return buff.getFloat32(
        0, Endian.big); //Float.intBitsToFloat(dec_uint32be(src, si));
  }

  /*
     * Encode and decode doubles
     */

  static int enc_doublele(double d, Uint8List dst, int di) {
    var buff = ByteData(8);
    buff.setFloat64(0, d);
    return enc_uint64le(buff.getInt64(0), dst, di); //Double.doubleToLongBits(d)
  }

  static int enc_doublebe(double d, Uint8List dst, int di) {
    var buff = ByteData(8);
    buff.setFloat64(0, d);
    return enc_uint64be(buff.getInt64(0), dst, di); //Double.doubleToLongBits(d)
  }

  static double dec_doublele(Uint8List src, int si) {
    var buff = ByteData.view(src.buffer, si, 8);
    return buff.getFloat64(
        0, Endian.little); //Double.longBitsToDouble(dec_uint64le(src, si));
  }

  static double dec_doublebe(Uint8List src, int si) {
    var buff = ByteData.view(src.buffer, si, 8);
    return buff.getFloat64(
        0, Endian.big); //Double.longBitsToDouble(dec_uint64be(src, si));
  }

  /*
     * Encode times
     */

  static int enc_time(DateTime date, Uint8List dst, int di, int enc) {
    int t;

    switch (enc) {
      case TIME_1970_SEC_32BE:
        return enc_uint32be((date.millisecondsSinceEpoch ~/ 1000), dst, di);
      case TIME_1970_SEC_32LE:
        return enc_uint32le((date.millisecondsSinceEpoch ~/ 1000), dst, di);
      case TIME_1904_SEC_32BE:
        return enc_uint32be(
            ((date.millisecondsSinceEpoch ~/ 1000 +
                    SEC_BETWEEEN_1904_AND_1970) &
                0xFFFFFFFF),
            dst,
            di);
      case TIME_1904_SEC_32LE:
        return enc_uint32le(
            ((date.millisecondsSinceEpoch ~/ 1000 +
                    SEC_BETWEEEN_1904_AND_1970) &
                0xFFFFFFFF),
            dst,
            di);
      case TIME_1601_NANOS_64BE:
        t = (date.millisecondsSinceEpoch +
                SmbConstants.MILLISECONDS_BETWEEN_1970_AND_1601) *
            10000;
        return enc_uint64be(t, dst, di);
      case TIME_1601_NANOS_64LE:
        t = (date.millisecondsSinceEpoch +
                SmbConstants.MILLISECONDS_BETWEEN_1970_AND_1601) *
            10000;
        return enc_uint64le(t, dst, di);
      case TIME_1970_MILLIS_64BE:
        return enc_uint64be(date.millisecondsSinceEpoch, dst, di);
      case TIME_1970_MILLIS_64LE:
        return enc_uint64le(date.millisecondsSinceEpoch, dst, di);
      default:
        throw SmbIllegalArgumentException("Unsupported time encoding");
    }
  }

  /*
     * Decode times
     */

  static DateTime dec_time(Uint8List src, int si, int enc) {
    int t;

    switch (enc) {
      case TIME_1970_SEC_32BE:
        return DateTime.fromMillisecondsSinceEpoch(
            dec_uint32be(src, si) * 1000);
      case TIME_1970_SEC_32LE:
        return DateTime.fromMillisecondsSinceEpoch(
            dec_uint32le(src, si) * 1000);
      case TIME_1904_SEC_32BE:
        return DateTime.fromMillisecondsSinceEpoch(
            ((dec_uint32be(src, si) & 0xFFFFFFFF) -
                    SEC_BETWEEEN_1904_AND_1970) *
                1000);
      case TIME_1904_SEC_32LE:
        return DateTime.fromMillisecondsSinceEpoch(
            ((dec_uint32le(src, si) & 0xFFFFFFFF) -
                    SEC_BETWEEEN_1904_AND_1970) *
                1000);
      case TIME_1601_NANOS_64BE:
        t = dec_uint64be(src, si);
        return DateTime.fromMillisecondsSinceEpoch(
            t ~/ 10000 - SmbConstants.MILLISECONDS_BETWEEN_1970_AND_1601);
      case TIME_1601_NANOS_64LE:
        t = dec_uint64le(src, si);
        return DateTime.fromMillisecondsSinceEpoch(
            t ~/ 10000 - SmbConstants.MILLISECONDS_BETWEEN_1970_AND_1601);
      case TIME_1970_MILLIS_64BE:
        return DateTime.fromMillisecondsSinceEpoch(dec_uint64be(src, si));
      case TIME_1970_MILLIS_64LE:
        return DateTime.fromMillisecondsSinceEpoch(dec_uint64le(src, si));
      default:
        throw SmbIllegalArgumentException("Unsupported time encoding");
    }
  }

  static int enc_utf8(String str, Uint8List dst, int di, int dlim) {
    int start = di, ch;
    int strlen = str.length;

    for (int i = 0; di < dlim && i < strlen; i++) {
      ch = str.codeUnitAt(i);
      if ((ch >= 0x0001) && (ch <= 0x007F)) {
        dst[di++] = ch;
      } else if (ch > 0x07FF) {
        if ((dlim - di) < 3) {
          break;
        }
        dst[di++] = (0xE0 | ((ch >> 12) & 0x0F));
        dst[di++] = (0x80 | ((ch >> 6) & 0x3F));
        dst[di++] = (0x80 | ((ch >> 0) & 0x3F));
      } else {
        if ((dlim - di) < 2) {
          break;
        }
        dst[di++] = (0xC0 | ((ch >> 6) & 0x1F));
        dst[di++] = (0x80 | ((ch >> 0) & 0x3F));
      }
    }

    return di - start;
  }

  static String dec_utf8(Uint8List src, int si, int slim) {
    Uint16List uni = Uint16List(slim - si);

    int ui, ch;

    for (ui = 0; si < slim && (ch = src[si++] & 0xFF) != 0; ui++) {
      if (ch < 0x80) {
        uni[ui] = ch;
      } else if ((ch & 0xE0) == 0xC0) {
        if ((slim - si) < 2) {
          break;
        }
        uni[ui] = ((ch & 0x1F) << 6);
        ch = src[si++] & 0xFF;
        uni[ui] |= ch & 0x3F;
        if ((ch & 0xC0) != 0x80 || uni[ui] < 0x80) {
          throw SmbIOException("Invalid UTF-8 sequence");
        }
      } else if ((ch & 0xF0) == 0xE0) {
        if ((slim - si) < 3) {
          break;
        }
        uni[ui] = ((ch & 0x0F) << 12);
        ch = src[si++] & 0xFF;
        if ((ch & 0xC0) != 0x80) {
          throw SmbIOException("Invalid UTF-8 sequence");
        }
        uni[ui] |= (ch & 0x3F) << 6;
        ch = src[si++] & 0xFF;
        uni[ui] |= ch & 0x3F;
        if ((ch & 0xC0) != 0x80 || uni[ui] < 0x800) {
          throw SmbIOException("Invalid UTF-8 sequence");
        }
      } else {
        throw SmbIOException("Unsupported UTF-8 sequence");
      }
    }

    return utf8.decode(uni);
  }

  static String dec_ucs2le(Uint8List src, int si, int slim, Uint16List buf) {
    int bi;

    for (bi = 0; (si + 1) < slim; bi++, si += 2) {
      buf[bi] = dec_uint16le(src, si);
      if (buf[bi] == 0) {
        break;
      }
    }
    return utf8.decode(buf);
  }
}
