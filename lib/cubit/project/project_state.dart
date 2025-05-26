part of 'project_cubit.dart';

@immutable
sealed class ProjectState {}

final class ProjectInitial extends ProjectState {}

final class ProjectLoading extends ProjectState {}

final class ProjectSaved extends ProjectState {
  final String note;

  ProjectSaved({required this.note});
}

final class ProjectFailed extends ProjectState {
  final String error;

  ProjectFailed({required this.error});
}

final class ProjectsLoaded extends ProjectState {
  final List<ProjectModel> projects;

  ProjectsLoaded({required this.projects});
}
