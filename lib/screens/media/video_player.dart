import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/cubit/media/media_cubit.dart';
import 'package:projects/utils/media_download_option.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/toast.dart';

import 'package:video_player/video_player.dart';

ValueNotifier<bool> isMute = ValueNotifier(false);

class VideoFullTile extends StatefulWidget {
  final String location;

  const VideoFullTile({Key? key, required this.location}) : super(key: key);

  @override
  State<VideoFullTile> createState() => _VideoFullTileState();
}

class _VideoFullTileState extends State<VideoFullTile> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool isPlaying = false;
  final MediaCubit mediaCubit = MediaCubit();
  @override
  void initState() {
    super.initState();

    initializePlayer();
  }

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.location),
    );
    await _videoPlayerController.initialize();

    // Set initial volume
    _videoPlayerController.setVolume(isMute.value ? 0 : 1);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      showControls: false,
      looping: false,
    );

    setState(() {});
  }

  togglePlayPause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
    } else {
      _videoPlayerController.play();
    }
    setState(() {
      isPlaying = _videoPlayerController.value.isPlaying;
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    if (_chewieController != null) {
      _chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    // _videoPlayerController.setVolume(isMute.value ? 0 : 1);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: getVideoView(size),
    );
  }

  Widget getVideoView(Size size) {
    return BlocConsumer<MediaCubit, MediaState>(
      bloc: mediaCubit,
      listener: (context, state) {
        if (state is MediaFailed) {
          showSnackBar(context, state.error);
        }
        if (state is MediaDownloaded) {
          showToast(state.note, true);
        }
      },
      builder: (context, state) {
        return Stack(
          fit: StackFit.expand,
          children: [
            if (_chewieController != null &&
                _chewieController!.videoPlayerController.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: GestureDetector(
                    onTap: () => togglePlayPause(),
                    child: Chewie(controller: _chewieController!),
                  ),
                ),
              )
            else
              const Align(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.white38,
                  strokeWidth: 1.5,
                ),
              ),
            Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                height: 8,
                child: VideoProgressIndicator(
                  _videoPlayerController,
                  allowScrubbing: true,
                  colors: const VideoProgressColors(
                    backgroundColor: Colors.white38,
                    bufferedColor: Colors.white,
                    playedColor: Colors.amber,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 15,
              child: ValueListenableBuilder(
                valueListenable: isMute,
                builder: (context, value, child) {
                  return IconButton(
                    onPressed: () {
                      // print("object");
                      isMute.value = !isMute.value;

                      // _videoPlayerController.setVolume(isMute.value ? 1 : 0);
                    },
                    icon: Icon(
                      value
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_outlined,
                      size: 25,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              // const SizedBox(height: 20),
            ),
            Positioned(
              bottom: 70,
              right: 15,
              child: IconButton(
                onPressed:
                    state is MediaDownloading
                        ? () {}
                        : () => mediaCubit.downloadMedia(widget.location, true),

                icon: Icon(Icons.download, color: Colors.white),
              ),
              // const SizedBox(height: 20),
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
            if (!isPlaying)
              IconButton(
                onPressed: () => togglePlayPause(),
                icon: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 40,
                ),
                style: IconButton.styleFrom(
                  shape: const RoundedRectangleBorder(),
                  backgroundColor: Colors.black26,
                ),
              ),
          ],
        );
      },
    );
  }
}
