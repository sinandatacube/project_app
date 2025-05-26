class ProjectModel {
  final String projectName;
  final String projectId;
  final double lat;
  final double long;

  ProjectModel({
    required this.projectName,
    required this.projectId,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectName': projectName,
      'lat': lat,
      'long': long,
      'projectId': projectId,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectId: map['projectId'] ?? "",
      projectName: map['projectName'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
    );
  }
}
