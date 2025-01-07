import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_object.dart';

import 'dcerpc_constants.dart';

abstract class DcerpcMessage extends NdrObject implements DcerpcConstants {
  int ptype = -1;
  int flags = 0;
  int length = 0;
  int call_id = 0;
  int alloc_hint = 0;
  int result = 0;

  bool isFlagSet(int flag) {
    return (flags & flag) == flag;
  }

  /// Remove flag
  void unsetFlag(int flag) {
    flags &= ~flag;
  }

  /// Set flag
  void setFlag(int flag) {
    flags |= flag;
  }

  DcerpcException? getResult() {
    if (result != 0) return DcerpcException(result);
    return null;
  }

  void encode_header(NdrBuffer buf) {
    buf.enc_ndr_small(5); /* RPC version */
    buf.enc_ndr_small(0); /* minor version */
    buf.enc_ndr_small(ptype);
    buf.enc_ndr_small(flags);
    buf.enc_ndr_long(0x00000010); /* Little-endian / ASCII / IEEE */
    buf.enc_ndr_short(length);
    buf.enc_ndr_short(0); /* length of auth_value */
    buf.enc_ndr_long(call_id);
  }

  void decode_header(NdrBuffer buf) {
    /* RPC major / minor version */
    if (buf.dec_ndr_small() != 5 || buf.dec_ndr_small() != 0) {
      throw NdrException("DCERPC version not supported");
    }
    ptype = buf.dec_ndr_small();
    flags = buf.dec_ndr_small();
    if (buf.dec_ndr_long() != 0x00000010) {
      /* Little-endian / ASCII / IEEE */
      throw NdrException("Data representation not supported");
    }
    length = buf.dec_ndr_short();
    if (buf.dec_ndr_short() != 0) {
      throw NdrException("DCERPC authentication not supported");
    }
    call_id = buf.dec_ndr_long();
  }

  @override
  void encode(NdrBuffer dst) {
    int start = dst.index;
    int alloc_hint_index = 0;

    dst.advance(16); /* momentarily skip header */
    if (ptype == 0) {
      /* Request */
      alloc_hint_index = dst.index;
      dst.enc_ndr_long(0); /* momentarily skip alloc hint */
      dst.enc_ndr_short(0); /* context id */
      dst.enc_ndr_short(getOpnum());
    }

    encode_in(dst);
    length = dst.index - start;

    if (ptype == 0) {
      dst.index = alloc_hint_index;
      alloc_hint = length - alloc_hint_index;
      dst.enc_ndr_long(alloc_hint);
    }

    dst.index = start;
    encode_header(dst);
    dst.index = start + length;
  }

  @override
  void decode(NdrBuffer src) {
    decode_header(src);

    if (ptype != 12 && ptype != 2 && ptype != 3 && ptype != 13) {
      throw NdrException("Unexpected ptype: $ptype");
    }

    if (ptype == 2 || ptype == 3) {
      /* Response or Fault */
      alloc_hint = src.dec_ndr_long();
      src.dec_ndr_short(); /* context id */
      src.dec_ndr_short(); /* cancel count */
    }
    if (ptype == 3 || ptype == 13) {
      /* Fault */
      result = src.dec_ndr_long();
    } else {
      /* Bind_ack or Response */
      decode_out(src);
    }
  }

  int getOpnum();

  void encode_in(NdrBuffer buf);
  void decode_out(NdrBuffer buf);
}
