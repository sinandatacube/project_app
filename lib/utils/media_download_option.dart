// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:projects/utils/toast.dart';

// class Downloader {
//   /// Request appropriate storage permission
//   static Future<bool> requestPermission(bool isVideo) async {
//     final deviceInfo = DeviceInfoPlugin();
//     final androidInfo = await deviceInfo.androidInfo;

//     if (androidInfo.version.sdkInt >= 33) {
//       // Android 13+
//       if (isVideo) {
//         final videos = await Permission.videos.request();
//         return videos.isGranted;
//       } else {
//         final photos = await Permission.photos.request();
//         return photos.isGranted;
//       }
//     } else {
//       // Below Android 13
//       final storage = await Permission.storage.request();
//       return storage.isGranted;
//     }
//   }

//   /// Download image or video
//   static Future<String?> download(String url, bool isVideo) async {
//     try {
//       // Request permission
//       // if (!await requestPermission(isVideo)) {
//       //   print('Permission denied');
//       //   openAppSettings();
//       //   return null;
//       // }

//       // Generate filename
//       final timestamp = DateTime.now().millisecondsSinceEpoch;
//       final extension = isVideo ? '.mp4' : '.jpg';
//       final fileName = 'download_$timestamp$extension';

//       // Save to Download folder
//       final downloadPath = '/storage/emulated/0/Download/$fileName';

//       // Download with Dio
//       final dio = Dio();
//       await dio.download(url, downloadPath);
//       showToast("Media downloaded to Downloads", true);
//       print('Downloaded: $downloadPath');
//       return downloadPath;
//     } catch (e) {
//       print('Download failed: $e');
//       return null;
//     }
//   }
// }
