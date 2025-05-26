import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:projects/cubit/media/media_cubit.dart';
import 'package:projects/model/media_model.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/home/home_screen.dart';
import 'package:projects/screens/project/project_details.dart';
import 'package:projects/utils/pick_media.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/text_styles.dart';
import 'package:projects/utils/toast.dart';
import 'package:projects/utils/video_preview.dart';

class NewMediaForm extends StatelessWidget {
  final bool isVideo;
  final String projectId;
  final String projectName;
  NewMediaForm({
    super.key,
    required this.isVideo,
    required this.projectId,
    required this.projectName,
  });
  final TextEditingController _nameCtrl = TextEditingController();
  MediaCubit mediaCubit = MediaCubit();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ValueNotifier<File?> selectedFile = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: Text("New Media")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.03,
          vertical: size.height * 0.01,
        ),
        child: Form(
          key: formkey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Media Name", style: bodyTextStyle),
                const SizedBox(height: 5),
                CustomTextField(controller: _nameCtrl, isNumber: false),
                const SizedBox(height: 5),

                Text("Media", style: bodyTextStyle),
                const SizedBox(height: 5),

                ValueListenableBuilder(
                  valueListenable: selectedFile,
                  builder: (context, val, _) {
                    return val == null
                        ? GestureDetector(
                          onTap: () async {
                            File? _selected = await pickMedia(isVideo: isVideo);
                            if (_selected != null) {
                              selectedFile.value = _selected;
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 120,
                                width: size.width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 1,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.grey,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : isVideo
                        ? Stack(
                          children: [
                            VideoPreview(videoFile: val),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: IconButton(
                                onPressed: () => selectedFile.value = null,
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                        : Stack(
                          children: [
                            Image.file(
                              val,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                            Positioned(
                              right: 6,
                              top: 6,
                              child: IconButton(
                                onPressed: () => selectedFile.value = null,
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: BlocConsumer<MediaCubit, MediaState>(
                    bloc: mediaCubit,
                    listener: (context, state) {
                      if (state is MediaUploaded) {
                        showToast(state.note, true);
                        navigatorKey.currentState?.pop();
                        // navigatorKey.currentState?.pushReplacement(
                        //   MaterialPageRoute(
                        //     builder:
                        //         (_) => ProjectDetails(
                        //           projectId: projectId,
                        //           projectName: projectName,
                        //         ),
                        //   ),
                        // );
                      }
                      if (state is MediaFailed) {
                        showSnackBar(context, state.error);
                      }
                    },
                    builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState!.validate()) {
                            if (selectedFile.value != null) {
                              mediaCubit.uploadMedia(
                                selectedFile.value!,
                                isVideo ? "video" : "image",
                                _nameCtrl.text.trim(),
                                projectId,
                                projectName,
                              );
                            } else {
                              showSnackBar(context, "Select media");
                            }
                          }
                        },
                        child:
                            state is MediaUploading
                                ? LoadingAnimationWidget.progressiveDots(
                                  size: 30,
                                  color: Colors.white,
                                )
                                : Text('Upload Media'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
