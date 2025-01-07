import 'package:smb_connect/src/exceptions.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_binding.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_constants.dart';
import 'package:smb_connect/src/dcerpc/dcerpc_message.dart';
import 'package:smb_connect/src/dcerpc/ndr/ndr_buffer.dart';
import 'package:smb_connect/src/utils/strings.dart';

class DcerpcBind extends DcerpcMessage {
  static final List<String> result_message = [
    "0",
    "DcerpcConstants.DCERPC_BIND_ERR_ABSTRACT_SYNTAX_NOT_SUPPORTED",
    "DcerpcConstants.DCERPC_BIND_ERR_PROPOSED_TRANSFER_SYNTAXES_NOT_SUPPORTED",
    "DcerpcConstants.DCERPC_BIND_ERR_LOCAL_LIMIT_EXCEEDED"
  ];

  static String _getResultMessage(int result) {
    return result < 4
        ? result_message[result]
        : "0x${Hexdump.toHexString(result, 4)}";
  }

  @override
  DcerpcException? getResult() {
    if (result != 0) return DcerpcException(_getResultMessage(result));
    return null;
  }

  DcerpcBinding? binding;
  final int _max_xmit, _max_recv;

  /// Construct bind message
  // DcerpcBind() {}

  DcerpcBind({this.binding, int? maxXmit, int? maxRecv}) //DcerpcHandle? handle
      : _max_xmit = maxXmit ?? 0,
        _max_recv = maxRecv ?? 0 {
    ptype = 11;
    flags =
        DcerpcConstants.DCERPC_FIRST_FRAG | DcerpcConstants.DCERPC_LAST_FRAG;
  }

  @override
  int getOpnum() {
    return 0;
  }

  @override
  void encode_in(NdrBuffer buf) {
    buf.enc_ndr_short(_max_xmit);
    buf.enc_ndr_short(_max_recv);
    buf.enc_ndr_long(0); /* assoc. group */
    buf.enc_ndr_small(1); /* num context items */
    buf.enc_ndr_small(0); /* reserved */
    buf.enc_ndr_short(0); /* reserved2 */
    buf.enc_ndr_short(0); /* context id */
    buf.enc_ndr_small(1); /* number of items */
    buf.enc_ndr_small(0); /* reserved */
    binding!.getUuid()!.encode(buf);
    buf.enc_ndr_short(binding!.getMajor());
    buf.enc_ndr_short(binding!.getMinor());
    DcerpcConstants.DCERPC_UUID_SYNTAX_NDR.encode(buf);
    buf.enc_ndr_long(2); /* syntax version */
  }

  @override
  void decode_out(NdrBuffer buf) {
    buf.dec_ndr_short(); /* max transmit frag size */
    buf.dec_ndr_short(); /* max receive frag size */
    buf.dec_ndr_long(); /* assoc. group */
    int n = buf.dec_ndr_short(); /* secondary addr len */
    buf.advance(n); /* secondary addr */
    buf.align(4);
    buf.dec_ndr_small(); /* num results */
    buf.align(4);
    result = buf.dec_ndr_short();
    buf.dec_ndr_short();
    buf.advance(20); /* transfer syntax / version */
  }
}
