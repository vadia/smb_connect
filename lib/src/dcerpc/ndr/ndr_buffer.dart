import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/utils/encdec.dart';
import 'package:smb_connect/src/utils/extensions.dart';
import 'package:smb_connect/src/utils/strings.dart';

class NdrBuffer {
  int _referent = 0;
  Map<Object, _Entry>? _referents;

  Uint8List buf;
  int start;
  int index = 0;
  int length = 0;
  late NdrBuffer deferred;

  NdrBuffer(this.buf, this.start) {
    index = start;
    deferred = this;
  }

  NdrBuffer derive(int idx) {
    NdrBuffer nb = NdrBuffer(buf, start);
    nb.index = idx;
    nb.deferred = deferred;
    return nb;
  }

  void reset() {
    index = start;
    length = 0;
    deferred = this;
  }

  int getCapacity() {
    return buf.length - start;
  }

  int getTailSpace() {
    return buf.length - index;
  }

  Uint8List getBuffer() {
    return buf;
  }

  int align(int boundary, {int? value}) {
    int n = align0(boundary);
    if (value != null) {
      int i = n;
      while (i > 0) {
        buf[index - i] = value;
        i--;
      }
    }
    return n;
  }

  void writeOctetArray(Uint8List b, int i, int l) {
    byteArrayCopy(src: b, srcOffset: i, dst: buf, dstOffset: index, length: l);
    advance(l);
  }

  void readOctetArray(Uint8List b, int i, int l) {
    byteArrayCopy(src: buf, srcOffset: index, dst: b, dstOffset: i, length: l);
    advance(l);
  }

  int getLength() {
    return deferred.length;
  }

  void setLength(int length) {
    deferred.length = length;
  }

  void advance(int n) {
    index += n;
    if ((index - start) > deferred.length) {
      deferred.length = index - start;
    }
  }

  int align0(int boundary) {
    int m = boundary - 1;
    int i = index - start;
    int n = ((i + m) & ~m) - i;
    advance(n);
    return n;
  }

  void enc_ndr_small(int s) {
    buf[index] = (s & 0xFF);
    advance(1);
  }

  int dec_ndr_small() {
    int val = buf[index] & 0xFF;
    advance(1);
    return val;
  }

  void enc_ndr_short(int s) {
    align(2);
    Encdec.enc_uint16le(s, buf, index);
    advance(2);
  }

  int dec_ndr_short() {
    align(2);
    int val = Encdec.dec_uint16le(buf, index);
    advance(2);
    return val;
  }

  void enc_ndr_long(int l) {
    align(4);
    Encdec.enc_uint32le(l, buf, index);
    advance(4);
  }

  int dec_ndr_long() {
    align(4);
    int val = Encdec.dec_uint32le(buf, index);
    advance(4);
    return val;
  }

  void enc_ndr_hyper(int h) {
    align(8);
    Encdec.enc_uint64le(h, buf, index);
    advance(8);
  }

  int dec_ndr_hyper() {
    align(8);
    int val = Encdec.dec_uint64le(buf, index);
    advance(8);
    return val;
  }

  /* float */
  /* double */
  void enc_ndr_string(String s) {
    align(4);
    int i = index;
    int len = s.length;
    Encdec.enc_uint32le(len + 1, buf, i);
    i += 4;
    Encdec.enc_uint32le(0, buf, i);
    i += 4;
    Encdec.enc_uint32le(len + 1, buf, i);
    i += 4;
    byteArrayCopy(
        src: s.getUNIBytes(),
        srcOffset: 0,
        dst: buf,
        dstOffset: i,
        length: len * 2);
    i += len * 2;
    buf[i++] = 0;
    buf[i++] = 0;
    advance(i - index);
  }

  String? dec_ndr_string() {
    align(4);
    int i = index;
    String? val;
    int len = Encdec.dec_uint32le(buf, i);
    i += 12;
    if (len != 0) {
      len--;
      int size = len * 2;
      if (size < 0 || size > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      val = fromUNIBytes(buf, i, size);
      i += size + 2;
    }
    advance(i - index);
    return val;
  }

  int _getDceReferent(Object obj) {
    _Entry? e;

    if (_referents == null) {
      _referents = {};
      _referent = 1;
    }

    e = _referents![obj];
    if (e == null) {
      e = _Entry(_referent++, obj);
      _referents![obj] = e;
    }

    return e.referent;
  }

  void enc_ndr_referent(Object? obj, int type) {
    if (obj == null) {
      enc_ndr_long(0);
      return;
    }
    switch (type) {
      case 1: /* unique */
      case 3: /* ref */
        enc_ndr_long(identityHashCode(obj));
        return;
      case 2: /* ptr */
        enc_ndr_long(_getDceReferent(obj));
        return;
    }
  }

  @override
  String toString() {
    return "start=$start,index=$index,length=${getLength()}";
  }
}

class _Entry {
  final Object obj;
  final int referent;

  _Entry(this.referent, this.obj);
}
