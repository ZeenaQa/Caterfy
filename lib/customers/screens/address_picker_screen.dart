import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/customer_address.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/map_picker.dart';
import 'package:caterfy/util/map_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// ── Step 1: Map ───────────────────────────────────────────────────────────────

class AddressPickerScreen extends StatefulWidget {
  const AddressPickerScreen({super.key, this.existingAddress, this.pickOnly = false, this.initialLatLng});

  final CustomerAddress? existingAddress;
  /// When true, pops with ({LatLng latLng, String? area}) instead of pushing to details.
  final bool pickOnly;
  /// Overrides the default initial map position when set.
  final LatLng? initialLatLng;

  @override
  State<AddressPickerScreen> createState() => _AddressPickerScreenState();
}

class _AddressPickerScreenState extends State<AddressPickerScreen> {
  LatLng? _pickedLatLng;
  String? _resolvedArea;
  bool _resolving = false;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    // Default to: explicit override → existing address → previously picked → Amman
    final initialLocation =
        widget.initialLatLng ??
        widget.existingAddress?.latLng ??
        context.read<GlobalProvider>().lastPickedLocation ??
        const LatLng(31.9539, 35.9106);

    return Scaffold(
      appBar: CustomAppBar(title: l10.pinYourLocation),
      body: Column(
        children: [
          Expanded(
            child: MapPicker(
              initialLocation: initialLocation,
              onLocationChanged: (latLng) async {
                _pickedLatLng = latLng;
                setState(() => _resolving = true);
                final area = await MapHelper.getAddressFromLatLng(
                  latLng,
                  l10.unknownArea,
                );
                if (mounted) setState(() {
                  _resolvedArea = area;
                  _resolving = false;
                });
              },
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            decoration: BoxDecoration(
              color: colors.surface,
              boxShadow: [
                BoxShadow(
                  color: colors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: colors.error, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _resolving
                            ? Text(
                                '...',
                                style: TextStyle(color: colors.onSurfaceVariant),
                              )
                            : Text(
                                _resolvedArea ?? l10.moveMapToPickLocation,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: _resolvedArea != null
                                      ? colors.onSurface
                                      : colors.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  FilledBtn(
                    onPressed: _pickedLatLng == null
                        ? null
                        : () {
                            if (widget.pickOnly) {
                              Navigator.pop(context, (
                                latLng: _pickedLatLng!,
                                area: _resolvedArea,
                              ));
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AddressDetailsScreen(
                                    latLng: _pickedLatLng!,
                                    area: _resolvedArea ?? widget.existingAddress?.area,
                                    existingAddress: widget.existingAddress,
                                  ),
                                ),
                              );
                            }
                          },
                    title: l10.confirmLocation,
                    innerVerticalPadding: 16,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Details form ──────────────────────────────────────────────────────

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({
    super.key,
    required this.latLng,
    required this.area,
    this.existingAddress,
  });

  final LatLng latLng;
  final String? area;
  final CustomerAddress? existingAddress;

  bool get isEditing => existingAddress != null;

  @override
  State<AddressDetailsScreen> createState() => _AddressDetailsScreenState();
}

class _AddressDetailsScreenState extends State<AddressDetailsScreen> {
  late String _type;
  late final TextEditingController _buildingCtrl;
  late final TextEditingController _floorCtrl;
  late final TextEditingController _aptCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _directionsCtrl;
  bool _isSaving = false;
  late LatLng _latLng;
  late String? _area;

  static const _types = [
    ('home', Icons.home_outlined, 'Home'),
    ('apartment', Icons.apartment_outlined, 'Apartment'),
    ('work', Icons.work_outline_rounded, 'Work'),
    ('other', Icons.location_on_outlined, 'Other'),
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.existingAddress;
    _latLng = widget.latLng;
    _area = widget.area;
    _type = e?.type ?? 'home';
    _buildingCtrl = TextEditingController(text: e?.building ?? '');
    _floorCtrl = TextEditingController(text: e?.floor ?? '');
    _aptCtrl = TextEditingController(text: e?.apartment ?? '');
    _streetCtrl = TextEditingController(text: e?.street ?? '');
    _directionsCtrl = TextEditingController(text: e?.directions ?? '');
  }

  @override
  void dispose() {
    _buildingCtrl.dispose();
    _floorCtrl.dispose();
    _aptCtrl.dispose();
    _streetCtrl.dispose();
    _directionsCtrl.dispose();
    super.dispose();
  }

  bool get _canSave => _buildingCtrl.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _isSaving = true);
    final provider = context.read<LoggedCustomerProvider>();
    if (widget.isEditing) {
      await provider.updateAddress(
        id: widget.existingAddress!.id,
        type: _type,
        building: _buildingCtrl.text.trim(),
        floor: _floorCtrl.text.trim(),
        apartment: _aptCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        directions: _directionsCtrl.text.trim(),
        latitude: _latLng.latitude,
        longitude: _latLng.longitude,
        area: _area,
      );
      if (mounted) Navigator.pop(context);
    } else {
      await provider.addAddress(
        type: _type,
        building: _buildingCtrl.text.trim(),
        floor: _floorCtrl.text.trim().isEmpty ? null : _floorCtrl.text.trim(),
        apartment: _aptCtrl.text.trim().isEmpty ? null : _aptCtrl.text.trim(),
        street: _streetCtrl.text.trim().isEmpty ? null : _streetCtrl.text.trim(),
        directions: _directionsCtrl.text.trim().isEmpty ? null : _directionsCtrl.text.trim(),
        area: _area,
        latitude: _latLng.latitude,
        longitude: _latLng.longitude,
      );
      if (mounted) {
        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final isApartment = _type == 'apartment';

    return Scaffold(
      appBar: CustomAppBar(title: widget.isEditing ? l10.editAddress : l10.addressDetails),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Location row with change button
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () async {
                final result = await Navigator.push<({LatLng latLng, String? area})>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddressPickerScreen(
                      existingAddress: widget.existingAddress,
                      pickOnly: true,
                      initialLatLng: _latLng,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    _latLng = result.latLng;
                    _area = result.area;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, size: 18, color: colors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _area ?? l10.moveMapToPickLocation,
                        style: TextStyle(
                          fontSize: 13,
                          color: _area != null ? colors.onSurface : colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10.changeLocation,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Type selector
            Text(
              l10.addressType,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: _types.map((t) {
                final (key, icon, label) = t;
                final selected = _type == key;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? colors.inverseSurface : colors.surfaceContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            icon,
                            size: 24,
                            color: selected ? colors.onInverseSurface : colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: selected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: selected
                                  ? colors.onInverseSurface
                                  : colors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Building / Villa
            _Field(
              controller: _buildingCtrl,
              label: l10.buildingVilla,
              hint: l10.buildingVillaHint,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),

            // Floor + Apt (only for apartment)
            if (isApartment) ...[
              Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: _Field(
                      controller: _floorCtrl,
                      label: l10.floor,
                      hint: '3',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Expanded(
                    child: _Field(
                      controller: _aptCtrl,
                      label: l10.aptNumber,
                      hint: '12',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],

            // Street
            _Field(
              controller: _streetCtrl,
              label: l10.street,
              hint: l10.streetHint,
            ),
            const SizedBox(height: 14),

            // Directions
            _Field(
              controller: _directionsCtrl,
              label: l10.additionalDirections,
              hint: l10.additionalDirectionsHint,
              maxLines: 3,
            ),
            const SizedBox(height: 32),

            FilledBtn(
              isLoading: _isSaving,
              onPressed: _canSave ? _save : null,
              title: widget.isEditing ? l10.saveChanges : l10.saveAddress,
              innerVerticalPadding: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.outlineVariant),
            filled: true,
            fillColor: colors.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }
}
