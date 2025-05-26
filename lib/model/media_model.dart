class MediaModel {
  final String name;
  final String type;
  final String storageLocation;
  final String projectId;
  final String projectName;
  final String thumbNail;

  MediaModel({
    required this.name,
    required this.type,
    required this.storageLocation,
    required this.projectId,
    required this.projectName,
    required this.thumbNail,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(
      projectId: json['projectId'],
      projectName: json['projectName'],
      name: json['name'],
      type: json['type'],
      storageLocation: json['storageLocation'],
      thumbNail: json['thumbNail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectName': projectName,
      'name': name,
      'type': type,
      'storageLocation': storageLocation,
      'projectId': projectId,
      'thumbNail': thumbNail,
    };
  }
}
