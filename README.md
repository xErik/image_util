Functions to load, save, share and manipulate images as bytes.

Thin wrapper of various packages related to image processing.

**This is an internal package, unlikely that you want to use it.**

## Note

* Web: `saveAs()` triggers a download.
* App: `saveAs()` saves to gallery.
* Web: `shareAs()` is not working.

This package is meant to be used in Flutter.

## Usage

```dart
enum ImageFormat { jpg, png, webp }

FlutterImageUtil {
    
  // -------------------------------------------
  // SAVE
  // -------------------------------------------

  /// Shares an image via Share-dialog.
  ///
  /// Default: JPG.
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
      String title,
      String message,
      Uint8List bytes,
      final RenderBox? box, {
      int quality = 100,
      Size? size,
      int? dpi,
      int rotate = 0,
      ImageFormat format = ImageFormat.jpg,
  });

  /// Web: Downloads the file via Browser.
  ///
  /// Android: Saves in `album`. If album is NULL 
  /// its name will be the name of the image.
  ///
  /// Returns the String-path of the created File.
  ///
  /// Default: JPG.
  static Future<String?> saveAs(
      Uint8List bytes,
      String name, {
      String? album,
      int quality = 100,
      Size? size,
      int? dpi,
      int rotate = 0,
      ImageFormat format = ImageFormat.jpg,
  });

  // -------------------------------------------
  // LOAD
  // -------------------------------------------

  /// Loads an image from the given [url].
  ///
  /// Keep in mind to adjust the server CORS settings.
  static Future<Uint8List> loadFromWeb(
    double widthMax, double heightMax, int quality, url);

  /// Loads an image from the local gallery.
  static Future<Uint8List> loadFromGallery(
    double widthMax, double heightMax, int quality);

  /// Loads an image using the local camera.
  static Future<Uint8List> loadFromCamera(
    double widthMax, double heightMax, int quality);
}
```
