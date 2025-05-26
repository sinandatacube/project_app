import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projects/model/project_model.dart';
import 'package:projects/my_app.dart';
import 'package:projects/screens/project/project_details.dart';
import 'package:projects/utils/location_permission.dart';
import 'package:latlong2/latlong.dart';

class ProjectLocationsView extends StatelessWidget {
  final List<ProjectModel> projects;
  ProjectLocationsView({super.key, required this.projects});

  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: LocationPermissions.determinePosition(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Position currentPosition = snapshot.data as Position;

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  currentPosition.latitude,
                  currentPosition.longitude,
                ),
                initialZoom: 17.0,
              ),
              children: [
                // Tile layer for map tiles
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                  maxNativeZoom: 19,
                ),

                MarkerLayer(
                  markers:
                      projects.map((project) {
                        return Marker(
                          width: 60,
                          height: 60,
                          point: LatLng(project.lat, project.long),

                          child: GestureDetector(
                            onTap:
                                () => navigatorKey.currentState?.push(
                                  MaterialPageRoute(
                                    builder:
                                        (_) => ProjectDetails(
                                          projectName: project.projectName,
                                          projectId: project.projectId,
                                        ),
                                  ),
                                ),
                            child: Tooltip(
                              message: project.projectName,
                              child: const Icon(
                                Icons.location_pin,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ],
            );
          }

          if (snapshot.hasError) {
            return SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text("Please enable the Location !!"),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CupertinoActivityIndicator());
        },
      ),
    );
  }
}
