Various functions to load, save and maniupulate images as bytes.

Thin wrapper of various packages related to image processing.

## Usage

```dart
enum ImageFormat { jpg, png, webp }


// -------------------------------------------
// SAVE
// -------------------------------------------

/// Shares an image via Share-dialog.
///
/// If quality, size or dpi are given, they will be applied
/// before sharing the image.
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
/// Android: Saves in `album`. If the album is NULL its name will
/// be the image name.
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

/// Loads an image from the given  [url].
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

// -------------------------------------------
// GENERAL
// -------------------------------------------

/// Compresses `bytes` to PNG.
static Future<Uint8List> compressToPng(
  Uint8List pngBytes, double width, double height,
  {int quality = 100});

/// Compresses `bytes` to JPG.
static Future<Uint8List> compressToJpg(
  Uint8List pngBytes, double width, double height,
  {int quality = 100});

/// Compresses `bytes` to WEBP.
///
/// Only an Android.
static Future<Uint8List> compressToWebp(
  Uint8List pngBytes, double width, double height,
  [int quality = 100]);

/// Sets the DPI in EXIF.
static Future<Uint8List> setDpi(Uint8List imageBytes, int dpi);

/// Returns the `Size` of image bytes.
static Size getSize(Uint8List bytes);


/// Rotates and image.
static Future<Uint8List> rotate(Uint8List bytes, int rotate,
    {ImageFormat format = ImageFormat.jpg})
```
