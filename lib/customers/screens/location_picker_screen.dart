import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
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
      setState(() {
        pickedLocation = provider.lastPickedLocation;
      });

      if (_mapController != null) {
        _mapController!.moveCamera(
            CameraUpdate.newLatLng(provider.lastPickedLocation!));
      }
    }
  }

  Future<String> _getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        return "${placemark.subLocality}, ${placemark.locality}";
      }
    } catch (e) {
      print("Error in reverse geocoding: $e");
    }
    return "Unknown location";
  }

  Future<void> _goToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    Position position =
        await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      pickedLocation = currentLatLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));

    // Save in Provider
    final provider = Provider.of<GlobalProvider>(context, listen: false);
    final address = await _getAddressFromLatLng(currentLatLng);
    provider.setDeliveryLocation(address, currentLatLng);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title:'Pick a Location', ),
      body: SizedBox.expand(
        child: GoogleMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            if (pickedLocation != null) {
              _mapController!.moveCamera(CameraUpdate.newLatLng(pickedLocation!));
            }
            if (Theme.of(context).brightness == Brightness.dark) {
    final darkStyle = await rootBundle.loadString('assets/map_style_dark.json');
    _mapController?.setMapStyle(darkStyle);
  } else {
    _mapController?.setMapStyle(null);
  }
          },
            zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: pickedLocation ?? LatLng(31.9539, 35.9106),
            zoom: 12,
          ),
          onTap: (latLng) async {
            setState(() {
              pickedLocation = latLng;
            });

            final provider =
                Provider.of<GlobalProvider>(context, listen: false);
            final address = await _getAddressFromLatLng(latLng);
            provider.setDeliveryLocation(address, latLng);
          },
          markers: pickedLocation == null
              ? {}
              : {Marker(markerId: MarkerId('picked'), position: pickedLocation!)},
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: colors.primary,
            onPressed: _goToCurrentLocation,
            heroTag: "current_location",
            child: Icon(Icons.my_location, color: colors.onPrimary),
            mini: true,
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            backgroundColor: colors.primary,
            onPressed: () {
              if (pickedLocation != null) {
                Navigator.pop(context);
              }
            },
            heroTag: "confirm_location",
            child: Icon(Icons.check, color: colors.onPrimary),
          ),
        ],
      ),
    );
  }
}
