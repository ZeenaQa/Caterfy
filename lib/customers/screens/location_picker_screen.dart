import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/map_picker.dart';
import 'package:caterfy/util/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/global_provider.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng? pickedLocation;

  @override
  void initState() {
    super.initState();
    _loadLastLocation();
  }

  void _loadLastLocation() {
    final provider = context.read<GlobalProvider>();
    if (provider.lastPickedLocation != null) {
      pickedLocation = provider.lastPickedLocation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: l10.pickLocation),
      body: Column(
        children: [
          /// ===== MAP =====
          Expanded(
            child: MapPicker(
              initialLocation: pickedLocation ?? const LatLng(31.9539, 35.9106),
              onLocationChanged: (latLng) async {
                pickedLocation = latLng;

                final address = await MapHelper.getAddressFromLatLng(
                  latLng,
                  l10.unknownArea,
                );

                context.read<GlobalProvider>().setDeliveryLocation(
                  address,
                  latLng,
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
                if (pickedLocation != null) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
