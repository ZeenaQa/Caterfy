import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/address_picker_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/customer_address.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerAddressesScreen extends StatelessWidget {
  const CustomerAddressesScreen({super.key, this.selectionMode = false});

  final bool selectionMode;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedCustomerProvider>();
    final addresses = provider.addresses;

    return Scaffold(
      appBar: CustomAppBar(title: l10.savedAddresses),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddressPickerScreen()),
        ),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text(l10.addAddress),
        backgroundColor: colors.inverseSurface,
        foregroundColor: colors.onInverseSurface,
      ),
      body: provider.isAddressLoading
          ? const Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off_outlined, size: 64, color: colors.outlineVariant),
                  const SizedBox(height: 14),
                  Text(
                    l10.noSavedAddresses,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10.addAddressHint,
                    style: TextStyle(fontSize: 13, color: colors.outlineVariant),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => Divider(height: 1, color: colors.outline),
              itemBuilder: (context, index) {
                final addr = addresses[index];
                final isSelected = provider.selectedAddress?.id == addr.id;
                return _AddressTile(
                  address: addr,
                  isSelected: isSelected,
                  selectionMode: selectionMode,
                  onTap: () {
                    if (selectionMode) {
                      provider.selectAddress(addr);
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddressDetailsScreen(
                            latLng: addr.latLng,
                            area: addr.area,
                            existingAddress: addr,
                          ),
                        ),
                      );
                    }
                  },
                  onSetDefault: () => provider.setDefaultAddress(addr.id),
                  onDelete: () => _confirmDelete(context, provider, addr),
                );
              },
            ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    LoggedCustomerProvider provider,
    CustomerAddress addr,
  ) async {
    final l10 = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10.deleteAddress),
        content: Text(addr.subtitle.isNotEmpty ? addr.subtitle : addr.typeLabel),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) await provider.deleteAddress(addr.id);
  }
}

class _AddressTile extends StatelessWidget {
  const _AddressTile({
    required this.address,
    required this.isSelected,
    required this.selectionMode,
    required this.onTap,
    required this.onSetDefault,
    required this.onDelete,
  });

  final CustomerAddress address;
  final bool isSelected;
  final bool selectionMode;
  final VoidCallback onTap;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;

  IconData get _icon {
    switch (address.type) {
      case 'apartment': return Icons.apartment_outlined;
      case 'work': return Icons.work_outline_rounded;
      case 'other': return Icons.location_on_outlined;
      default: return Icons.home_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected ? colors.inverseSurface : colors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _icon,
                size: 22,
                color: isSelected ? colors.onInverseSurface : colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.typeLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.5,
                          color: colors.onSurface,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: colors.outline),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10.defaultLabel,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (address.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      address.subtitle,
                      style: TextStyle(fontSize: 12.5, color: colors.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (address.directions != null && address.directions!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      address.directions!,
                      style: TextStyle(fontSize: 12, color: colors.outlineVariant, fontStyle: FontStyle.italic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            if (selectionMode)
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                color: isSelected ? colors.primary : colors.outlineVariant,
                size: 22,
              )
            else
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'default') onSetDefault();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (_) => [
                  if (!address.isDefault)
                    PopupMenuItem(value: 'default', child: Text(l10.setAsDefault)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10.delete, style: const TextStyle(color: Colors.red)),
                  ),
                ],
                icon: Icon(Icons.more_vert_rounded, color: colors.onSurfaceVariant),
              ),
          ],
        ),
      ),
    );
  }
}
