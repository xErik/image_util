import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter_exif_plugin/flutter_exif_plugin.dart';
import 'package:flutter_exif_plugin/tags.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_size_getter/image_size_getter.dart' as imgsize;
import 'package:image_util_flutter/image_util_flutter.dart';

class ImageGeneral {
  // Compresses `bytes` to PNG.
  static Future<Uint8List> compressToPng(Uint8List pngBytes,
      {double? width,
      double? height,
      int? quality = 100,
      int rotate = 0}) async {
    return await compress(pngBytes,
        width: width,
        height: height,
        format: ImageFormat.png,
        quality: quality);
  }

  /// Compresses `bytes` to JPG.
  static Future<Uint8List> compressToJpg(Uint8List pngBytes,
      {double? width,
      double? height,
      int? quality = 100,
      int rotate = 0}) async {
    return await compress(pngBytes,
        width: width,
        height: height,
        format: ImageFormat.jpeg,
        quality: quality);
  }

  /// Compresses `bytes` to WEBP.
  ///
  /// Only an Android.
  static Future<Uint8List> compressToWebp(Uint8List pngBytes,
      {double? width,
      double? height,
      int? quality = 100,
      int rotate = 0}) async {
    return await compress(pngBytes,
        width: width,
        height: height,
        format: ImageFormat.webp,
        quality: quality);
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

  static Future<Uint8List> compress(Uint8List pngBytes,
      {double? width,
      double? height,
      int? quality = 100,
      int rotate = 0,
      ImageFormat format = ImageFormat.jpeg}) async {
    if (width == null || height == null) {
      final size = getSize(pngBytes);
      width = size.width;
      height = size.height;
    }
    return await FlutterImageCompress.compressWithList(
      pngBytes,
      minWidth: width.toInt(),
      minHeight: height.toInt(),
      quality: quality ?? 100,
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
      {ImageFormat format = ImageFormat.jpeg}) async {
    rotate = rotate % 360;
    final size = getSize(bytes);
    return compress(bytes,
        width: size.width, height: size.height, format: format, rotate: rotate);
  }

  static Future<Uint8List> scaleUp(Uint8List bytes, double minWidthOrHeight,
      {ImageFormat format = ImageFormat.jpeg}) async {
    final size = getSize(bytes);
    Uint8List ret = bytes;

    if (size.height < minWidthOrHeight || size.width < minWidthOrHeight) {
      if (size.width <= size.height) {
        final targetWidth = minWidthOrHeight;
        final targetHeight = (minWidthOrHeight / size.width) * size.height;
        ret = await compress(bytes,
            format: format, width: targetWidth, height: targetHeight);
      } else {
        final targetHeight = minWidthOrHeight;
        final targetWidth = (minWidthOrHeight / size.height) * size.width;
        ret = await compress(bytes,
            format: format, width: targetWidth, height: targetHeight);
      }
    }

    return ret;
  }

  static Future<Uint8List> scaleDown(Uint8List bytes, double maxWidthOrHeight,
      {ImageFormat format = ImageFormat.jpeg}) async {
    final size = getSize(bytes);
    Uint8List ret = bytes;

    if (size.height > maxWidthOrHeight || size.width > maxWidthOrHeight) {
      if (size.width >= size.height) {
        final targetWidth = maxWidthOrHeight;
        final targetHeight = (maxWidthOrHeight / size.width) * size.height;
        ret = await compress(bytes,
            format: format, width: targetWidth, height: targetHeight);
      } else {
        final targetHeight = maxWidthOrHeight;
        final targetWidth = (maxWidthOrHeight / size.height) * size.width;
        ret = await compress(bytes,
            format: format, width: targetWidth, height: targetHeight);
      }
    }

    return ret;
  }
}
