// ignore: avoid_web_libraries_in_flutter
import 'dart:developer';
import 'dart:html';
import 'dart:typed_data';

// import 'package:intl/intl.dart';

import 'download_abs.dart';

class DownloadControllerImp extends DownloadAbs {
  @override
  Future<String?> download(
      Uint8List bytes, String name, String? albumName) async {
    var success = await downloadFileWeb(bytes, name, '');

    if (success == true) {
      return name;
    }
    return null;
  }

  Future<bool> downloadFileWeb(
      Uint8List bytes, String name, String type) async {
    bool success = false;

    try {
      String url = Url.createObjectUrlFromBlob(Blob([bytes], type));
      HtmlDocument htmlDocument = document;
      AnchorElement anchor = htmlDocument.createElement('a') as AnchorElement;
      anchor.href = url;
      anchor.style.display = name;
      anchor.download = name;
      document.body!.children.add(anchor);
      anchor.click();
      document.body!.children.remove(anchor);
      success = true;
    } catch (e) {
      // logx(e.toString(), this);
      log(e.toString());
    }
    return success;
  }
}
