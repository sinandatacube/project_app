part of 'media_cubit.dart';

@immutable
sealed class MediaState {}

final class MediaInitial extends MediaState {}

final class MediaLoaded extends MediaState {
  final List<MediaModel> videos;
  final List<MediaModel> images;
  MediaLoaded({required this.videos, required this.images});
}

final class MediaLoadFailed extends MediaState {
  final String error;
  MediaLoadFailed({required this.error});
}

final class MediaUploading extends MediaState {}

final class MediaUploaded extends MediaState {
  final String note;
  MediaUploaded({required this.note});
}

final class MediaFailed extends MediaState {
  final String error;
  MediaFailed({required this.error});
}

final class MediaDownloaded extends MediaState {
  final String note;
  MediaDownloaded({required this.note});
}

final class MediaDownloading extends MediaState {}
