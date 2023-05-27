import 'package:flutter/foundation.dart';
import 'package:flutter_image_util/src/image_general.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageLoad {
  static Future<Uint8List> loadImageWeb(
      double widthMax, double heightMax, int quality, url) async {
    return await _loadFromUrlAndResize(url, widthMax, heightMax, quality);
  }

  static Future<Uint8List> loadImageGallery(
      double widthMax, double heightMax, int quality) async {
    return _loadImage(false, widthMax, heightMax, quality);
  }

  static Future<Uint8List> loadImageCamera(
      double widthMax, double heightMax, int quality) async {
    return _loadImage(true, widthMax, heightMax, quality);
  }

  static Future<Uint8List> _loadImage(
      bool loadCamera, double widthMax, double heightMax, int quality) async {
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
        return await ImageGeneral.compressToJpg(bytes, widthMax, heightMax);
      }
    }

    return Uint8List(0);
  }

  static Future<Uint8List> _loadFromUrl(String url) async {
    return (await http.get(Uri.parse(url))).bodyBytes;
  }

  static Future<Uint8List> _loadFromUrlAndResize(
      String url, double widthMax, double heightMax, int quality) async {
    Uint8List? bytes = (await _loadFromUrl(url));
    return await ImageGeneral.compressToJpg(bytes, widthMax, heightMax,
        quality: quality);
  }
}
