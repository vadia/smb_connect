// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers, avoid_renaming_method_parameters

import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_message.dart';
import 'package:smb_connect/src/dcerpc/msrpc/lsarpc.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_object.dart';
import 'package:smb_connect/src/dcerpc/rpc.dart';

String samr_getSyntax() {
  return "12345778-1234-abcd-ef00-0123456789ac:1.0";
}

class samr_SamrCloseHandle extends DcerpcMessage {
  static const int ACB_DISABLED = 1;
  static const int ACB_HOMDIRREQ = 2;
  static const int ACB_PWNOTREQ = 4;
  static const int ACB_TEMPDUP = 8;
  static const int ACB_NORMAL = 16;
  static const int ACB_MNS = 32;
  static const int ACB_DOMTRUST = 64;
  static const int ACB_WSTRUST = 128;
  static const int ACB_SVRTRUST = 256;
  static const int ACB_PWNOEXP = 512;
  static const int ACB_AUTOLOCK = 1024;
  static const int ACB_ENC_TXT_PWD_ALLOWED = 2048;
  static const int ACB_SMARTCARD_REQUIRED = 4096;
  static const int ACB_TRUSTED_FOR_DELEGATION = 8192;
  static const int ACB_NOT_DELEGATED = 16384;
  static const int ACB_USE_DES_KEY_ONLY = 32768;
  static const int ACB_DONT_REQUIRE_PREAUTH = 65536;

  @override
  int getOpnum() {
    return 0x01;
  }

  int retval = 0;
  rpc_policy_handle handle;

  samr_SamrCloseHandle(this.handle);

  @override
  void encode_in(NdrBuffer _dst) {
    handle.encode(_dst);
  }

  @override
  void decode_out(NdrBuffer _src) {
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrConnect2 extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x39;
  }

  int retval = 0;
  String? system_name;
  int access_mask;
  rpc_policy_handle handle;

  samr_SamrConnect2(this.system_name, this.access_mask, this.handle);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(system_name, 1);
    if (system_name != null) {
      _dst.enc_ndr_string(system_name!);
    }
    _dst.enc_ndr_long(access_mask);
  }

  @override
  void decode_out(NdrBuffer _src) {
    handle.decode(_src);
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrConnect4 extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x3e;
  }

  int retval = 0;
  String? system_name;
  int unknown;
  int access_mask;
  rpc_policy_handle handle;

  samr_SamrConnect4(
      this.system_name, this.unknown, this.access_mask, this.handle);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(system_name, 1);
    if (system_name != null) {
      _dst.enc_ndr_string(system_name!);
    }
    _dst.enc_ndr_long(unknown);
    _dst.enc_ndr_long(access_mask);
  }

  @override
  void decode_out(NdrBuffer _src) {
    handle.decode(_src);
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrOpenDomain extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x07;
  }

  int retval = 0;
  rpc_policy_handle handle;
  int access_mask;
  rpc_sid_t sid;
  rpc_policy_handle domain_handle;

  samr_SamrOpenDomain(
      this.handle, this.access_mask, this.sid, this.domain_handle);

  @override
  void encode_in(NdrBuffer _dst) {
    handle.encode(_dst);
    _dst.enc_ndr_long(access_mask);
    sid.encode(_dst);
  }

  @override
  void decode_out(NdrBuffer _src) {
    domain_handle.decode(_src);
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrSamEntry extends NdrObject {
  int idx = 0;
  rpc_unicode_string? name;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(idx);
    _dst.enc_ndr_short(name!.length);
    _dst.enc_ndr_short(name!.maximum_length);
    _dst.enc_ndr_referent(name!.buffer, 1);

    if (name!.buffer != null) {
      _dst = _dst.deferred;
      int _name_bufferl = name!.length ~/ 2;
      int _name_buffers = name!.maximum_length ~/ 2;
      _dst.enc_ndr_long(_name_buffers);
      _dst.enc_ndr_long(0);
      _dst.enc_ndr_long(_name_bufferl);
      int _name_bufferi = _dst.index;
      _dst.advance(2 * _name_bufferl);

      _dst = _dst.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        _dst.enc_ndr_short(name!.buffer![_i]);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    idx = _src.dec_ndr_long();
    _src.align(4);
    name ??= rpc_unicode_string();
    name!.length = _src.dec_ndr_short();
    name!.maximum_length = _src.dec_ndr_short();
    int _name_bufferp = _src.dec_ndr_long();

    if (_name_bufferp != 0) {
      _src = _src.deferred;
      int _name_buffers = _src.dec_ndr_long();
      _src.dec_ndr_long();
      int _name_bufferl = _src.dec_ndr_long();
      int _name_bufferi = _src.index;
      _src.advance(2 * _name_bufferl);

      if (name!.buffer == null) {
        if (_name_buffers < 0 || _name_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        name!.buffer = Uint8List(_name_buffers);
      }
      _src = _src.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        name!.buffer![_i] = _src.dec_ndr_short();
      }
    }
  }
}

class samr_SamrSamArray extends NdrObject {
  int count = 0;
  List<samr_SamrSamEntry>? entries;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(entries, 1);

    if (entries != null) {
      _dst = _dst.deferred;
      int _entriess = count;
      _dst.enc_ndr_long(_entriess);
      int _entriesi = _dst.index;
      _dst.advance(12 * _entriess);

      _dst = _dst.derive(_entriesi);
      for (int _i = 0; _i < _entriess; _i++) {
        entries![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _entriesp = _src.dec_ndr_long();

    if (_entriesp != 0) {
      _src = _src.deferred;
      int _entriess = _src.dec_ndr_long();
      int _entriesi = _src.index;
      _src.advance(12 * _entriess);

      if (entries == null) {
        if (_entriess < 0 || _entriess > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        entries = List.generate(_entriess,
            (index) => samr_SamrSamEntry()); //samr_SamrSamEntry[_entriess];
      }
      _src = _src.derive(_entriesi);
      for (int _i = 0; _i < _entriess; _i++) {
        // if (entries[_i] == null) {
        //   entries[_i] = samr_SamrSamEntry();
        // }
        entries![_i].decode(_src);
      }
    }
  }
}

class samr_SamrEnumerateAliasesInDomain extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x0f;
  }

  int retval = 0;
  rpc_policy_handle domain_handle;
  int resume_handle;
  int acct_flags;
  samr_SamrSamArray? sam;
  int num_entries;

  samr_SamrEnumerateAliasesInDomain(this.domain_handle, this.resume_handle,
      this.acct_flags, this.sam, this.num_entries);

  @override
  void encode_in(NdrBuffer _dst) {
    domain_handle.encode(_dst);
    _dst.enc_ndr_long(resume_handle);
    _dst.enc_ndr_long(acct_flags);
  }

  @override
  void decode_out(NdrBuffer _src) {
    resume_handle = _src.dec_ndr_long();
    int _samp = _src.dec_ndr_long();
    if (_samp != 0) {
      sam ??= samr_SamrSamArray();
      sam!.decode(_src);
    }
    num_entries = _src.dec_ndr_long();
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrOpenAlias extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x1b;
  }

  int retval = 0;
  rpc_policy_handle domain_handle;
  int access_mask;
  int rid;
  rpc_policy_handle alias_handle;

  samr_SamrOpenAlias(
      this.domain_handle, this.access_mask, this.rid, this.alias_handle);

  @override
  void encode_in(NdrBuffer _dst) {
    domain_handle.encode(_dst);
    _dst.enc_ndr_long(access_mask);
    _dst.enc_ndr_long(rid);
  }

  @override
  void decode_out(NdrBuffer _src) {
    alias_handle.decode(_src);
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrGetMembersInAlias extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x21;
  }

  int retval = 0;
  rpc_policy_handle alias_handle;
  lsarpc_LsarSidArray sids;

  samr_SamrGetMembersInAlias(this.alias_handle, this.sids);

  @override
  void encode_in(NdrBuffer _dst) {
    alias_handle.encode(_dst);
  }

  @override
  void decode_out(NdrBuffer _src) {
    sids.decode(_src);
    retval = _src.dec_ndr_long();
  }
}

class samr_SamrRidWithAttribute extends NdrObject {
  static const int SE_GROUP_MANDATORY = 1;
  static const int SE_GROUP_ENABLED_BY_DEFAULT = 2;
  static const int SE_GROUP_ENABLED = 4;
  static const int SE_GROUP_OWNER = 8;
  static const int SE_GROUP_USE_FOR_DENY_ONLY = 16;
  static const int SE_GROUP_RESOURCE = 536870912;
  static const int SE_GROUP_LOGON_ID = -1073741824;

  int rid = 0;
  int attributes = 0;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(rid);
    _dst.enc_ndr_long(attributes);
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    rid = _src.dec_ndr_long();
    attributes = _src.dec_ndr_long();
  }
}

class samr_SamrRidWithAttributeArray extends NdrObject {
  int count = 0;
  List<samr_SamrRidWithAttribute>? rids;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(rids, 1);

    if (rids != null) {
      _dst = _dst.deferred;
      int _ridss = count;
      _dst.enc_ndr_long(_ridss);
      int _ridsi = _dst.index;
      _dst.advance(8 * _ridss);

      _dst = _dst.derive(_ridsi);
      for (int _i = 0; _i < _ridss; _i++) {
        rids![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _ridsp = _src.dec_ndr_long();

    if (_ridsp != 0) {
      _src = _src.deferred;
      int _ridss = _src.dec_ndr_long();
      int _ridsi = _src.index;
      _src.advance(8 * _ridss);

      if (rids == null) {
        if (_ridss < 0 || _ridss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        rids = List.generate(
            _ridss,
            (index) =>
                samr_SamrRidWithAttribute()); // samr_SamrRidWithAttribute[_ridss];
      }
      _src = _src.derive(_ridsi);
      for (int _i = 0; _i < _ridss; _i++) {
        // if (rids[_i] == null) {
        //   rids[_i] = samr_SamrRidWithAttribute();
        // }
        rids![_i].decode(_src);
      }
    }
  }
}
