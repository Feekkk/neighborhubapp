import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neighborhub/user/pages/map_help.dart';
import 'package:neighborhub/user/pages/error_page.dart';

class EmergencyTab extends StatefulWidget {
  const EmergencyTab({super.key});

  @override
  State<EmergencyTab> createState() => _EmergencyTabState();
}

class _EmergencyTabState extends State<EmergencyTab> {
  GoogleMapController? mapController;
  Position? currentPosition;
  bool isLoading = true;
  bool isSaving = false;
  MapType _currentMapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _checkEmailVerificationAndRedirect();
  }

  Future<void> _checkEmailVerificationAndRedirect() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    // Reload user to get latest verification status
    await user.reload();
    final updatedUser = FirebaseAuth.instance.currentUser;
    
    if (updatedUser != null && !updatedUser.emailVerified && mounted) {
      // Redirect to error page immediately
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ErrorPage()),
      );
      return;
    }
    
    // If verified, proceed with getting location
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

  Future<void> _saveLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    await user.reload();
    if (!user.emailVerified) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ErrorPage()),
        );
      }
      return;
    }
    if (currentPosition == null) return;
    setState(() {
      isSaving = true;
    });
    try {
      await FirebaseFirestore.instance.collection('locations').add({
        'userId': user.uid,
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude,
        'timestamp': FieldValue.serverTimestamp(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving location: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save location. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
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

  void _zoomIn() {
    mapController?.animateCamera(CameraUpdate.zoomIn());
  }

  void _zoomOut() {
    mapController?.animateCamera(CameraUpdate.zoomOut());
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
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapType: _currentMapType,
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            top: 50,
            right: 16,
            child: Column(
              children: [
                _buildElegantCircleButton(
                  icon: Icons.my_location,
                  onPressed: _goToCurrentLocation,
                  tooltip: 'Recenter',
                  iconColor: const Color.fromARGB(255, 255, 255, 255),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                const SizedBox(height: 12),
                _buildElegantCircleButton(
                  icon: Icons.layers_rounded,
                  onPressed: () async {
                    final selectedType = await showDialog<MapType>(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: const Color(0xFF2D2D2D),
                        title: Row(
                          children: const [
                            Icon(Icons.map_rounded, color: Color.fromARGB(255, 255, 255, 255)),
                            SizedBox(width: 8),
                            Text(
                              'Choose Map Type',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMapTypeOption(context, MapType.normal, 'Normal', Icons.map),
                            _buildMapTypeOption(context, MapType.satellite, 'Satellite', Icons.satellite_alt),
                            _buildMapTypeOption(context, MapType.terrain, 'Terrain', Icons.terrain),
                            _buildMapTypeOption(context, MapType.hybrid, 'Hybrid', Icons.layers),
                          ],
                        ),
                      ),
                    );
                    if (selectedType != null && selectedType != _currentMapType) {
                      setState(() {
                        _currentMapType = selectedType;
                      });
                    }
                  },
                  tooltip: 'Map Type',
                  iconColor: const Color.fromARGB(255, 255, 255, 255),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB06AB3), Color(0xFF6C63FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF1744), Color(0xFFD50000)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF1744).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: isSaving ? null : _saveLocation,
                    borderRadius: BorderRadius.circular(28),
                    child: Center(
                      child: isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Report Emergency',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 16,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildElegantIconButton(
                        icon: Icons.add,
                        onPressed: _zoomIn,
                        tooltip: 'Zoom In',
                      ),
                      Container(
                        height: 1,
                        width: 32,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      _buildElegantIconButton(
                        icon: Icons.remove,
                        onPressed: _zoomOut,
                        tooltip: 'Zoom Out',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildElegantCircleButton(
                  icon: Icons.help_outline,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const MapHelpDialog(),
                    );
                  },
                  tooltip: 'Help',
                  iconColor: const Color.fromARGB(255, 255, 255, 255),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapTypeOption(BuildContext context, MapType type, String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      trailing: _currentMapType == type
          ? const Icon(Icons.check_circle, color: Color(0xFF6C63FF))
          : null,
      onTap: () => Navigator.of(context).pop(type),
    );
  }

  Widget _buildElegantCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
    Color iconColor = Colors.white,
    Gradient? gradient,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: gradient ?? const LinearGradient(colors: [Color(0xFF2D2D2D), Color(0xFF1A1A1A)]),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: iconColor, size: 26),
          ),
        ),
      ),
    );
  }

  Widget _buildElegantIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
} 