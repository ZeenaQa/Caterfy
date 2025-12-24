import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/logged_vendor_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StoreLocationPage extends StatefulWidget {
  const StoreLocationPage({super.key});

  @override
  State<StoreLocationPage> createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  LatLng? pickedLocation;
  GoogleMapController? _mapController;

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.subLocality}, ${p.locality}";
      }
    } catch (_) {}
    return "Unknown area";
  }

  Future<void> _goToCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition();
    final latLng = LatLng(position.latitude, position.longitude);

    setState(() => pickedLocation = latLng);

    final provider = context.read<LoggedVendorProvider>();
    final area = await _getAddressFromLatLng(latLng);

    provider.updateStoreForm(
      latitude: latLng.latitude,
      longitude: latLng.longitude,
      storeArea: area,
    );

    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedVendorProvider>();
    final storeForm = provider.storeForm;

    if (storeForm == null) return const SizedBox();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        pickedLocation ??
                        LatLng(
                          storeForm.latitude == 0
                              ? 31.9539
                              : storeForm.latitude,
                          storeForm.longitude == 0
                              ? 35.9106
                              : storeForm.longitude,
                        ),
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  onCameraMove: (pos) async {
                    pickedLocation = pos.target;
                    final area = await _getAddressFromLatLng(pos.target);

                    provider.updateStoreForm(
                      latitude: pos.target.latitude,
                      longitude: pos.target.longitude,
                      storeArea: area,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: FilledBtn(
                  title: 'Confirm store location',
                  innerVerticalPadding: 18,
                  horizontalPadding: 10,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const Center(
            child: Icon(Icons.location_pin, size: 48, color: Colors.red),
          ),
          Positioned(
            bottom: 120,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: colors.primary,
              onPressed: _goToCurrentLocation,
              child: Icon(
                FontAwesomeIcons.locationCrosshairs,
                color: colors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
