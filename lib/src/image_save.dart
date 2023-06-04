import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_util_flutter/src/image_general.dart';
import 'package:share_plus/share_plus.dart';

import 'image_save/download_stub.dart'
    if (dart.library.io) 'image_save/download_io.dart'
    if (dart.library.html) 'image_save/download_html.dart';

/// Utility to save and share images.
///
/// Offers additional service methods.
class ImageSave {
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
      String title, String message, Uint8List bytes, final RenderBox? box,
      {int quality = 80, Size? size, int? dpi}) async {
    if (kIsWeb) {
      throw 'Sharing does not work on Web, use saveToJpg() instead.';
    }

    if (size != null) {
      bytes = await ImageGeneral.resize(
        bytes,
        width: size.width.toInt(),
        height: size.height.toInt(),
      );
    }

    Uint8List jpegBytes =
        await ImageGeneral.compressToJpg(bytes, quality: quality);

    if (dpi != null) {
      jpegBytes = await ImageGeneral.setDpi(jpegBytes, dpi);
    }
    await Share.shareXFiles(
      [XFile.fromData(jpegBytes)],
      subject: title,
      text: message,
      sharePositionOrigin:
          box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    );
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
      String title, String message, Uint8List bytes, final RenderBox? box,
      {Size? size}) async {
    if (kIsWeb) {
      throw 'Sharing does not work on Web, use saveToPng() instead.';
    }

    if (size != null) {
      bytes = await ImageGeneral.resize(
        bytes,
        width: size.width.toInt(),
        height: size.height.toInt(),
      );
    }

    await Share.shareXFiles(
      [XFile.fromData(bytes)],
      subject: title,
      text: message,
      sharePositionOrigin:
          box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    );
  }

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If the album is NULL its name will
  /// be the image name.
  ///
  /// Returns the String-path of the created File.
  static Future<String?> saveAsJpg(Uint8List bytes, String name,
      {String? album, int quality = 80, Size? size, int? dpi}) async {
    if (kIsWeb == false && (album == null || album.isEmpty)) {
      album = name;
    }

    if (size != null) {
      bytes = await ImageGeneral.resize(
        bytes,
        width: size.width.toInt(),
        height: size.height.toInt(),
        // format: format,
        // quality: quality,
        // rotate: rotate,
      );
    }

    Uint8List jpegBytes =
        await ImageGeneral.compressToJpg(bytes, quality: quality);

    if (dpi != null) {
      jpegBytes = await ImageGeneral.setDpi(jpegBytes, dpi);
    }

    final downloadImp = DownloadControllerImp();
    return await downloadImp.download(jpegBytes, name, album);
  }

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If the album is NULL its name will
  /// be the image name.
  ///
  /// Returns the String-path of the created File.
  static Future<String?> saveAsPng(Uint8List bytes, String name,
      {String? album, Size? size}) async {
    if (kIsWeb == false && (album == null || album.isEmpty)) {
      album = name;
    }

    if (size != null) {
      bytes = await ImageGeneral.resize(
        bytes,
        width: size.width.toInt(),
        height: size.height.toInt(),
      );
    }

    final downloadImp = DownloadControllerImp();
    return await downloadImp.download(bytes, name, album);
  }
}
