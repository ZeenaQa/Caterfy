import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/map_picker.dart';
import 'package:caterfy/util/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/logged_vendor_provider.dart';

class StoreLocationPage extends StatefulWidget {
  const StoreLocationPage({super.key});

  @override
  State<StoreLocationPage> createState() => _StoreLocationPageState();
}

class _StoreLocationPageState extends State<StoreLocationPage> {
  LatLng? pickedLocation;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final l10 = AppLocalizations.of(context);
    final storeForm = provider.storeForm;

    if (storeForm == null) return const SizedBox();

    final initialLocation = LatLng(
      storeForm.latitude == 0 ? 31.9539 : storeForm.latitude,
      storeForm.longitude == 0 ? 35.9106 : storeForm.longitude,
    );

    return Scaffold(
      body: Column(
        children: [
          /// ===== MAP =====
          Expanded(
            child: MapPicker(
              initialLocation: pickedLocation ?? initialLocation,
              onLocationChanged: (latLng) async {
                pickedLocation = latLng;

                final area = await MapHelper.getAddressFromLatLng(
                  latLng,
                  l10.unknownArea,
                );

                provider.updateStoreForm(
                  latitude: latLng.latitude,
                  longitude: latLng.longitude,
                  storeArea: area,
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
