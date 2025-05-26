import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:projects/model/media_model.dart';
import 'package:projects/utils/generate_thumbnail.dart';
part 'media_state.dart';

class MediaCubit extends Cubit<MediaState> {
  MediaCubit() : super(MediaInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadMedia(
    File file,
    String type,
    String name,
    String projectId,
    String projectName,
  ) async {
    try {
      emit(MediaUploading());
      final String fileName = path.basename(file.path);
      final Reference ref = FirebaseStorage.instance.ref().child(
        '$type/$fileName',
      );

      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      String thumbUrl = "";
      if (type == 'video') {
        // Generate thumbnail
        String? thumbFilePath = await generateVideoThumbnail(file.path);

        if (thumbFilePath != null) {
          File thumbFile = File(thumbFilePath);

          // Upload thumbnail
          final thumbRef = FirebaseStorage.instance.ref().child(
            'thumbnails/${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

          UploadTask thumbUploadTask = thumbRef.putFile(thumbFile);
          TaskSnapshot thumbSnapshot = await thumbUploadTask;

          // Get thumbnail download URL
          thumbUrl = await thumbSnapshot.ref.getDownloadURL();
        }
      }

      final media = MediaModel(
        thumbNail: thumbUrl,
        projectName: projectName,
        projectId: projectId,
        name: name,
        type: type,
        storageLocation: downloadUrl,
      );

      await _firestore.collection('media').add(media.toJson());
      emit(MediaUploaded(note: "Media uploaded successfully."));
    } catch (e) {
      emit(MediaFailed(error: "Something went wrong"));
    }
  }

  //*************************************************** */
  fetchMediasByProjectId(String projectId) async {
    try {
      emit(MediaUploading());
      log(projectId);
      final snapshot =
          await _firestore
              .collection('media')
              .where('projectId', isEqualTo: projectId)
              .get();
      log(snapshot.docs.length.toString());

      List<MediaModel> medias =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return MediaModel.fromJson(data);
          }).toList();
      log(medias.length.toString());
      List<MediaModel> videos = [];
      List<MediaModel> images = [];
      for (var element in medias) {
        if (element.type == 'video') {
          videos.add(element);
        } else {
          images.add(element);
        }
      }
      emit(MediaLoaded(images: images, videos: videos));
    } catch (e) {
      emit(MediaLoadFailed(error: e.toString()));
    }
  }

  //********************************** */
  downloadMedia(String url, bool isVideo) async {
    try {
      emit(MediaDownloading());
      // Request permission
      // if (!await requestPermission(isVideo)) {
      //   print('Permission denied');
      //   openAppSettings();
      //   return null;
      // }

      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = isVideo ? '.mp4' : '.jpg';
      final fileName = 'download_$timestamp$extension';

      // Save to Download folder
      final downloadPath = '/storage/emulated/0/Download/$fileName';

      // Download with Dio
      final dio = Dio();
      await dio.download(url, downloadPath);
      emit(MediaDownloaded(note: "Media downloaded to Downloads"));
      // showToast("Media downloaded to Downloads", true);
      print('Downloaded: $downloadPath');
    } catch (e) {
      print('Download failed: $e');
      emit(MediaFailed(error: "Failed to download"));
    }
  }
}
