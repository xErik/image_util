import 'dart:typed_data';

abstract class DownloadAbs {
  Future<String?> download(Uint8List bytes, String name, String? albumName);
}
