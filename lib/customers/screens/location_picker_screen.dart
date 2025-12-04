import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../providers/global_provider.dart';
import 'package:flutter/services.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? pickedLocation;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadLastLocation();
  }

  Future<void> _loadLastLocation() async {
    final provider = Provider.of<GlobalProvider>(context, listen: false);

    if (provider.lastPickedLocation != null) {
      pickedLocation = provider.lastPickedLocation;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mapController?.moveCamera(CameraUpdate.newLatLng(pickedLocation!));
      });
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        print("${placemark.subLocality}, ${placemark.locality}, ");
        return "${placemark.subLocality}, ${placemark.locality}, ";
        
      }
    } catch (_) {}
    return "Unknown location";
  }

  Future<void> _goToCurrentLocation() async {
    final l10 = AppLocalizations.of(context);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10.locationServicesDisabled),
          content: Text(l10.enableGpsFromSettings),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await Geolocator.openLocationSettings();
              },
              child: Text(l10.goToSettings),
            ),
          ],
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10.locationPermissionDenied)));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10.locationPermissionPermanentlyDenied),
          content: Text(l10.enableLocationFromSettings),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await Geolocator.openAppSettings();
              },
              child: Text(l10.goToSettings),
            ),
          ],
        ),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final currentLatLng = LatLng(position.latitude, position.longitude);

    pickedLocation = currentLatLng;
    _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

    final provider = Provider.of<GlobalProvider>(context, listen: false);
    final address = await _getAddressFromLatLng(currentLatLng);
    provider.setDeliveryLocation(address, currentLatLng);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Pick a Location'),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    GoogleMap(
                      onMapCreated: (controller) async {
                        _mapController = controller;

                        if (Theme.of(context).brightness == Brightness.dark) {
                          final darkStyle = await rootBundle.loadString(
                            'assets/map_style_dark.json',
                          );
                          _mapController?.setMapStyle(darkStyle);
                        } else {
                          _mapController?.setMapStyle(null);
                        }

                        if (pickedLocation != null) {
                          _mapController!.moveCamera(
                            CameraUpdate.newLatLng(pickedLocation!),
                          );
                        }
                      },
                      zoomControlsEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target:
                            pickedLocation ?? const LatLng(31.9539, 35.9106),
                        zoom: 15,
                      ),
                      onCameraMove: (position) {
                        pickedLocation = position.target;
                      },
                      onCameraIdle: () async {
                        if (pickedLocation == null) return;

                        final provider = Provider.of<GlobalProvider>(
                          context,
                          listen: false,
                        );
                        final address = await _getAddressFromLatLng(
                          pickedLocation!,
                        );
                        provider.setDeliveryLocation(address, pickedLocation!);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: FloatingActionButton(
                          backgroundColor: colors.primary,
                          heroTag: "confirm_location",
                          onPressed: _goToCurrentLocation,
                          child: Icon(
                            FontAwesomeIcons.locationCrosshairs,
                            color: colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Buttons under the map
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledBtn(
                      onPressed: () {
                        if (pickedLocation != null) {
                          Navigator.pop(context);
                        }
                      },
                      title: 'Confirm pin location',
                      innerVerticalPadding: 18,
                      horizontalPadding: 10,
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
            ],
          ),

          // Center pin
          const Center(
            child: Icon(Icons.location_pin, size: 48, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
