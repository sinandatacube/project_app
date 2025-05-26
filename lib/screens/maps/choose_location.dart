import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:projects/my_app.dart';
import 'package:projects/utils/location_permission.dart';
import 'package:latlong2/latlong.dart';

class Chooselocation extends StatefulWidget {
  final Function(String locationName, double lat, double long) onSelected;

  const Chooselocation({super.key, required this.onSelected});

  @override
  State<Chooselocation> createState() => _ChooselocationState();
}

class _ChooselocationState extends State<Chooselocation> {
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(),
      body: FutureBuilder(
        future: LocationPermissions.determinePosition(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Position currentPosition = snapshot.data as Position;

            return MapView(
              onSelected: (locationName, lat, long) {
                widget.onSelected(locationName, lat, long);
              },
              position: currentPosition,
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
                    onPressed: () {
                      setState(() {});
                    },
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

  AppBar appbar() {
    return AppBar(
      elevation: 5,
      // surfaceTintColor: Colors.white,
      leading: IconButton(
        onPressed: () {
          navigatorKey.currentState!.pop();
        },
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      ),
      title: const Text(
        'Choose location',
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }
}

class MapView extends StatefulWidget {
  Position position;
  final Function(String locationName, double lat, double long) onSelected;

  MapView({Key? key, required this.position, required this.onSelected})
    : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late MapController mapController;
  final locationAddressController = TextEditingController();
  LatLng centerPosition = const LatLng(0.0, 0.0);
  String pincode = '';
  late LatLng initialPosition;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    initialPosition = LatLng(
      widget.position.latitude,
      widget.position.longitude,
    );
    centerPosition = initialPosition;

    // Get initial address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPlace(centerPosition.latitude, centerPosition.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: initialPosition,
            initialZoom: 17.0,
            onPositionChanged: (MapCamera camera, bool hasGesture) async {
              if (hasGesture) {
                centerPosition = camera.center;
                await getPlace(
                  centerPosition.latitude,
                  centerPosition.longitude,
                );
              }
            },
          ),
          children: [
            // Tile layer for map tiles
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
              maxNativeZoom: 19,
            ),
            // You can add markers here if needed
            // MarkerLayer(
            //   markers: [
            //     Marker(
            //       point: centerPosition,
            //       child: const Icon(
            //         Icons.location_pin,
            //         color: Colors.red,
            //         size: 40,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),

        // Bottom panel
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  Position position =
                      await LocationPermissions.determinePosition();
                  LatLng newPosition = LatLng(
                    position.latitude,
                    position.longitude,
                  );

                  mapController.move(newPosition, 17.0);
                  centerPosition = newPosition;
                  await getPlace(
                    centerPosition.latitude,
                    centerPosition.longitude,
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  backgroundColor: const Color.fromARGB(255, 74, 167, 77),
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.my_location_rounded),
                label: const Text(
                  'Use current location',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                width: size.width,
                height: 130,
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 1)],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: locationAddressController,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          enabled: false,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width,
                      height: 40,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.03,
                      ),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () async {
                          widget.onSelected(
                            locationAddressController.text,
                            centerPosition.latitude,
                            centerPosition.longitude,
                          );
                          navigatorKey.currentState?.pop();
                        },
                        child: const Text(
                          "Confirm location",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Center marker
        const Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 0,
          child: Icon(Icons.my_location_rounded, color: Colors.red, size: 30),
        ),
      ],
    );
  }

  Future<void> updateMapCamera(LatLng location) async {
    mapController.move(location, 17.0);
    centerPosition = location;
    pincode = await getPlace(centerPosition.latitude, centerPosition.longitude);
  }

  Future getPlace(double latitude, double longitude) async {
    try {
      List<Placemark> newPlace = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (newPlace.isNotEmpty) {
        Placemark placeMark = newPlace[0];
        String name = placeMark.name ?? '';
        String subLocality = placeMark.subLocality ?? '';
        String locality = placeMark.locality ?? '';
        String administrativeArea = placeMark.administrativeArea ?? '';
        String postalCode = placeMark.postalCode ?? '';
        String country = placeMark.country ?? '';

        String getData(String stringData) {
          return stringData.isNotEmpty ? '$stringData,' : '';
        }

        String address =
            '${getData(name)} ${getData(subLocality)} ${getData(locality)} ${getData(administrativeArea)} ${getData(postalCode)} ${getData(country)}';

        if (mounted) {
          setState(() {
            locationAddressController.text = address;
          });
        }
        return placeMark.postalCode ?? '';
      }
    } catch (e) {
      log('Error getting place: $e');
    }
    return '';
  }
}
