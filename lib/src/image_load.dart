import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_util_flutter/src/image_general.dart';

class ImageLoad {
  static Future<Uint8List> loadImagePicker(
      {double? widthMax, double? heightMax, int quality = 80}) async {
    final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: widthMax,
        maxHeight: heightMax,
        imageQuality: quality);
    if (image != null) {
      if (kIsWeb) {
        // kIsWeb = http://localhost...
        // if (url.startsWith('/data') == false || kIsWeb) {
        return _loadFromUrl(image.path);
      } else {
        return await image.readAsBytes();
      }
    }

    return Uint8List(0);
  }

  static Future<Uint8List> loadImage({int? widthMax, int? heightMax}) async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpeg', 'jpg', 'png'],
    );
    final XFile? image =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (image != null) {
      if (kIsWeb) {
        // kIsWeb = http://localhost...
        // if (url.startsWith('/data') == false || kIsWeb) {
        final bytes = await _loadFromUrl(image.path);

        if (widthMax != null && heightMax != null) {
          return await ImageGeneral.resize(bytes,
              width: widthMax, height: heightMax);
        }

        return bytes;
      } else {
        final bytes = await image.readAsBytes();
        if (widthMax != null && heightMax != null) {
          return await ImageGeneral.resize(bytes,
              width: widthMax, height: heightMax);
        }
        return bytes;
      }
    }

    return Uint8List(0);
  }

  static Future<Uint8List> _loadFromUrl(String url) async {
    return (await http.get(Uri.parse(url))).bodyBytes;
  }
}
