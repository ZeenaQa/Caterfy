import 'dart:async';

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
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = context.read<GlobalProvider>();
    if (provider.lastPickedLocation != null) {
      pickedLocation = provider.lastPickedLocation;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onLocationChanged(LatLng latLng) {
    pickedLocation = latLng;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (!mounted) return;
      final l10 = AppLocalizations.of(context);
      final address = await MapHelper.getAddressFromLatLng(latLng, l10.unknownArea);
      if (!mounted) return;
      context.read<GlobalProvider>().setDeliveryLocation(address, latLng);
    });
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
              onLocationChanged: _onLocationChanged,
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
