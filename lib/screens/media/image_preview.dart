import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/cubit/media/media_cubit.dart';
import 'package:projects/utils/media_download_option.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/toast.dart';

class ImagePreview extends StatelessWidget {
  final String path;
  ImagePreview({required this.path, super.key});
  final MediaCubit mediaCubit = MediaCubit();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.black,
      body: BlocConsumer<MediaCubit, MediaState>(
        listener: (context, state) {
          if (state is MediaFailed) {
            showSnackBar(context, state.error);
          }
          if (state is MediaDownloaded) {
            showToast(state.note, true);
          }
        },
        bloc: mediaCubit,
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: path,

                  fit: BoxFit.cover,
                  placeholder: (context, url) => Icon(Icons.image),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),

              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed:
                      state is MediaDownloading
                          ? () {}
                          : () => mediaCubit.downloadMedia(path, false),
                ),
              ),

              if (state is MediaDownloading)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: Center(
                    child: SizedBox(
                      width: size.width * 0.6,
                      height: 6,
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
