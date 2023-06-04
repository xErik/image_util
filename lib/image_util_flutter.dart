library image_util;

import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:image_util_flutter/src/image_general.dart';
import 'package:image_util_flutter/src/image_load.dart';
import 'package:image_util_flutter/src/image_save.dart';

// enum ImageFormat { jpeg, png, webp }

/// Assortment of methods to load, save, share and manipulate images.
class ImageUtilFlutter {
  // --------------------------------------------------------------------
  // SAVE
  // --------------------------------------------------------------------

  /// Shares an image via Share-dialog.
  ///
  /// If quality, size or dpi are given, they will be applied
  /// before sharing the image.
  ///
  /// ### Sharing on Web
  ///
  /// Sharing on Web does not work. Use `saveToJpg()` instead.
  ///
  /// ### How to get the render box:
  /// ```
  /// if(context.mounted) {
  ///   final RenderBox? box = context.findRenderObject() as RenderBox?;
  /// }
  /// ```
  static Future<void> shareAsJpg(
    String title,
    String message,
    Uint8List bytes,
    final RenderBox? box, {
    int quality = 100,
    Size? size,
    int? dpi,
    int rotate = 0,
  }) async {
    return ImageSave.shareAsJpg(title, message, bytes, box,
        quality: quality, size: size, dpi: dpi);
  }

  /// Shares an image via Share-dialog.
  ///
  /// If quality, size or dpi are given, they will be applied
  /// before sharing the image.
  ///
  /// ### Sharing on Web
  ///
  /// Sharing on Web does not work. Use `saveToJpg()` instead.
  ///
  /// ### How to get the render box:
  /// ```
  /// if(context.mounted) {
  ///   final RenderBox? box = context.findRenderObject() as RenderBox?;
  /// }
  /// ```
  static Future<void> shareAsPng(
    String title,
    String message,
    Uint8List bytes,
    final RenderBox? box, {
    Size? size,
  }) async {
    return ImageSave.shareAsPng(title, message, bytes, box, size: size);
  }

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If the album is NULL its name will
  /// be the image name.
  ///
  /// Returns the String-path of the created File.
  ///
  /// Default: JPG.
  static Future<String?> saveAsJpg(
    Uint8List bytes,
    String name, {
    String? album,
    int quality = 100,
    Size? size,
    int? dpi,
    int rotate = 0,
  }) async {
    return ImageSave.saveAsJpg(bytes, name,
        album: album, quality: quality, size: size, dpi: dpi);
  }

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If the album is NULL its name will
  /// be the image name.
  ///
  /// Returns the String-path of the created File.
  ///
  /// Default: JPG.
  static Future<String?> saveAsPng(
    Uint8List bytes,
    String name, {
    String? album,
    Size? size,
  }) async {
    return ImageSave.saveAsPng(bytes, name, album: album, size: size);
  }

  // --------------------------------------------------------------------
  // LOAD
  // --------------------------------------------------------------------

  static Future<Uint8List> load({int? widthMax, int? heightMax}) async {
    return await ImageLoad.loadImage(widthMax: widthMax, heightMax: heightMax);
  }

  static Future<Uint8List> loadPicker(
      {double? widthMax, double? heightMax, int quality = 80}) async {
    return ImageLoad.loadImagePicker(
        widthMax: widthMax, heightMax: heightMax, quality: quality);
  }

  // --------------------------------------------------------------------
  // GENERAL
  // --------------------------------------------------------------------

  /// Sets the DPI in EXIF.
  static Future<Uint8List> setDpi(Uint8List imageBytes, int dpi) async =>
      ImageGeneral.setDpi(imageBytes, dpi);

  /// Returns the `Size` of image bytes.
  static Size getSize(Uint8List bytes) => ImageGeneral.getSize(bytes);

  static Future<Uint8List> compress(bytes, {int quality = 80}) async =>
      ImageGeneral.compressToJpg(bytes, quality: quality);

  static Future<Uint8List> scaleDown(
    Uint8List bytes,
    int maxWidthOrHeight,
  ) async =>
      ImageGeneral.scaleDown(bytes, maxWidthOrHeight);

  static Future<Uint8List> compressToJpg(Uint8List bytes,
      {int quality = 80}) async {
    return ImageGeneral.compressToJpg(bytes, quality: quality);
  }
}
