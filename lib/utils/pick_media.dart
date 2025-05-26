import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> pickMedia({required bool isVideo}) async {
  final ImagePicker picker = ImagePicker();
  XFile? pickedFile;
  if (isVideo) {
    pickedFile = await picker.pickVideo(source: ImageSource.gallery);
  } else {
    pickedFile = await picker.pickImage(source: ImageSource.gallery);
  }

  return pickedFile != null ? File(pickedFile.path) : null;
}

// requestPer(Permission permission) async {
//   AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
//   if (build.version.sdkInt >= 32) {
//     // var re = await Permission.manageExternalStorage.request();
//     // var re = await Permission.manageExternalStorage.request();
//     final re = await Permission.photos.request();
//     final re2 = await Permission.manageExternalStorage.request();
//     if (re.isGranted) {
//       return "granted";
//     } else if (re.isDenied) {
//       return "denied";
//     } else if (re.isPermanentlyDenied) {
//       return "permanently denied";
//     }
//     // else{
//     //      return "permanently denied";
//     // }
//   } else {
//     // var re = await Permission.manageExternalStorage.request();
//     if (await permission.isGranted) {
//       return "granted";
//     } else {
//       var result = await permission.request();
//       if (result.isGranted) {
//         return "granted";
//       } else if (result.isDenied) {
//         return "denied";
//       } else if (result.isPermanentlyDenied) {
//         return "permanently denied";
//       }
//     }
//   }
// }
