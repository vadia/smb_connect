import 'dart:typed_data';
import 'package:smb_connect/src/connect/impl/smb1/smb_com_constants.dart';
import 'package:smb_connect/src/utils/base.dart';
import 'package:smb_connect/src/connect/impl/smb1/server_message_block.dart';

class SmbComQueryInformation extends ServerMessageBlock {
  SmbComQueryInformation(super.config, String filename)
      : super(
            command: SmbComConstants.SMB_COM_QUERY_INFORMATION, path: filename);

  @override
  @protected
  int writeParameterWordsWireFormat(Uint8List dst, int dstIndex) {
    return 0;
  }

  @override
  @protected
  int writeBytesWireFormat(Uint8List dst, int dstIndex) {
    int start = dstIndex;
    dst[dstIndex++] = 0x04;
    dstIndex += writeString(path!, dst, dstIndex);
    return dstIndex - start;
  }

  @override
  @protected
  int readParameterWordsWireFormat(Uint8List buffer, int bufferIndex) {
    return 0;
  }

  @override
  @protected
  int readBytesWireFormat(Uint8List buffer, int bufferIndex) {
    return 0;
  }

  @override
  String toString() {
    return "SmbComQueryInformation[${super.toString()},filename=$path]";
  }
}
