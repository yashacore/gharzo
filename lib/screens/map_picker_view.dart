import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  GoogleMapController? _controller;

  LatLng _selectedLatLng = const LatLng(22.7196, 75.8577); // Indore
  String _fullAddress = "Move map to select location";
  String _city = "";
  String _state = "";
  String _pincode = "";

  bool _loadingAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ================= MAP =================
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLatLng,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (c) => _controller = c,

            onCameraMove: (position) {
              _selectedLatLng = position.target;
            },

            /// 🔥 Reverse geocode after map stops
            onCameraIdle: _getAddressFromLatLng,
          ),

          /// ================= CENTER PIN =================
          const Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),

          /// ================= TOP BAR =================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Pick Location",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          /// ================= BOTTOM SHEET =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [BoxShadow(blurRadius: 20, color: Colors.black26)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// ADDRESS TEXT
                  _loadingAddress
                      ? const Center(child: CircularProgressIndicator())
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.place,
                              size: 20,
                              color: Colors.deepPurple,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _fullAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 20),

                  /// CONFIRM BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, {
                          "latitude": _selectedLatLng.latitude,
                          "longitude": _selectedLatLng.longitude,
                          "address": _fullAddress,
                          "city": _city,
                          "state": _state,
                          "pincode": _pincode,
                        });
                      },
                      child: const Text(
                        "Confirm Location",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= REVERSE GEOCODING =================
  Future<void> _getAddressFromLatLng() async {
    try {
      setState(() => _loadingAddress = true);

      final placemarks = await placemarkFromCoordinates(
        _selectedLatLng.latitude,
        _selectedLatLng.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;

        _fullAddress =
            "${p.name}, ${p.street}, ${p.subLocality}, ${p.locality}";
        _city = p.locality ?? "";
        _state = p.administrativeArea ?? "";
        _pincode = p.postalCode ?? "";
      }
    } catch (_) {
      _fullAddress = "Unable to fetch address";
    } finally {
      setState(() => _loadingAddress = false);
    }
  }
}
