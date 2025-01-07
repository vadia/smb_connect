import 'dart:typed_data';
import 'package:smb_connect/src/utils/base.dart';

import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/connect/impl/smb2/server_message_block2_response.dart';
import 'package:smb_connect/src/connect/smb_util.dart';

class Smb2TreeDisconnectResponse extends ServerMessageBlock2Response {
  Smb2TreeDisconnectResponse(super.config);

  @override
  @protected
  int writeBytesWireFormat(Uint8List dst, int dstIndex) {
    return 0;
  }

  @override
  @protected
  int readBytesWireFormat(Uint8List buffer, int bufferIndex) {
    int structureSize = SMBUtil.readInt2(buffer, bufferIndex);
    if (structureSize != 4) {
      throw SmbProtocolDecodingException("Structure size != 4");
    }

    return 4;
  }
}
