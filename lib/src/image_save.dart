import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../image_util_flutter.dart';
import '../src/image_general.dart';
import 'image_save/download_stub.dart'
    if (dart.library.io) 'download_io.dart'
    if (dart.library.html) 'download_html.dart';

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
  static Future<void> shareAs(
      String title, String message, Uint8List bytes, final RenderBox? box,
      {int quality = 100,
      Size? size,
      int? dpi,
      int rotate = 0,
      ImageFormat format = ImageFormat.jpg}) async {
    if (kIsWeb) {
      throw 'Sharing does not work on Web, use saveToJpg() instead.';
    }

    size ??= ImageGeneral.getSize(bytes);

    Uint8List jpegBytes = await ImageGeneral.compress(
      bytes,
      size.width,
      size.height,
      quality: quality,
      rotate: rotate,
      format: format,
    );

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

    // _deleteFile(filePath);
  }

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If the album is NULL its name will
  /// be the image name.
  ///
  /// Returns the String-path of the created File.
  static Future<String?> saveAs(
      ImageFormat format, Uint8List bytes, String name,
      {String? album,
      int quality = 100,
      Size? size,
      int? dpi,
      int rotate = 0}) async {
    size ??= ImageGeneral.getSize(bytes);

    if (kIsWeb == false && (album == null || album.isEmpty)) {
      album = name;
    }

    var jpegBytes = await ImageGeneral.compress(
      bytes,
      size.width,
      size.height,
      format: format,
      quality: quality,
      rotate: rotate,
    );

    if (dpi != null) {
      jpegBytes = await ImageGeneral.setDpi(jpegBytes, dpi);
    }

    final downloadImp = DownloadControllerImp();
    return await downloadImp.download(jpegBytes, name, album);
  }
}
