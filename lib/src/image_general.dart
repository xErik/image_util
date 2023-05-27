import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;

import '../flutter_image_util.dart';

class ImageGeneral {
  // Compresses `bytes` to PNG.
  static Future<Uint8List> compressToPng(
      Uint8List pngBytes, double width, double height,
      {int quality = 100, int rotate = 0}) async {
    return await compress(pngBytes, width, height,
        format: ImageFormat.png, quality: quality);
  }

  /// Compresses `bytes` to JPG.
  static Future<Uint8List> compressToJpg(
      Uint8List pngBytes, double width, double height,
      {int quality = 100, int rotate = 0}) async {
    return await compress(pngBytes, width, height,
        format: ImageFormat.jpg, quality: quality);
  }

  /// Compresses `bytes` to WEBP.
  ///
  /// Only an Android.
  static Future<Uint8List> compressToWebp(
      Uint8List pngBytes, double width, double height,
      {int quality = 100, int rotate = 0}) async {
    return await compress(pngBytes, width, height,
        format: ImageFormat.webp, quality: quality);
  }

  /// Returns a list of valid compression formats. Currently
  ///
  /// jpeg,
  //  png,
  ///
  /// - iOS: Supported from iOS11+.
  /// - Android: Supported from API 28+ which require hardware encoder supports,
  ///   Use [HeifWriter](https://developer.android.com/reference/androidx/heifwriter/HeifWriter.html)
  /// heic,
  ///
  /// Only supported on Android.
  /// webp,
  static List<String> get compressFormats =>
      CompressFormat.values.map<String>((e) => e.name).toList();

  static Future<Uint8List> compress(
      Uint8List pngBytes, double width, double height,
      {int quality = 100,
      int rotate = 0,
      ImageFormat format = ImageFormat.jpg}) async {
    return await FlutterImageCompress.compressWithList(
      pngBytes,
      minWidth: width.toInt(),
      minHeight: height.toInt(),
      quality: quality,
      rotate: rotate,
      format: CompressFormat.values.firstWhere((e) => e.name == format.name),
    );
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

  /// Rotates and image.
  static Future<Uint8List> rotate(Uint8List bytes, int rotate,
      {ImageFormat format = ImageFormat.jpg}) async {
    rotate = rotate % 360;
    final size = getSize(bytes);
    return compress(bytes, size.width, size.height,
        format: format, rotate: rotate);
  }
}
