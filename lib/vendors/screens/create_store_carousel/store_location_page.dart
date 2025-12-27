import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/map_picker.dart';
import 'package:caterfy/util/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StoreLocationPage extends StatefulWidget {
  final void Function(String area, double latitude, double longitude)
  onLocationSelected;

  final double? initialLatitude;
  final double? initialLongitude;

  const StoreLocationPage({
    super.key,
    required this.onLocationSelected,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<StoreLocationPage> createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);

    final initialLocation = LatLng(
      widget.initialLatitude ?? 31.9539, // Amman default
      widget.initialLongitude ?? 35.9106,
    );

    return Scaffold(
      body: Column(
        children: [
          /// ===== MAP =====
          Expanded(
            child: MapPicker(
              initialLocation: pickedLocation ?? initialLocation,
              onLocationChanged: (latLng) async {
                setState(() => pickedLocation = latLng);

                final area = await MapHelper.getAddressFromLatLng(
                  latLng,
                  l10.unknownArea,
                );

                widget.onLocationSelected(
                  area,
                  latLng.latitude,
                  latLng.longitude,
                );
              },
            ),
          ),

          /// ===== CONFIRM BUTTON =====
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: FilledBtn(
              title: l10.confirmStoreLocation,
              innerVerticalPadding: 18,
              horizontalPadding: 10,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
