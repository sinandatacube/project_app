// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hawk_fab_menu/hawk_fab_menu.dart';
// import 'package:projects/cubit/media/media_cubit.dart';
// import 'package:projects/model/media_model.dart';
// import 'package:projects/my_app.dart';
// import 'package:projects/screens/project/new_media_form.dart';
// import 'package:projects/screens/media/image_preview.dart';
// import 'package:projects/screens/media/video_player.dart';
// import 'package:projects/utils/video_preview.dart';
// import 'package:video_player/video_player.dart';

// // ignore: must_be_immutable
// class ProjectDetails extends StatefulWidget {
//   final String projectName;
//   final String projectId;
//   ProjectDetails({
//     super.key,
//     required this.projectName,
//     required this.projectId,
//   });

//   @override
//   State<ProjectDetails> createState() => _ProjectDetailsState();
// }

// class _ProjectDetailsState extends State<ProjectDetails> {
//   ValueNotifier<bool> showImages = ValueNotifier(true);

//   HawkFabMenuController hawkFabMenuController = HawkFabMenuController();
//   MediaCubit mediaCubit = MediaCubit();
//   @override
//   void initState() {
//     mediaCubit.fetchMediasByProjectId(widget.projectId);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.black,
//         title: Text(widget.projectName),
//       ),
//       body: BlocBuilder<MediaCubit, MediaState>(
//         bloc: mediaCubit,
//         builder: (context, state) {
//           if (state is MediaLoadFailed) {
//             return Center(child: Text(state.error));
//           }
//           if (state is MediaLoaded) {
//             return HawkFabMenu(
//               // icon: AnimatedIcons.add_event,
//               closeIcon: Icons.close,
//               fabColor: Colors.black,
//               iconColor: Colors.white,
//               openIcon: Icons.add,
//               hawkFabMenuController: hawkFabMenuController,
//               items: [
//                 HawkFabMenuItem(
//                   label: 'Video',
//                   ontap:
//                       () => navigatorKey.currentState
//                           ?.push(
//                             MaterialPageRoute(
//                               builder:
//                                   (_) => NewMediaForm(
//                                     isVideo: true,
//                                     projectId: widget.projectId,
//                                     projectName: widget.projectName,
//                                   ),
//                             ),
//                           )
//                           .then(
//                             (value) => mediaCubit.fetchMediasByProjectId(
//                               widget.projectId,
//                             ),
//                           ),
//                   icon: const Icon(Icons.video_camera_back_rounded),
//                   labelColor: Colors.black,
//                   color: Colors.white,
//                 ),
//                 HawkFabMenuItem(
//                   label: 'Image',
//                   ontap:
//                       () => navigatorKey.currentState
//                           ?.push(
//                             MaterialPageRoute(
//                               builder:
//                                   (_) => NewMediaForm(
//                                     isVideo: false,
//                                     projectId: widget.projectId,
//                                     projectName: widget.projectName,
//                                   ),
//                             ),
//                           )
//                           .then(
//                             (value) => mediaCubit.fetchMediasByProjectId(
//                               widget.projectId,
//                             ),
//                           ),

//                   icon: const Icon(Icons.image),
//                   color: Colors.white,
//                   labelColor: Colors.black,
//                 ),
//               ],

//               body: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: size.width * 0.03,
//                   vertical: size.height * 0.02,
//                 ),
//                 child: Column(
//                   children: [
//                     ValueListenableBuilder(
//                       valueListenable: showImages,
//                       builder:
//                           (context, value, child) => Row(
//                             children: [
//                               ActionChip(
//                                 label: Text(
//                                   "Images",
//                                   style: TextStyle(
//                                     color: !value ? Colors.black : Colors.white,
//                                   ),
//                                 ),
//                                 backgroundColor:
//                                     value ? Colors.black : Colors.white,

//                                 onPressed: () => showImages.value = true,
//                               ),
//                               SizedBox(width: size.width * 0.01),
//                               ActionChip(
//                                 label: Text(
//                                   "Vidoes",
//                                   style: TextStyle(
//                                     color: value ? Colors.black : Colors.white,
//                                   ),
//                                 ),
//                                 onPressed: () => showImages.value = false,
//                                 backgroundColor:
//                                     !value ? Colors.black : Colors.white,
//                               ),
//                             ],
//                           ),
//                     ),
//                     SizedBox(height: 12),
//                     Expanded(
//                       child: ValueListenableBuilder(
//                         valueListenable: showImages,
//                         builder: (context, val, _) {
//                           return GridView.builder(
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   childAspectRatio: 0.5,
//                                   crossAxisSpacing: size.width * 0.02,
//                                   mainAxisSpacing: size.height * 0.01,
//                                 ),
//                             shrinkWrap: true,
//                             itemCount:
//                                 val ? state.images.length : state.videos.length,
//                             itemBuilder: (context, index) {
//                               MediaModel current =
//                                   val
//                                       ? state.images[index]
//                                       : state.videos[index];
//                               return GestureDetector(
//                                 onTap:
//                                     () => navigatorKey.currentState?.push(
//                                       MaterialPageRoute(
//                                         builder:
//                                             (_) =>
//                                                 !val
//                                                     ? VideoFullTile(
//                                                       location:
//                                                           current
//                                                               .storageLocation,
//                                                     )
//                                                     : ImagePreview(
//                                                       path:
//                                                           current
//                                                               .storageLocation,
//                                                     ),
//                                       ),
//                                     ),
//                                 child: CachedNetworkImage(
//                                   imageUrl:
//                                       val
//                                           ? current.storageLocation
//                                           : current.thumbNail,
//                                   fit: BoxFit.cover,
//                                   placeholder:
//                                       (context, url) => Icon(Icons.image),
//                                   errorWidget:
//                                       (context, url, error) =>
//                                           Icon(Icons.error),
//                                 ),
//                               );
//                               //   onTap:
//                               //       () => navigatorKey.currentState?.push(
//                               //         MaterialPageRoute(
//                               //           builder:
//                               //               (_) =>
//                               //                   !val
//                               //                       ? VideoFullTile(
//                               //                         location:
//                               //                             current.storageLocation,
//                               //                       )
//                               //                       : ImagePreview(
//                               //                         path:
//                               //                             current.storageLocation,
//                               //                       ),
//                               //         ),
//                               //       ),

//                               //   leading: CachedNetworkImage(
//                               //     imageUrl:
//                               //         val
//                               //             ? current.storageLocation
//                               //             : current.thumbNail,
//                               //     placeholder:
//                               //         (context, url) => Icon(Icons.image),
//                               //     errorWidget:
//                               //         (context, url, error) => Icon(Icons.error),
//                               //   ),
//                               //   title: Text(current.name),
//                               //   trailing: Icon(Icons.arrow_forward_ios_rounded),
//                               // );
//                             },
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawk_fab_menu/hawk_fab_menu.dart';
import 'package:projects/cubit/media/media_cubit.dart';
import 'package:projects/model/media_model.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/project/new_media_form.dart';
import 'package:projects/screens/media/image_preview.dart';
import 'package:projects/screens/media/video_player.dart';

class ProjectDetails extends StatefulWidget {
  final String projectName;
  final String projectId;

  const ProjectDetails({
    super.key,
    required this.projectName,
    required this.projectId,
  });

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final ValueNotifier<bool> showImages = ValueNotifier(true);
  late final HawkFabMenuController hawkFabMenuController;
  late final MediaCubit mediaCubit;

  static const double _paddingHorizontal = 16;
  static const double _borderRadius = 14;
  static const double _gridSpacing = 12;

  @override
  void initState() {
    super.initState();
    hawkFabMenuController = HawkFabMenuController();
    mediaCubit = MediaCubit();
    mediaCubit.fetchMediasByProjectId(widget.projectId);
  }

  @override
  void dispose() {
    mediaCubit.close();
    showImages.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,

        foregroundColor: Colors.white,
        title: Text(widget.projectName),
        elevation: 0,
      ),
      body: BlocBuilder<MediaCubit, MediaState>(
        bloc: mediaCubit,
        builder: (context, state) {
          if (state is MediaLoadFailed) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }
          if (state is MediaLoaded) {
            return HawkFabMenu(
              hawkFabMenuController: hawkFabMenuController,
              fabColor: theme.primaryColor,
              iconColor: Colors.white,
              closeIcon: Icons.close,
              openIcon: Icons.add,
              items: [
                HawkFabMenuItem(
                  label: 'Video',
                  icon: const Icon(
                    Icons.video_camera_back_rounded,
                    color: Colors.black,
                  ),
                  color: Colors.white,
                  labelColor: Colors.black,
                  ontap: () => _navigateToNewMediaForm(isVideo: true),
                ),
                HawkFabMenuItem(
                  label: 'Image',
                  icon: const Icon(Icons.image, color: Colors.black),
                  color: Colors.white,
                  labelColor: Colors.black,
                  ontap: () => _navigateToNewMediaForm(isVideo: false),
                ),
              ],
              body: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _paddingHorizontal,
                  vertical: size.height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<bool>(
                      valueListenable: showImages,
                      builder: (context, value, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildToggleChip(
                              label: "Images",
                              selected: value,
                              onTap: () => showImages.value = true,
                            ),
                            SizedBox(width: size.width * 0.04),
                            _buildToggleChip(
                              label: "Videos",
                              selected: !value,
                              onTap: () => showImages.value = false,
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: showImages,
                        builder: (context, val, _) {
                          final mediaList = val ? state.images : state.videos;

                          if (mediaList.isEmpty) {
                            return Center(
                              child: Text(
                                val ? 'No images found.' : 'No videos found.',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            );
                          }

                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: _gridSpacing,
                                  mainAxisSpacing: _gridSpacing,
                                  childAspectRatio: 0.7,
                                ),
                            itemCount: mediaList.length,
                            itemBuilder: (context, index) {
                              final current = mediaList[index];
                              return _buildMediaCard(current, isImage: val);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildToggleChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: selected ? Colors.black : Colors.white,
      elevation: 3,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: onTap,
    );
  }

  Widget _buildMediaCard(MediaModel media, {required bool isImage}) {
    return GestureDetector(
      onTap: () => _openMediaPreview(media, isImage),
      child: Card(
        color: Colors.grey[900],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: isImage ? media.storageLocation : media.thumbNail,
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white54),
                  ),
              errorWidget:
                  (context, url, error) =>
                      const Icon(Icons.error, color: Colors.redAccent),
            ),
            if (!isImage)
              const Positioned(
                right: 8,
                top: 8,
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white70,
                  size: 30,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _navigateToNewMediaForm({required bool isVideo}) {
    navigatorKey.currentState
        ?.push(
          MaterialPageRoute(
            builder:
                (_) => NewMediaForm(
                  isVideo: isVideo,
                  projectId: widget.projectId,
                  projectName: widget.projectName,
                ),
          ),
        )
        .then((_) => mediaCubit.fetchMediasByProjectId(widget.projectId));
  }

  void _openMediaPreview(MediaModel media, bool isImage) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder:
            (_) =>
                isImage
                    ? ImagePreview(path: media.storageLocation)
                    : VideoFullTile(location: media.storageLocation),
      ),
    );
  }
}
