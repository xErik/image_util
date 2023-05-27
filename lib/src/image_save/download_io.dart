import 'dart:typed_data';

import 'package:image_save/image_save.dart';

import 'download_abs.dart';

class DownloadControllerImp extends DownloadAbs {
  @override
  Future<String?> download(
      Uint8List bytes, String name, String? albumName) async {
    final bool? res =
        await ImageSave.saveImage(bytes, name, albumName: albumName);
    if (res == null || res == false) {
      return null;
    }
    return '$albumName/$name';
  }
}
