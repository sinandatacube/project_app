import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<String?> generateVideoThumbnail(String videoPath) async {
  try {
    final tempDir = await getTemporaryDirectory();
    final thumbPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: tempDir.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail
      quality: 75,
    );
    return thumbPath; // This is the file path to the thumbnail image
  } catch (e) {
    print('Thumbnail generation error: $e');
    return null;
  }
}
