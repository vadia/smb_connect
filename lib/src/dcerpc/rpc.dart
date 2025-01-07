// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_object.dart';
import 'package:smb_connect/src/utils/encdec.dart';
import 'package:smb_connect/src/utils/extensions.dart';

class rpc_uuid_t extends NdrObject {
  int time_low = 0;
  int time_mid = 0;
  int time_hi_and_version = 0;
  int clock_seq_hi_and_reserved = 0;
  int clock_seq_low = 0;
  Uint8List? node;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(time_low);
    dst.enc_ndr_short(time_mid);
    dst.enc_ndr_short(time_hi_and_version);
    dst.enc_ndr_small(clock_seq_hi_and_reserved);
    dst.enc_ndr_small(clock_seq_low);
    int nodes = 6;
    int nodei = dst.index;
    dst.advance(1 * nodes);

    dst = dst.derive(nodei);
    for (int i = 0; i < nodes; i++) {
      dst.enc_ndr_small(node![i]);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    time_low = src.dec_ndr_long();
    time_mid = src.dec_ndr_short();
    time_hi_and_version = src.dec_ndr_short();
    clock_seq_hi_and_reserved = src.dec_ndr_small();
    clock_seq_low = src.dec_ndr_small();
    int nodes = 6;
    int nodei = src.index;
    src.advance(1 * nodes);

    if (node == null) {
      if (nodes < 0 || nodes > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      node = Uint8List(nodes);
    }
    src = src.derive(nodei);
    for (int i = 0; i < nodes; i++) {
      node![i] = src.dec_ndr_small();
    }
  }
}

class rpc_policy_handle extends NdrObject {
  int type = 0;
  rpc_uuid_t? uuid;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(type);
    if (uuid == null) {
      throw NdrException(NdrException.NO_NULL_REF);
    }
    dst.enc_ndr_long(uuid!.time_low);
    dst.enc_ndr_short(uuid!.time_mid);
    dst.enc_ndr_short(uuid!.time_hi_and_version);
    dst.enc_ndr_small(uuid!.clock_seq_hi_and_reserved);
    dst.enc_ndr_small(uuid!.clock_seq_low);
    int uuid_nodes = 6;
    int uuid_nodei = dst.index;
    dst.advance(1 * uuid_nodes);

    dst = dst.derive(uuid_nodei);
    for (int i = 0; i < uuid_nodes; i++) {
      dst.enc_ndr_small(uuid!.node![i]);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    type = src.dec_ndr_long();
    src.align(4);
    uuid ??= rpc_uuid_t();
    uuid!.time_low = src.dec_ndr_long();
    uuid!.time_mid = src.dec_ndr_short();
    uuid!.time_hi_and_version = src.dec_ndr_short();
    uuid!.clock_seq_hi_and_reserved = src.dec_ndr_small();
    uuid!.clock_seq_low = src.dec_ndr_small();
    int uuid_nodes = 6;
    int uuid_nodei = src.index;
    src.advance(1 * uuid_nodes);

    if (uuid!.node == null) {
      if (uuid_nodes < 0 || uuid_nodes > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      uuid!.node = Uint8List(uuid_nodes);
    }
    src = src.derive(uuid_nodei);
    for (int i = 0; i < uuid_nodes; i++) {
      uuid!.node![i] = src.dec_ndr_small();
    }
  }
}

class rpc_unicode_string extends NdrObject {
  int length = 0;
  int maximum_length = 0;
  Uint8List? buffer;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(length);
    dst.enc_ndr_short(maximum_length);
    dst.enc_ndr_referent(buffer, 1);

    if (buffer != null) {
      dst = dst.deferred;
      int bufferl = length ~/ 2;
      int buffers = maximum_length ~/ 2;
      dst.enc_ndr_long(buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(bufferl);
      int bufferi = dst.index;
      dst.advance(2 * bufferl);

      dst = dst.derive(bufferi);
      for (int i = 0; i < bufferl; i++) {
        dst.enc_ndr_short(buffer![i]);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    length = src.dec_ndr_short();
    maximum_length = src.dec_ndr_short();
    int bufferp = src.dec_ndr_long();

    if (bufferp != 0) {
      src = src.deferred;
      int buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int bufferl = src.dec_ndr_long();
      int bufferi = src.index;
      src.advance(2 * bufferl);

      if (buffer == null) {
        if (buffers < 0 || buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        buffer = Uint8List(buffers);
      }
      src = src.derive(bufferi);
      for (int i = 0; i < bufferl; i++) {
        buffer![i] = src.dec_ndr_short();
      }
    }
  }
}

class rpc_sid_t extends NdrObject {
  static Uint8List toByteArray(rpc_sid_t sid) {
    Uint8List dst = Uint8List(1 + 1 + 6 + sid.sub_authority_count * 4);
    int di = 0;
    dst[di++] = sid.revision;
    dst[di++] = sid.sub_authority_count;
    byteArrayCopy(
        src: sid.identifier_authority!,
        srcOffset: 0,
        dst: dst,
        dstOffset: di,
        length: 6);
    di += 6;
    for (int ii = 0; ii < sid.sub_authority_count; ii++) {
      Encdec.enc_uint32le(sid.sub_authority![ii], dst, di);
      di += 4;
    }
    return dst;
  }

  int revision = 0;
  int sub_authority_count = 0;
  Uint8List? identifier_authority;
  Uint8List? sub_authority;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    int sub_authoritys = sub_authority_count;
    dst.enc_ndr_long(sub_authoritys);
    dst.enc_ndr_small(revision);
    dst.enc_ndr_small(sub_authority_count);
    int identifier_authoritys = 6;
    int identifier_authorityi = dst.index;
    dst.advance(1 * identifier_authoritys);
    int sub_authorityi = dst.index;
    dst.advance(4 * sub_authoritys);

    dst = dst.derive(identifier_authorityi);
    for (int i = 0; i < identifier_authoritys; i++) {
      dst.enc_ndr_small(identifier_authority![i]);
    }
    dst = dst.derive(sub_authorityi);
    for (int i = 0; i < sub_authoritys; i++) {
      dst.enc_ndr_long(sub_authority![i]);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    int sub_authoritys = src.dec_ndr_long();
    revision = src.dec_ndr_small();
    sub_authority_count = src.dec_ndr_small();
    int identifier_authoritys = 6;
    int identifier_authorityi = src.index;
    src.advance(1 * identifier_authoritys);
    int sub_authorityi = src.index;
    src.advance(4 * sub_authoritys);

    if (identifier_authority == null) {
      if (identifier_authoritys < 0 || identifier_authoritys > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      identifier_authority = Uint8List(identifier_authoritys);
    }
    src = src.derive(identifier_authorityi);
    for (int i = 0; i < identifier_authoritys; i++) {
      identifier_authority![i] = src.dec_ndr_small();
    }
    if (sub_authority == null) {
      if (sub_authoritys < 0 || sub_authoritys > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      sub_authority = Uint8List(sub_authoritys);
    }
    src = src.derive(sub_authorityi);
    for (int i = 0; i < sub_authoritys; i++) {
      sub_authority![i] = src.dec_ndr_long();
    }
  }
}
