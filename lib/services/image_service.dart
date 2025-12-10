import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageService {
  // Resize image to 800x600
  Future<File> resizeImage(File imageFile) async {
    try {
      // Read the image
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Failed to decode image');
      }

      // Resize to 800x600
      final resized = img.copyResize(
        image,
        width: 800,
        height: 600,
        interpolation: img.Interpolation.linear,
      );

      // Encode as JPEG
      final resizedBytes = img.encodeJpg(resized, quality: 85);

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final resizedFile = File('${tempDir.path}/resized_$timestamp.jpg');
      await resizedFile.writeAsBytes(resizedBytes);

      return resizedFile;
    } catch (e) {
      throw Exception('Failed to resize image: $e');
    }
  }

  // Save image locally for offline access
  Future<String> saveImageLocally(File imageFile, int landmarkId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/landmark_images');
      
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }

      final fileName = 'landmark_${landmarkId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedFile = File('${imagesDir.path}/$fileName');
      
      await imageFile.copy(savedFile.path);
      
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save image locally: $e');
    }
  }

  // Delete local image
  Future<void> deleteLocalImage(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      // Silently fail - image might already be deleted
    }
  }
}
