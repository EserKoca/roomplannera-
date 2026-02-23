import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<String> imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return base64Encode(bytes);
  }

  static Future<File> copyToAppDir(File source, String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    final destPath = '${dir.path}/$filename';
    return source.copy(destPath);
  }

  static Future<void> deleteLocalImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
