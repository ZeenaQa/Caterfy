import 'package:caterfy/util/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MapPicker extends StatefulWidget {
  final LatLng initialLocation;
  final Function(LatLng latLng) onLocationChanged;
  final bool showMyLocationBtn;

  const MapPicker({
    super.key,
    required this.initialLocation,
    required this.onLocationChanged,
    this.showMyLocationBtn = true,
  });

  @override
  State<MapPicker> createState() => _MapPickerState();
}

class _MapPickerState extends State<MapPicker> {
  GoogleMapController? _controller;
  LatLng? _pickedLocation;

  @override
  void initState() {
    super.initState();
    _pickedLocation = widget.initialLocation;
  }

  Future<void> _goToMyLocation() async {
    final latLng = await MapHelper.getCurrentLocation();
    if (latLng == null) return;

    _pickedLocation = latLng;
    widget.onLocationChanged(latLng);
    _controller?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: (c) => _controller = c,
          zoomControlsEnabled: false,
          initialCameraPosition: CameraPosition(
            target: widget.initialLocation,
            zoom: 15,
          ),
          onCameraMove: (pos) {
            _pickedLocation = pos.target;
          },
          onCameraIdle: () {
            if (_pickedLocation != null) {
              widget.onLocationChanged(_pickedLocation!);
            }
          },
        ),

        /// PIN
        const Center(
          child: Icon(Icons.location_pin, size: 48, color: Colors.red),
        ),

        if (widget.showMyLocationBtn)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: colors.primary,
              onPressed: _goToMyLocation,
              child: Icon(
                FontAwesomeIcons.locationCrosshairs,
                color: colors.onPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
