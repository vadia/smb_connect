// ignore_for_file: camel_case_types, no_leading_underscores_for_local_identifiers

import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_message.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_object.dart';
import 'package:smb_connect/src/dcerpc/rpc.dart';

import '../ndr/ndr_small.dart';

String lsarpc_getSyntax() {
  return "12345778-1234-abcd-ef00-0123456789ab:0.0";
}

class lsarpc_LsarQosInfo extends NdrObject {
  int length = 0;
  int impersonation_level = 0;
  int context_mode = 0;
  int effective_only = 0;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(length);
    dst.enc_ndr_short(impersonation_level);
    dst.enc_ndr_small(context_mode);
    dst.enc_ndr_small(effective_only);
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    length = src.dec_ndr_long();
    impersonation_level = src.dec_ndr_short();
    context_mode = src.dec_ndr_small();
    effective_only = src.dec_ndr_small();
  }
}

class lsarpc_LsarObjectAttributes extends NdrObject {
  int length = 0;
  NdrSmall? root_directory;
  rpc_unicode_string? object_name;
  int attributes = 0;
  int security_descriptor = 0;
  lsarpc_LsarQosInfo? security_quality_of_service;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(length);
    dst.enc_ndr_referent(root_directory, 1);
    dst.enc_ndr_referent(object_name, 1);
    dst.enc_ndr_long(attributes);
    dst.enc_ndr_long(security_descriptor);
    dst.enc_ndr_referent(security_quality_of_service, 1);

    if (root_directory != null) {
      dst = dst.deferred;
      root_directory!.encode(dst);
    }
    if (object_name != null) {
      dst = dst.deferred;
      object_name!.encode(dst);
    }
    if (security_quality_of_service != null) {
      dst = dst.deferred;
      security_quality_of_service!.encode(dst);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    length = src.dec_ndr_long();
    int _root_directoryp = src.dec_ndr_long();
    int _object_namep = src.dec_ndr_long();
    attributes = src.dec_ndr_long();
    security_descriptor = src.dec_ndr_long();
    int _security_quality_of_servicep = src.dec_ndr_long();

    if (_root_directoryp != 0) {
      src = src.deferred;
      root_directory!.decode(src);
    }
    if (_object_namep != 0) {
      object_name ??= rpc_unicode_string();
      src = src.deferred;
      object_name!.decode(src);
    }
    if (_security_quality_of_servicep != 0) {
      security_quality_of_service ??= lsarpc_LsarQosInfo();
      src = src.deferred;
      security_quality_of_service!.decode(src);
    }
  }
}

class lsarpc_LsarDomainInfo extends NdrObject {
  rpc_unicode_string? name;
  rpc_sid_t? sid;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(name!.length);
    dst.enc_ndr_short(name!.maximum_length);
    dst.enc_ndr_referent(name!.buffer, 1);
    dst.enc_ndr_referent(sid, 1);

    if (name!.buffer != null) {
      dst = dst.deferred;
      int _name_bufferl = name!.length ~/ 2;
      int _name_buffers = name!.maximum_length ~/ 2;
      dst.enc_ndr_long(_name_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_name_bufferl);
      int _name_bufferi = dst.index;
      dst.advance(2 * _name_bufferl);

      dst = dst.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        dst.enc_ndr_short(name!.buffer![_i]);
      }
    }
    if (sid != null) {
      dst = dst.deferred;
      sid!.encode(dst);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    src.align(4);
    name ??= rpc_unicode_string();
    name!.length = src.dec_ndr_short();
    name!.maximum_length = src.dec_ndr_short();
    int _name_bufferp = src.dec_ndr_long();
    int _sidp = src.dec_ndr_long();

    if (_name_bufferp != 0) {
      src = src.deferred;
      int _name_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _name_bufferl = src.dec_ndr_long();
      int _name_bufferi = src.index;
      src.advance(2 * _name_bufferl);

      if (name!.buffer == null) {
        if (_name_buffers < 0 || _name_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        name!.buffer = Uint8List(_name_buffers);
      }
      src = src.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        name!.buffer![_i] = src.dec_ndr_short();
      }
    }
    if (_sidp != 0) {
      sid ??= rpc_sid_t();
      src = src.deferred;
      sid!.decode(src);
    }
  }
}

class lsarpc_LsarDnsDomainInfo extends NdrObject {
  rpc_unicode_string? name;
  rpc_unicode_string? dns_domain;
  rpc_unicode_string? dns_forest;
  rpc_uuid_t? domain_guid;
  rpc_sid_t? sid;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(name!.length);
    dst.enc_ndr_short(name!.maximum_length);
    dst.enc_ndr_referent(name!.buffer, 1);
    dst.enc_ndr_short(dns_domain!.length);
    dst.enc_ndr_short(dns_domain!.maximum_length);
    dst.enc_ndr_referent(dns_domain!.buffer, 1);
    dst.enc_ndr_short(dns_forest!.length);
    dst.enc_ndr_short(dns_forest!.maximum_length);
    dst.enc_ndr_referent(dns_forest!.buffer, 1);
    dst.enc_ndr_long(domain_guid!.time_low);
    dst.enc_ndr_short(domain_guid!.time_mid);
    dst.enc_ndr_short(domain_guid!.time_hi_and_version);
    dst.enc_ndr_small(domain_guid!.clock_seq_hi_and_reserved);
    dst.enc_ndr_small(domain_guid!.clock_seq_low);
    int _domain_guid_nodes = 6;
    int _domain_guid_nodei = dst.index;
    dst.advance(1 * _domain_guid_nodes);
    dst.enc_ndr_referent(sid, 1);

    if (name!.buffer != null) {
      dst = dst.deferred;
      int _name_bufferl = name!.length ~/ 2;
      int _name_buffers = name!.maximum_length ~/ 2;
      dst.enc_ndr_long(_name_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_name_bufferl);
      int _name_bufferi = dst.index;
      dst.advance(2 * _name_bufferl);

      dst = dst.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        dst.enc_ndr_short(name!.buffer![_i]);
      }
    }
    if (dns_domain!.buffer != null) {
      dst = dst.deferred;
      int _dns_domain_bufferl = dns_domain!.length ~/ 2;
      int _dns_domain_buffers = dns_domain!.maximum_length ~/ 2;
      dst.enc_ndr_long(_dns_domain_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_dns_domain_bufferl);
      int _dns_domain_bufferi = dst.index;
      dst.advance(2 * _dns_domain_bufferl);

      dst = dst.derive(_dns_domain_bufferi);
      for (int _i = 0; _i < _dns_domain_bufferl; _i++) {
        dst.enc_ndr_short(dns_domain!.buffer![_i]);
      }
    }
    if (dns_forest!.buffer != null) {
      dst = dst.deferred;
      int _dns_forest_bufferl = dns_forest!.length ~/ 2;
      int _dns_forest_buffers = dns_forest!.maximum_length ~/ 2;
      dst.enc_ndr_long(_dns_forest_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_dns_forest_bufferl);
      int _dns_forest_bufferi = dst.index;
      dst.advance(2 * _dns_forest_bufferl);

      dst = dst.derive(_dns_forest_bufferi);
      for (int _i = 0; _i < _dns_forest_bufferl; _i++) {
        dst.enc_ndr_short(dns_forest!.buffer![_i]);
      }
    }
    dst = dst.derive(_domain_guid_nodei);
    for (int _i = 0; _i < _domain_guid_nodes; _i++) {
      dst.enc_ndr_small(domain_guid!.node![_i]);
    }
    if (sid != null) {
      dst = dst.deferred;
      sid!.encode(dst);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    src.align(4);
    name ??= rpc_unicode_string();
    name!.length = src.dec_ndr_short();
    name!.maximum_length = src.dec_ndr_short();
    int _name_bufferp = src.dec_ndr_long();
    src.align(4);
    dns_domain ??= rpc_unicode_string();
    dns_domain!.length = src.dec_ndr_short();
    dns_domain!.maximum_length = src.dec_ndr_short();
    int _dns_domain_bufferp = src.dec_ndr_long();
    src.align(4);
    dns_forest ??= rpc_unicode_string();
    dns_forest!.length = src.dec_ndr_short();
    dns_forest!.maximum_length = src.dec_ndr_short();
    int _dns_forest_bufferp = src.dec_ndr_long();
    src.align(4);
    domain_guid ??= rpc_uuid_t();
    domain_guid!.time_low = src.dec_ndr_long();
    domain_guid!.time_mid = src.dec_ndr_short();
    domain_guid!.time_hi_and_version = src.dec_ndr_short();
    domain_guid!.clock_seq_hi_and_reserved = src.dec_ndr_small();
    domain_guid!.clock_seq_low = src.dec_ndr_small();
    int _domain_guid_nodes = 6;
    int _domain_guid_nodei = src.index;
    src.advance(1 * _domain_guid_nodes);
    int _sidp = src.dec_ndr_long();

    if (_name_bufferp != 0) {
      src = src.deferred;
      int _name_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _name_bufferl = src.dec_ndr_long();
      int _name_bufferi = src.index;
      src.advance(2 * _name_bufferl);

      if (name!.buffer == null) {
        if (_name_buffers < 0 || _name_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        name!.buffer = Uint8List(_name_buffers);
      }
      src = src.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        name!.buffer![_i] = src.dec_ndr_short();
      }
    }
    if (_dns_domain_bufferp != 0) {
      src = src.deferred;
      int _dns_domain_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _dns_domain_bufferl = src.dec_ndr_long();
      int _dns_domain_bufferi = src.index;
      src.advance(2 * _dns_domain_bufferl);

      if (dns_domain!.buffer == null) {
        if (_dns_domain_buffers < 0 || _dns_domain_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        dns_domain!.buffer = Uint8List(_dns_domain_buffers);
      }
      src = src.derive(_dns_domain_bufferi);
      for (int _i = 0; _i < _dns_domain_bufferl; _i++) {
        dns_domain!.buffer![_i] = src.dec_ndr_short();
      }
    }
    if (_dns_forest_bufferp != 0) {
      src = src.deferred;
      int _dns_forest_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _dns_forest_bufferl = src.dec_ndr_long();
      int _dns_forest_bufferi = src.index;
      src.advance(2 * _dns_forest_bufferl);

      if (dns_forest!.buffer == null) {
        if (_dns_forest_buffers < 0 || _dns_forest_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        dns_forest!.buffer = Uint8List(_dns_forest_buffers);
      }
      src = src.derive(_dns_forest_bufferi);
      for (int _i = 0; _i < _dns_forest_bufferl; _i++) {
        dns_forest!.buffer![_i] = src.dec_ndr_short();
      }
    }
    if (domain_guid!.node == null) {
      if (_domain_guid_nodes < 0 || _domain_guid_nodes > 0xFFFF) {
        throw NdrException(NdrException.INVALID_CONFORMANCE);
      }
      domain_guid!.node = Uint8List(_domain_guid_nodes);
    }
    src = src.derive(_domain_guid_nodei);
    for (int _i = 0; _i < _domain_guid_nodes; _i++) {
      domain_guid!.node![_i] = src.dec_ndr_small();
    }
    if (_sidp != 0) {
      sid ??= rpc_sid_t();
      src = src.deferred;
      sid!.decode(src);
    }
  }
}

class lsarpc_LsarSidPtr extends NdrObject {
  static const int POLICY_INFO_AUDIT_EVENTS = 2;
  static const int POLICY_INFO_PRIMARY_DOMAIN = 3;
  static const int POLICY_INFO_ACCOUNT_DOMAIN = 5;
  static const int POLICY_INFO_SERVER_ROLE = 6;
  static const int POLICY_INFO_MODIFICATION = 9;
  static const int POLICY_INFO_DNS_DOMAIN = 12;

  rpc_sid_t? sid;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_referent(sid, 1);

    if (sid != null) {
      dst = dst.deferred;
      sid!.encode(dst);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    int _sidp = src.dec_ndr_long();

    if (_sidp != 0) {
      sid ??= rpc_sid_t();
      src = src.deferred;
      sid!.decode(src);
    }
  }
}

class lsarpc_LsarSidArray extends NdrObject {
  int num_sids = 0;
  List<lsarpc_LsarSidPtr>? sids;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(num_sids);
    dst.enc_ndr_referent(sids, 1);

    if (sids != null) {
      dst = dst.deferred;
      int _sidss = num_sids;
      dst.enc_ndr_long(_sidss);
      int _sidsi = dst.index;
      dst.advance(4 * _sidss);

      dst = dst.derive(_sidsi);
      for (int _i = 0; _i < _sidss; _i++) {
        sids![_i].encode(dst);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    num_sids = src.dec_ndr_long();
    int _sidsp = src.dec_ndr_long();

    if (_sidsp != 0) {
      src = src.deferred;
      int _sidss = src.dec_ndr_long();
      int _sidsi = src.index;
      src.advance(4 * _sidss);

      if (sids == null) {
        if (_sidss < 0 || _sidss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        sids = List.generate(
            _sidss, (index) => lsarpc_LsarSidPtr()); // LsarSidPtr[_sidss];
      }
      src = src.derive(_sidsi);
      for (int _i = 0; _i < _sidss; _i++) {
        // if ( sids[ _i ] == null ) {
        //     sids[ _i ] = LsarSidPtr();
        // }
        sids![_i].decode(src);
      }
    }
  }
}

class lsarpc_LsarTranslatedSid extends NdrObject {
  static const int SID_NAME_USE_NONE = 0;
  static const int SID_NAME_USER = 1;
  static const int SID_NAME_DOM_GRP = 2;
  static const int SID_NAME_DOMAIN = 3;
  static const int SID_NAME_ALIAS = 4;
  static const int SID_NAME_WKN_GRP = 5;
  static const int SID_NAME_DELETED = 6;
  static const int SID_NAME_INVALID = 7;
  static const int SID_NAME_UNKNOWN = 8;

  int sid_type = 0;
  int rid = 0;
  int sid_index = 0;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(sid_type);
    dst.enc_ndr_long(rid);
    dst.enc_ndr_long(sid_index);
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    sid_type = src.dec_ndr_short();
    rid = src.dec_ndr_long();
    sid_index = src.dec_ndr_long();
  }
}

class lsarpc_LsarTransSidArray extends NdrObject {
  int count = 0;
  List<lsarpc_LsarTranslatedSid>? sids;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(count);
    dst.enc_ndr_referent(sids, 1);

    if (sids != null) {
      dst = dst.deferred;
      int _sidss = count;
      dst.enc_ndr_long(_sidss);
      int _sidsi = dst.index;
      dst.advance(12 * _sidss);

      dst = dst.derive(_sidsi);
      for (int _i = 0; _i < _sidss; _i++) {
        sids![_i].encode(dst);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    count = src.dec_ndr_long();
    int _sidsp = src.dec_ndr_long();

    if (_sidsp != 0) {
      src = src.deferred;
      int _sidss = src.dec_ndr_long();
      int _sidsi = src.index;
      src.advance(12 * _sidss);

      if (sids == null) {
        if (_sidss < 0 || _sidss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        sids = List.generate(
            _sidss,
            (index) =>
                lsarpc_LsarTranslatedSid()); // LsarTranslatedSid[_sidss];
      }
      src = src.derive(_sidsi);
      for (int _i = 0; _i < _sidss; _i++) {
        // if ( sids[ _i ] == null ) {
        //     sids[ _i ] = LsarTranslatedSid();
        // }
        sids![_i].decode(src);
      }
    }
  }
}

class lsarpc_LsarTrustInformation extends NdrObject {
  rpc_unicode_string? name;
  rpc_sid_t? sid;

  // lsarpc_LsarTrustInformation(this.name);

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(name!.length);
    dst.enc_ndr_short(name!.maximum_length);
    dst.enc_ndr_referent(name!.buffer, 1);
    dst.enc_ndr_referent(sid, 1);

    if (name!.buffer != null) {
      dst = dst.deferred;
      int _name_bufferl = name!.length ~/ 2;
      int _name_buffers = name!.maximum_length ~/ 2;
      dst.enc_ndr_long(_name_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_name_bufferl);
      int _name_bufferi = dst.index;
      dst.advance(2 * _name_bufferl);

      dst = dst.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        dst.enc_ndr_short(name!.buffer![_i]);
      }
    }
    if (sid != null) {
      dst = dst.deferred;
      sid!.encode(dst);
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    src.align(4);
    name ??= rpc_unicode_string();
    name!.length = src.dec_ndr_short();
    name!.maximum_length = src.dec_ndr_short();
    int _name_bufferp = src.dec_ndr_long();
    int _sidp = src.dec_ndr_long();

    if (_name_bufferp != 0) {
      src = src.deferred;
      int _name_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _name_bufferl = src.dec_ndr_long();
      int _name_bufferi = src.index;
      src.advance(2 * _name_bufferl);

      if (name!.buffer == null) {
        if (_name_buffers < 0 || _name_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        name!.buffer = Uint8List(_name_buffers);
      }
      src = src.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        name!.buffer![_i] = src.dec_ndr_short();
      }
    }
    if (_sidp != 0) {
      sid ??= rpc_sid_t();
      src = src.deferred;
      sid!.decode(src);
    }
  }
}

class lsarpc_LsarRefDomainList extends NdrObject {
  int count = 0;
  List<lsarpc_LsarTrustInformation>? domains;
  int max_count = 0;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(count);
    dst.enc_ndr_referent(domains, 1);
    dst.enc_ndr_long(max_count);

    if (domains != null) {
      dst = dst.deferred;
      int _domainss = count;
      dst.enc_ndr_long(_domainss);
      int _domainsi = dst.index;
      dst.advance(12 * _domainss);

      dst = dst.derive(_domainsi);
      for (int _i = 0; _i < _domainss; _i++) {
        domains![_i].encode(dst);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    count = src.dec_ndr_long();
    int _domainsp = src.dec_ndr_long();
    max_count = src.dec_ndr_long();

    if (_domainsp != 0) {
      src = src.deferred;
      int _domainss = src.dec_ndr_long();
      int _domainsi = src.index;
      src.advance(12 * _domainss);

      if (domains == null) {
        if (_domainss < 0 || _domainss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        domains = List.generate(
            _domainss,
            (index) =>
                lsarpc_LsarTrustInformation()); // LsarTrustInformation[_domainss];
      }
      src = src.derive(_domainsi);
      for (int _i = 0; _i < _domainss; _i++) {
        // if ( domains[ _i ] == null ) {
        //     domains[ _i ] = LsarTrustInformation();
        // }
        domains![_i].decode(src);
      }
    }
  }
}

class lsarpc_LsarTranslatedName extends NdrObject {
  int sid_type = 0;
  rpc_unicode_string? name;
  int sid_index = 0;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_short(sid_type);
    dst.enc_ndr_short(name!.length);
    dst.enc_ndr_short(name!.maximum_length);
    dst.enc_ndr_referent(name!.buffer, 1);
    dst.enc_ndr_long(sid_index);

    if (name!.buffer != null) {
      dst = dst.deferred;
      int _name_bufferl = name!.length ~/ 2;
      int _name_buffers = name!.maximum_length ~/ 2;
      dst.enc_ndr_long(_name_buffers);
      dst.enc_ndr_long(0);
      dst.enc_ndr_long(_name_bufferl);
      int _name_bufferi = dst.index;
      dst.advance(2 * _name_bufferl);

      dst = dst.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        dst.enc_ndr_short(name!.buffer![_i]);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    sid_type = src.dec_ndr_short();
    src.align(4);
    name ??= rpc_unicode_string();
    name!.length = src.dec_ndr_short();
    name!.maximum_length = src.dec_ndr_short();
    int _name_bufferp = src.dec_ndr_long();
    sid_index = src.dec_ndr_long();

    if (_name_bufferp != 0) {
      src = src.deferred;
      int _name_buffers = src.dec_ndr_long();
      src.dec_ndr_long();
      int _name_bufferl = src.dec_ndr_long();
      int _name_bufferi = src.index;
      src.advance(2 * _name_bufferl);

      if (name!.buffer == null) {
        if (_name_buffers < 0 || _name_buffers > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        name!.buffer = Uint8List(_name_buffers);
      }
      src = src.derive(_name_bufferi);
      for (int _i = 0; _i < _name_bufferl; _i++) {
        name!.buffer![_i] = src.dec_ndr_short();
      }
    }
  }
}

class lsarpc_LsarTransNameArray extends NdrObject {
  int count = 0;
  List<lsarpc_LsarTranslatedName>? names;

  @override
  void encode(NdrBuffer dst) {
    dst.align(4);
    dst.enc_ndr_long(count);
    dst.enc_ndr_referent(names, 1);

    if (names != null) {
      dst = dst.deferred;
      int _namess = count;
      dst.enc_ndr_long(_namess);
      int _namesi = dst.index;
      dst.advance(16 * _namess);

      dst = dst.derive(_namesi);
      for (int _i = 0; _i < _namess; _i++) {
        names![_i].encode(dst);
      }
    }
  }

  @override
  void decode(NdrBuffer src) {
    src.align(4);
    count = src.dec_ndr_long();
    int _namesp = src.dec_ndr_long();

    if (_namesp != 0) {
      src = src.deferred;
      int _namess = src.dec_ndr_long();
      int _namesi = src.index;
      src.advance(16 * _namess);

      if (names == null) {
        if (_namess < 0 || _namess > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        names = List.generate(
            _namess,
            (index) =>
                lsarpc_LsarTranslatedName()); //LsarTranslatedName[_namess];
      }
      src = src.derive(_namesi);
      for (int _i = 0; _i < _namess; _i++) {
        // if ( names[ _i ] == null ) {
        //     names[ _i ] = LsarTranslatedName();
        // }
        names![_i].decode(src);
      }
    }
  }
}

class lsarpc_LsarClose extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x00;
  }

  int retval = 0;
  rpc_policy_handle handle;

  lsarpc_LsarClose(this.handle);

  @override
  void encode_in(NdrBuffer buf) {
    handle.encode(buf);
  }

  @override
  void decode_out(NdrBuffer buf) {
    handle.decode(buf);
    retval = buf.dec_ndr_long();
  }
}

class lsarpc_LsarQueryInformationPolicy extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x07;
  }

  int retval = 0;
  rpc_policy_handle handle;
  int level;
  NdrObject info;

  lsarpc_LsarQueryInformationPolicy(this.handle, this.level, this.info); // {
  //     this.handle = handle;
  //     this.level = level;
  //     this.info = info;
  // }

  @override
  void encode_in(NdrBuffer buf) {
    handle.encode(buf);
    buf.enc_ndr_short(level);
  }

  @override
  void decode_out(NdrBuffer buf) {
    int _infop = buf.dec_ndr_long();
    if (_infop != 0) {
      buf.dec_ndr_short(); /* union discriminant */
      info.decode(buf);
    }
    retval = buf.dec_ndr_long();
  }
}

class lsarpc_LsarLookupSids extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x0f;
  }

  int retval = 0;
  rpc_policy_handle handle;
  lsarpc_LsarSidArray sids;
  lsarpc_LsarRefDomainList? domains;
  lsarpc_LsarTransNameArray names;
  int level;
  int count;

  lsarpc_LsarLookupSids(
      this.handle, this.sids, this.domains, this.names, this.level, this.count);
  //     this.handle = handle;
  //     this.sids = sids;
  //     this.domains = domains;
  //     this.names = names;
  //     this.level = level;
  //     this.count = count;
  // }

  @override
  void encode_in(NdrBuffer buf) {
    handle.encode(buf);
    sids.encode(buf);
    names.encode(buf);
    buf.enc_ndr_short(level);
    buf.enc_ndr_long(count);
  }

  @override
  void decode_out(NdrBuffer buf) {
    int _domainsp = buf.dec_ndr_long();
    if (_domainsp != 0) {
      domains ??= lsarpc_LsarRefDomainList();
      domains!.decode(buf);
    }
    names.decode(buf);
    count = buf.dec_ndr_long();
    retval = buf.dec_ndr_long();
  }
}

class lsarpc_LsarOpenPolicy2 extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x2c;
  }

  int retval = 0;
  String? system_name;
  lsarpc_LsarObjectAttributes object_attributes;
  int desired_access;
  rpc_policy_handle policy_handle;

  lsarpc_LsarOpenPolicy2(this.system_name, this.object_attributes,
      this.desired_access, this.policy_handle);
  //     this.system_name = system_name;
  //     this.object_attributes = object_attributes;
  //     this.desired_access = desired_access;
  //     this.policy_handle = policy_handle;
  // }

  @override
  void encode_in(NdrBuffer buf) {
    buf.enc_ndr_referent(system_name, 1);
    if (system_name != null) {
      buf.enc_ndr_string(system_name!);
    }
    object_attributes.encode(buf);
    buf.enc_ndr_long(desired_access);
  }

  @override
  void decode_out(NdrBuffer buf) {
    policy_handle.decode(buf);
    retval = buf.dec_ndr_long();
  }
}

class lsarpc_LsarQueryInformationPolicy2 extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x2e;
  }

  int retval = 0;
  rpc_policy_handle handle;
  int level;
  NdrObject info;

  lsarpc_LsarQueryInformationPolicy2(this.handle, this.level, this.info); // {
  //     this.handle = handle;
  //     this.level = level;
  //     this.info = info;
  // }

  @override
  void encode_in(NdrBuffer buf) {
    handle.encode(buf);
    buf.enc_ndr_short(level);
  }

  @override
  void decode_out(NdrBuffer buf) {
    int _infop = buf.dec_ndr_long();
    if (_infop != 0) {
      buf.dec_ndr_short(); /* union discriminant */
      info.decode(buf);
    }
    retval = buf.dec_ndr_long();
  }
}
