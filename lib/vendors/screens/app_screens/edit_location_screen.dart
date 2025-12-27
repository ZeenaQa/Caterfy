import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/l10n/app_localizations.dart';

class EditStoreLocationScreen extends StatefulWidget {
  const EditStoreLocationScreen({super.key});

  @override
  State<EditStoreLocationScreen> createState() =>
      _EditStoreLocationScreenState();
}

class _EditStoreLocationScreenState extends State<EditStoreLocationScreen> {
  LatLng? pickedLocation;
  GoogleMapController? _mapController;

  Future<String> _getAddress(BuildContext context, LatLng latLng) async {
    final l10 = AppLocalizations.of(context);
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
    return l10.unknownArea;
  }

  Future<void> _goToCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final latLng = LatLng(position.latitude, position.longitude);
    setState(() => pickedLocation = latLng);

    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final store = provider.storeForm!;

    pickedLocation ??= LatLng(
      store.latitude == 0 ? 31.9539 : store.latitude,
      store.longitude == 0 ? 35.9106 : store.longitude,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10.changeLocation)),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GoogleMap(
                  onMapCreated: (c) => _mapController = c,
                  initialCameraPosition: CameraPosition(
                    target: pickedLocation!,
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  onCameraMove: (pos) {
                    pickedLocation = pos.target;
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledBtn(
                  title: l10.save,
                  innerVerticalPadding: 18,
                  onPressed: () async {
                    if (pickedLocation == null) return;

                    final area = await _getAddress(context, pickedLocation!);

                    provider.updateStoreForm(
                      latitude: pickedLocation!.latitude,
                      longitude: pickedLocation!.longitude,
                      storeArea: area,
                    );

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),

          const Center(
            child: Icon(Icons.location_pin, color: Colors.red, size: 48),
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
