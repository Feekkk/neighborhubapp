import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class EmergencyTab extends StatefulWidget {
  const EmergencyTab({super.key});

  @override
  State<EmergencyTab> createState() => _EmergencyTabState();
}

class _EmergencyTabState extends State<EmergencyTab> {
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    if (!mounted) return;

    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          return;
        }
      }

      if (!mounted) return;

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      setState(() {
        currentPosition = position;
        isLoading = false;
      });

      // Move camera to current position
      if (mapController != null && mounted) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _goToCurrentLocation() {
    if (currentPosition != null && mapController != null && mounted) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentPosition!.latitude,
              currentPosition!.longitude,
            ),
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              if (!mounted) return;
              mapController = controller;
              if (currentPosition != null) {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: LatLng(
                        currentPosition!.latitude,
                        currentPosition!.longitude,
                      ),
                      zoom: 15,
                    ),
                  ),
                );
              }
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentPosition?.latitude ?? 3.1390,
                currentPosition?.longitude ?? 101.6869,
              ),
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Disable default button
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 50,
            right: 16,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              backgroundColor: Colors.white,
              child: const Icon(
                Icons.my_location,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
} 