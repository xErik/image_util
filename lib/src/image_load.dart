import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_util_flutter/src/image_general.dart';

class ImageLoad {
  static Future<Uint8List> loadImageWeb(String url,
      {double? widthMax, double? heightMax, int? quality}) async {
    return await _loadFromUrlAndResize(url,
        widthMax: widthMax, heightMax: heightMax, quality: quality);
  }

  static Future<Uint8List> loadImageGallery(
      {double? widthMax, double? heightMax, int? quality}) async {
    return _loadImage(false,
        widthMax: widthMax, heightMax: heightMax, quality: quality);
  }

  static Future<Uint8List> loadImageCamera(
      {double? widthMax, double? heightMax, int? quality}) async {
    return _loadImage(true,
        widthMax: widthMax, heightMax: heightMax, quality: quality);
  }

  static Future<Uint8List> _loadImage(bool loadCamera,
      {double? widthMax, double? heightMax, int? quality}) async {
    final XFile? image = await ImagePicker().pickImage(
        source: loadCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: widthMax,
        maxHeight: heightMax,
        imageQuality: quality);
    if (image != null) {
      if (kIsWeb) {
        // kIsWeb = http://localhost...
        // if (url.startsWith('/data') == false || kIsWeb) {
        return _loadFromUrl(image.path);
      } else {
        final bytes = await image.readAsBytes();
        if (widthMax != null && heightMax != null) {
          return await ImageGeneral.compressToJpg(bytes,
              width: widthMax, height: heightMax, quality: quality);
        }
        return bytes;
      }
    }

    return Uint8List(0);
  }

  static Future<Uint8List> _loadFromUrl(String url) async {
    return (await http.get(Uri.parse(url))).bodyBytes;
  }

  static Future<Uint8List> _loadFromUrlAndResize(String url,
      {double? widthMax, double? heightMax, int? quality}) async {
    Uint8List bytes = (await _loadFromUrl(url));
    if (widthMax != null && heightMax != null) {
      return await ImageGeneral.compressToJpg(bytes,
          width: widthMax, height: heightMax, quality: quality);
    }
    return bytes;
  }
}
