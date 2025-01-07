// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_renaming_method_parameters, camel_case_types
import 'dart:typed_data';

import 'package:smb_connect/src/exceptions.dart';

import '../dcerpc_message.dart';
import '../ndr/ndr_buffer.dart';
import '../ndr/ndr_object.dart';

String srvsvc_getSyntax() {
  return "4b324fc8-1670-01d3-1278-5a47bf6ee188:3.0";
}

class srvsvc_ShareInfo0 extends NdrObject {
  String? netname;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(netname, 1);

    if (netname != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(netname!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _netnamep = _src.dec_ndr_long();

    if (_netnamep != 0) {
      _src = _src.deferred;
      netname = _src.dec_ndr_string();
    }
  }
}

class srvsvc_ShareInfoCtr0 extends NdrObject {
  int count = 0;
  List<srvsvc_ShareInfo0>? array;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(array, 1);

    if (array != null) {
      _dst = _dst.deferred;
      int _arrays = count;
      _dst.enc_ndr_long(_arrays);
      int _arrayi = _dst.index;
      _dst.advance(4 * _arrays);

      _dst = _dst.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        array![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _arrayp = _src.dec_ndr_long();

    if (_arrayp != 0) {
      _src = _src.deferred;
      int _arrays = _src.dec_ndr_long();
      int _arrayi = _src.index;
      _src.advance(4 * _arrays);

      if (array == null) {
        if (_arrays < 0 || _arrays > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        array = List.generate(
            _arrays, (index) => srvsvc_ShareInfo0()); // ShareInfo0[_arrays];
      }
      _src = _src.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        // if (array[_i] == null) {
        //   array[_i] = ShareInfo0();
        // }
        array![_i].decode(_src);
      }
    }
  }
}

class srvsvc_ShareInfo1 extends NdrObject {
  String? netname;
  int type = 0;
  String? remark;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(netname, 1);
    _dst.enc_ndr_long(type);
    _dst.enc_ndr_referent(remark, 1);

    if (netname != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(netname!);
    }
    if (remark != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(remark!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _netnamep = _src.dec_ndr_long();
    type = _src.dec_ndr_long();
    int _remarkp = _src.dec_ndr_long();

    if (_netnamep != 0) {
      _src = _src.deferred;
      netname = _src.dec_ndr_string();
    }
    if (_remarkp != 0) {
      _src = _src.deferred;
      remark = _src.dec_ndr_string();
    }
  }
}

class srvsvc_ShareInfoCtr1 extends NdrObject {
  int count = 0;
  List<srvsvc_ShareInfo1>? array;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(array, 1);

    if (array != null) {
      _dst = _dst.deferred;
      int _arrays = count;
      _dst.enc_ndr_long(_arrays);
      int _arrayi = _dst.index;
      _dst.advance(12 * _arrays);

      _dst = _dst.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        array![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _arrayp = _src.dec_ndr_long();

    if (_arrayp != 0) {
      _src = _src.deferred;
      int _arrays = _src.dec_ndr_long();
      int _arrayi = _src.index;
      _src.advance(12 * _arrays);

      if (array == null) {
        if (_arrays < 0 || _arrays > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        array = List.generate(
            _arrays, (index) => srvsvc_ShareInfo1()); // ShareInfo1[_arrays];
      }
      _src = _src.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        // if (array[_i] == null) {
        //   array[_i] = ShareInfo1();
        // }
        array![_i].decode(_src);
      }
    }
  }
}

class srvsvc_ShareInfo502 extends NdrObject {
  String? netname;
  int type = 0;
  String? remark;
  int permissions = 0;
  int max_uses = 0;
  int current_uses = 0;
  String? path;
  String? password;
  int sd_size = 0;
  Uint8List? security_descriptor;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_referent(netname, 1);
    _dst.enc_ndr_long(type);
    _dst.enc_ndr_referent(remark, 1);
    _dst.enc_ndr_long(permissions);
    _dst.enc_ndr_long(max_uses);
    _dst.enc_ndr_long(current_uses);
    _dst.enc_ndr_referent(path, 1);
    _dst.enc_ndr_referent(password, 1);
    _dst.enc_ndr_long(sd_size);
    _dst.enc_ndr_referent(security_descriptor, 1);

    if (netname != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(netname!);
    }
    if (remark != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(remark!);
    }
    if (path != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(path!);
    }
    if (password != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(password!);
    }
    if (security_descriptor != null) {
      _dst = _dst.deferred;
      int _security_descriptors = sd_size;
      _dst.enc_ndr_long(_security_descriptors);
      int _security_descriptori = _dst.index;
      _dst.advance(1 * _security_descriptors);

      _dst = _dst.derive(_security_descriptori);
      for (int _i = 0; _i < _security_descriptors; _i++) {
        _dst.enc_ndr_small(security_descriptor![_i]);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    int _netnamep = _src.dec_ndr_long();
    type = _src.dec_ndr_long();
    int _remarkp = _src.dec_ndr_long();
    permissions = _src.dec_ndr_long();
    max_uses = _src.dec_ndr_long();
    current_uses = _src.dec_ndr_long();
    int _pathp = _src.dec_ndr_long();
    int _passwordp = _src.dec_ndr_long();
    sd_size = _src.dec_ndr_long();
    int _security_descriptorp = _src.dec_ndr_long();

    if (_netnamep != 0) {
      _src = _src.deferred;
      netname = _src.dec_ndr_string();
    }
    if (_remarkp != 0) {
      _src = _src.deferred;
      remark = _src.dec_ndr_string();
    }
    if (_pathp != 0) {
      _src = _src.deferred;
      path = _src.dec_ndr_string();
    }
    if (_passwordp != 0) {
      _src = _src.deferred;
      password = _src.dec_ndr_string();
    }
    if (_security_descriptorp != 0) {
      _src = _src.deferred;
      int _security_descriptors = _src.dec_ndr_long();
      int _security_descriptori = _src.index;
      _src.advance(1 * _security_descriptors);

      if (security_descriptor == null) {
        if (_security_descriptors < 0 || _security_descriptors > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        security_descriptor =
            Uint8List(_security_descriptors); //[_security_descriptors];
      }
      _src = _src.derive(_security_descriptori);
      for (int _i = 0; _i < _security_descriptors; _i++) {
        security_descriptor![_i] = _src.dec_ndr_small();
      }
    }
  }
}

class srvsvc_ShareInfoCtr502 extends NdrObject {
  int count = 0;
  List<srvsvc_ShareInfo502>? array;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(count);
    _dst.enc_ndr_referent(array, 1);

    if (array != null) {
      _dst = _dst.deferred;
      int _arrays = count;
      _dst.enc_ndr_long(_arrays);
      int _arrayi = _dst.index;
      _dst.advance(40 * _arrays);

      _dst = _dst.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        array![_i].encode(_dst);
      }
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    count = _src.dec_ndr_long();
    int _arrayp = _src.dec_ndr_long();

    if (_arrayp != 0) {
      _src = _src.deferred;
      int _arrays = _src.dec_ndr_long();
      int _arrayi = _src.index;
      _src.advance(40 * _arrays);

      if (array == null) {
        if (_arrays < 0 || _arrays > 0xFFFF) {
          throw NdrException(NdrException.INVALID_CONFORMANCE);
        }
        array = List.generate(_arrays,
            (index) => srvsvc_ShareInfo502()); // ShareInfo502[_arrays];
      }
      _src = _src.derive(_arrayi);
      for (int _i = 0; _i < _arrays; _i++) {
        // if (array[_i] == null) {
        //   array[_i] = ShareInfo502();
        // }
        array![_i].decode(_src);
      }
    }
  }
}

class srvsvc_ShareEnumAll extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x0f;
  }

  int retval = 0;
  String? servername;
  int level;
  NdrObject? info;
  int prefmaxlen;
  int totalentries;
  int resume_handle;

  srvsvc_ShareEnumAll(this.servername, this.level, this.info, this.prefmaxlen,
      this.totalentries, this.resume_handle);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(servername, 1);
    if (servername != null) {
      _dst.enc_ndr_string(servername!);
    }
    _dst.enc_ndr_long(level);
    int _descr = level;
    _dst.enc_ndr_long(_descr);
    _dst.enc_ndr_referent(info, 1);
    if (info != null) {
      _dst = _dst.deferred;
      info!.encode(_dst);
    }
    _dst.enc_ndr_long(prefmaxlen);
    _dst.enc_ndr_long(resume_handle);
  }

  @override
  void decode_out(NdrBuffer _src) {
    level = _src.dec_ndr_long();
    _src.dec_ndr_long(); /* union discriminant */
    int _infop = _src.dec_ndr_long();
    if (_infop != 0) {
      info ??= srvsvc_ShareInfoCtr0();
      _src = _src.deferred;
      info!.decode(_src);
    }
    totalentries = _src.dec_ndr_long();
    resume_handle = _src.dec_ndr_long();
    retval = _src.dec_ndr_long();
  }
}

class srvsvc_ShareGetInfo extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x10;
  }

  int retval = 0;
  String? servername;
  String sharename;
  int level;
  NdrObject? info;

  srvsvc_ShareGetInfo(this.servername, this.sharename, this.level, this.info);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(servername, 1);
    if (servername != null) {
      _dst.enc_ndr_string(servername!);
    }
    _dst.enc_ndr_string(sharename);
    _dst.enc_ndr_long(level);
  }

  @override
  void decode_out(NdrBuffer _src) {
    _src.dec_ndr_long(); /* union discriminant */
    int _infop = _src.dec_ndr_long();
    if (_infop != 0) {
      info ??= srvsvc_ShareInfo0();
      _src = _src.deferred;
      info!.decode(_src);
    }
    retval = _src.dec_ndr_long();
  }
}

class srvsvc_ServerInfo100 extends NdrObject {
  int platform_id = 0;
  String? name;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(platform_id);
    _dst.enc_ndr_referent(name, 1);

    if (name != null) {
      _dst = _dst.deferred;
      _dst.enc_ndr_string(name!);
    }
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    platform_id = _src.dec_ndr_long();
    int _namep = _src.dec_ndr_long();

    if (_namep != 0) {
      _src = _src.deferred;
      name = _src.dec_ndr_string();
    }
  }
}

class srvsvc_ServerGetInfo extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x15;
  }

  int retval = 0;
  String? servername;
  int level;
  NdrObject? info;

  srvsvc_ServerGetInfo(this.servername, this.level, this.info);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(servername, 1);
    if (servername != null) {
      _dst.enc_ndr_string(servername!);
    }
    _dst.enc_ndr_long(level);
  }

  @override
  void decode_out(NdrBuffer _src) {
    _src.dec_ndr_long(); /* union discriminant */
    int _infop = _src.dec_ndr_long();
    if (_infop != 0) {
      info ??= srvsvc_ServerInfo100();
      _src = _src.deferred;
      info!.decode(_src);
    }
    retval = _src.dec_ndr_long();
  }
}

class srvsvc_TimeOfDayInfo extends NdrObject {
  int elapsedt = 0;
  int msecs = 0;
  int hours = 0;
  int mins = 0;
  int secs = 0;
  int hunds = 0;
  int timezone = 0;
  int tinterval = 0;
  int day = 0;
  int month = 0;
  int year = 0;
  int weekday = 0;

  @override
  void encode(NdrBuffer _dst) {
    _dst.align(4);
    _dst.enc_ndr_long(elapsedt);
    _dst.enc_ndr_long(msecs);
    _dst.enc_ndr_long(hours);
    _dst.enc_ndr_long(mins);
    _dst.enc_ndr_long(secs);
    _dst.enc_ndr_long(hunds);
    _dst.enc_ndr_long(timezone);
    _dst.enc_ndr_long(tinterval);
    _dst.enc_ndr_long(day);
    _dst.enc_ndr_long(month);
    _dst.enc_ndr_long(year);
    _dst.enc_ndr_long(weekday);
  }

  @override
  void decode(NdrBuffer _src) {
    _src.align(4);
    elapsedt = _src.dec_ndr_long();
    msecs = _src.dec_ndr_long();
    hours = _src.dec_ndr_long();
    mins = _src.dec_ndr_long();
    secs = _src.dec_ndr_long();
    hunds = _src.dec_ndr_long();
    timezone = _src.dec_ndr_long();
    tinterval = _src.dec_ndr_long();
    day = _src.dec_ndr_long();
    month = _src.dec_ndr_long();
    year = _src.dec_ndr_long();
    weekday = _src.dec_ndr_long();
  }
}

class srvsvc_RemoteTOD extends DcerpcMessage {
  @override
  int getOpnum() {
    return 0x1c;
  }

  int retval = 0;
  String? servername;
  srvsvc_TimeOfDayInfo? info;

  srvsvc_RemoteTOD(this.servername, this.info);

  @override
  void encode_in(NdrBuffer _dst) {
    _dst.enc_ndr_referent(servername, 1);
    if (servername != null) {
      _dst.enc_ndr_string(servername!);
    }
  }

  @override
  void decode_out(NdrBuffer _src) {
    int _infop = _src.dec_ndr_long();
    if (_infop != 0) {
      info ??= srvsvc_TimeOfDayInfo();
      info!.decode(_src);
    }
    retval = _src.dec_ndr_long();
  }
}
