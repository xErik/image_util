import 'dart:io';
import 'dart:ui' as ui;

import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:flutter_exif_plugin/tags.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;

class ImageGeneral {
  static Future<Uint8List> resize(Uint8List pngBytes,
      {int? width, int? height}) async {
    final bytes = await resizeImage(pngBytes, width: width, height: height);
    return bytes!.buffer.asUint8List();
  }

  static Future<Uint8List> compressToJpg(bytes, {int quality = 80}) async {
    Configuration config = Configuration(
      outputType: ImageOutputType.jpg,
      // can only be true for Android and iOS while using ImageOutputType.jpg or ImageOutputType.pngÏ
      useJpgPngNativeCompressor:
          kIsWeb == false && (Platform.isIOS || Platform.isAndroid),
      quality: quality,
    );

    final param = ImageFileConfiguration(
        input: ImageFile(filePath: "", rawBytes: bytes), config: config);
    return (await compressor.compress(param)).rawBytes;
  }

  static Future<Uint8List> setDpi(Uint8List imageBytes, int dpi) async {
    FlutterExif exif = FlutterExif.fromBytes(imageBytes);
    // await exif.setLatLong(20.0, 10.0);
    // await exif.setAttribute(TAG_USER_COMMENT, 'super duper user comment');
    // await exif.setAttribute(TAG_ARTIST, Strings.appUrl);
    await exif.setAttribute(TAG_X_RESOLUTION, '$dpi/1');
    await exif.setAttribute(TAG_Y_RESOLUTION, '$dpi/1');
    await exif.saveAttributes();
    final data = await exif.imageData;
    return data!;
  }

  static ui.Size getSize(Uint8List bytes) {
    final tmp = imgsize.ImageSizeGetter.getSize(imgsize.MemoryInput(bytes));
    return ui.Size(tmp.width.toDouble(), tmp.height.toDouble());
  }

  static Future<Uint8List> scaleDown(
    Uint8List bytes,
    int maxWidthOrHeight,
  ) async {
    final size = getSize(bytes);
    Uint8List ret = bytes;

    if (size.height > maxWidthOrHeight || size.width > maxWidthOrHeight) {
      if (size.width >= size.height) {
        ret = await resize(bytes, width: maxWidthOrHeight);
      } else {
        ret = await resize(bytes, height: maxWidthOrHeight);
      }
    }

    return ret;
  }
}
