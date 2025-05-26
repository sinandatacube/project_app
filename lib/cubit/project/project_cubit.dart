import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:projects/model/project_model.dart';

part 'project_state.dart';

class ProjectCubit extends Cubit<ProjectState> {
  ProjectCubit() : super(ProjectInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<ProjectModel> projects = [];
  saveProject(ProjectModel project) async {
    try {
      emit(ProjectLoading());
      await _firestore.collection('projects').add(project.toMap());

      emit(ProjectSaved(note: "Project Saved"));
    } catch (e) {
      emit(ProjectFailed(error: e.toString()));
    }
  }

  //***************************************************************** */
  fetchAllProjects() async {
    try {
      emit(ProjectLoading());
      final snapshot =
          await FirebaseFirestore.instance.collection('projects').get();

      // projects =
      //     snapshot.docs.map((doc) {
      //       return ProjectModel.fromMap(doc.data());
      //     }).toList();
      projects =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['projectId'] = doc.id; // Add document ID manually
            return ProjectModel.fromMap(data);
          }).toList();

      emit(ProjectsLoaded(projects: projects));
    } catch (e) {
      projects = [];
      emit(ProjectFailed(error: e.toString()));
    }
  }

  //***************************************************************** */
  searchProjects(String query) async {
    try {
      emit(ProjectLoading());
      List<ProjectModel> searchedProjects = [];
      if (query.isNotEmpty) {
        for (var element in projects) {
          if (element.projectName.toLowerCase().contains(query.toLowerCase())) {
            searchedProjects.add(element);
          }
        }
      }
      emit(
        ProjectsLoaded(
          projects: query.isNotEmpty ? searchedProjects : projects,
        ),
      );
    } catch (e) {
      projects = [];
      emit(ProjectFailed(error: e.toString()));
    }
  }
}
