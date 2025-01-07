// ignore_for_file: camel_case_types, avoid_renaming_method_parameters, no_leading_underscores_for_local_identifiers

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_message.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_object.dart';

import '../ndr/ndr_long.dart';

String netdfs_getSyntax() {
  return "4fc742e0-4a10-11cf-8273-00aa004ae673:3.0";
}

class netdfs_DfsInfo1 extends NdrObject {
  static const int DFS_VOLUME_FLAVOR_STANDALONE = 0x100;
  static const int DFS_VOLUME_FLAVOR_AD_BLOB = 0x200;
  static const int DFS_STORAGE_STATE_OFFLINE = 0x0001;
  static const int DFS_STORAGE_STATE_ONLINE = 0x0002;
  static const int DFS_STORAGE_STATE_ACTIVE = 0x0004;

  String? entry_path;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(entry_path, 1);

    if (entry_path != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(entry_path!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _entry_pathp = _src.dec_ndr_long();

    if (_entry_pathp != 0) {
      _src = _src.deferred;
      entry_path = _src.dec_ndr_string();
    }
  }
}

class netdfs_DfsEnumArray1 extends NdrObject {
  int count = 0;
  List<netdfs_DfsInfo1>? s;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(s, 1);

    if (s != null) {
      _dst = _dst.deferred;
      int _ss = count;
      _dst.enc_ndr_long(_ss);
      int _si = _dst.index;
      _dst.advance(4 * _ss);

      _dst = _dst.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        s![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _sp = _src.dec_ndr_long();

    if (_sp != 0) {
      _src = _src.deferred;
      int _ss = _src.dec_ndr_long();
      int _si = _src.index;
      _src.advance(4 * _ss);

      if (s == null) {
        if (_ss < 0 || _ss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        s = List.generate(
            _ss, (index) => netdfs_DfsInfo1()); //netdfs_DfsInfo1[_ss];
      }
      _src = _src.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        // if (s[_i] == null) {
        //   s[_i] = netdfs_DfsInfo1();
        // }
        s![_i].decode(_src);
      }
    }
  }
}

class netdfs_DfsStorageInfo extends NdrObject {
  int state = 0;
  String? server_name;
  String? share_name;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(state);
    _dst.enc_ndr_referent(server_name, 1);
    _dst.enc_ndr_referent(share_name, 1);

    if (server_name != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(server_name!);
    }
    if (share_name != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(share_name!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    state = _src.dec_ndr_long();
    int _server_namep = _src.dec_ndr_long();
    int _share_namep = _src.dec_ndr_long();

    if (_server_namep != 0) {
      _src = _src.deferred;
      server_name = _src.dec_ndr_string();
    }
    if (_share_namep != 0) {
      _src = _src.deferred;
      share_name = _src.dec_ndr_string();
    }
  }
}

class netdfs_DfsInfo3 extends NdrObject {
  String? path;
  String? comment;
  int state = 0;
  int num_stores = 0;
  List<netdfs_DfsStorageInfo>? stores;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(path, 1);
    _dst.enc_ndr_referent(comment, 1);
    _dst.enc_ndr_long(state);
    _dst.enc_ndr_long(num_stores);
    _dst.enc_ndr_referent(stores, 1);

    if (path != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(path!);
    }
    if (comment != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(comment!);
    }
    if (stores != null) {
      _dst = _dst.deferred;
      int _storess = num_stores;
      _dst.enc_ndr_long(_storess);
      int _storesi = _dst.index;
      _dst.advance(12 * _storess);

      _dst = _dst.derive(_storesi);
      for (int _i = 0; _i < _storess; _i++) {
        stores![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _pathp = _src.dec_ndr_long();
    int _commentp = _src.dec_ndr_long();
    state = _src.dec_ndr_long();
    num_stores = _src.dec_ndr_long();
    int _storesp = _src.dec_ndr_long();

    if (_pathp != 0) {
      _src = _src.deferred;
      path = _src.dec_ndr_string();
    }
    if (_commentp != 0) {
      _src = _src.deferred;
      comment = _src.dec_ndr_string();
    }
    if (_storesp != 0) {
      _src = _src.deferred;
      int _storess = _src.dec_ndr_long();
      int _storesi = _src.index;
      _src.advance(12 * _storess);

      if (stores == null) {
        if (_storess < 0 || _storess > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        stores = List.generate(
            _storess,
            (index) =>
                netdfs_DfsStorageInfo()); // netdfs_DfsStorageInfo[_storess];
      }
      _src = _src.derive(_storesi);
      for (int _i = 0; _i < _storess; _i++) {
        // if (stores[_i] == null) {
        //   stores[_i] = netdfs_DfsStorageInfo();
        // }
        stores![_i].decode(_src);
      }
    }
  }
}

class netdfs_DfsEnumArray3 extends NdrObject {
  int count = 0;
  List<netdfs_DfsInfo3>? s;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(s, 1);

    if (s != null) {
      _dst = _dst.deferred;
      int _ss = count;
      _dst.enc_ndr_long(_ss);
      int _si = _dst.index;
      _dst.advance(20 * _ss);

      _dst = _dst.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        s![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _sp = _src.dec_ndr_long();

    if (_sp != 0) {
      _src = _src.deferred;
      int _ss = _src.dec_ndr_long();
      int _si = _src.index;
      _src.advance(20 * _ss);

      if (s == null) {
        if (_ss < 0 || _ss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        s = List.generate(
            _ss, (index) => netdfs_DfsInfo3()); // netdfs_DfsInfo3[_ss];
      }
      _src = _src.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        // if (s[_i] == null) {
        //   s[_i] = netdfs_DfsInfo3();
        // }
        s![_i].decode(_src);
      }
    }
  }
}

class netdfs_DfsInfo200 extends NdrObject {
  String? dfs_name;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(dfs_name, 1);

    if (dfs_name != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(dfs_name!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _dfs_namep = _src.dec_ndr_long();

    if (_dfs_namep != 0) {
      _src = _src.deferred;
      dfs_name = _src.dec_ndr_string();
    }
  }
}

class netdfs_DfsEnumArray200 extends NdrObject {
  int count = 0;
  List<netdfs_DfsInfo200>? s;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(s, 1);

    if (s != null) {
      _dst = _dst.deferred;
      int _ss = count;
      _dst.enc_ndr_long(_ss);
      int _si = _dst.index;
      _dst.advance(4 * _ss);

      _dst = _dst.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        s![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _sp = _src.dec_ndr_long();

    if (_sp != 0) {
      _src = _src.deferred;
      int _ss = _src.dec_ndr_long();
      int _si = _src.index;
      _src.advance(4 * _ss);

      if (s == null) {
        if (_ss < 0 || _ss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        s = List.generate(
            _ss, (index) => netdfs_DfsInfo200()); // netdfs_DfsInfo200[_ss];
      }
      _src = _src.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        // if (s[_i] == null) {
        //   s[_i] = netdfs_DfsInfo200();
        // }
        s![_i].decode(_src);
      }
    }
  }
}

class netdfs_DfsInfo300 extends NdrObject {
  int flags = 0;
  String? dfs_name;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(flags);
    _dst.enc_ndr_referent(dfs_name, 1);

    if (dfs_name != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(dfs_name!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    flags = _src.dec_ndr_long();
    int _dfs_namep = _src.dec_ndr_long();

    if (_dfs_namep != 0) {
      _src = _src.deferred;
      dfs_name = _src.dec_ndr_string();
    }
  }
}

class netdfs_DfsEnumArray300 extends NdrObject {
  int count = 0;
  List<netdfs_DfsInfo300>? s;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(s, 1);

    if (s != null) {
      _dst = _dst.deferred;
      int _ss = count;
      _dst.enc_ndr_long(_ss);
      int _si = _dst.index;
      _dst.advance(8 * _ss);

      _dst = _dst.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        s![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _sp = _src.dec_ndr_long();

    if (_sp != 0) {
      _src = _src.deferred;
      int _ss = _src.dec_ndr_long();
      int _si = _src.index;
      _src.advance(8 * _ss);

      if (s == null) {
        if (_ss < 0 || _ss > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        s = List.generate(
            _ss, (index) => netdfs_DfsInfo300()); // netdfs_DfsInfo300[_ss];
      }
      _src = _src.derive(_si);
      for (int _i = 0; _i < _ss; _i++) {
        // if (s[_i] == null) {
        //   s[_i] = netdfs_DfsInfo300();
        // }
        s![_i].decode(_src);
      }
    }
  }
}

class netdfs_DfsEnumStruct extends NdrObject {
  int level = 0;
  NdrObject? e;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(level);
    int _descr = level;
    _dst.enc_ndr_long(_descr);
    _dst.enc_ndr_referent(e, 1);

    if (e != null) {
      _dst = _dst.deferred;
      e!.encode(_dst);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    level = _src.dec_ndr_long();
    _src.dec_ndr_long(); /* union discriminant */
    int _ep = _src.dec_ndr_long();

    if (_ep != 0) {
      e ??= netdfs_DfsEnumArray1();
      _src = _src.deferred;
      e!.decode(_src);
    }
  }
}

class netdfs_NetrDfsEnumEx extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x15;
  }

  int retval = 0;
  String? dfs_name;
  int level = 0;
  int prefmaxlen;
  netdfs_DfsEnumStruct? info;
  NdrLong? totalentries;

  netdfs_NetrDfsEnumEx(
      this.dfs_name, this.level, this.prefmaxlen, this.info, this.totalentries);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_string(dfs_name!);
    _dst.enc_ndr_long(level);
    _dst.enc_ndr_long(prefmaxlen);
    _dst.enc_ndr_referent(info, 1);
    info!.encode(_dst);
    _dst.enc_ndr_referent(totalentries, 1);
    totalentries?.encode(_dst);
  }

  @override
  void decode_out(NdrBuffer _src) {
    int _infop = _src.dec_ndr_long();
    if (_infop != 0) {
      info ??= netdfs_DfsEnumStruct();
      info!.decode(_src);
    }
    int _totalentriesp = _src.dec_ndr_long();
    if (_totalentriesp != 0) {
      totalentries!.decode(_src);
    }
    retval = _src.dec_ndr_long();
  }
}
