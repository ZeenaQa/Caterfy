import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/laundry_order_tracking.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaundryCheckoutScreen extends StatefulWidget {
  final String service;
  final String address;
  final String phone;
  final String pickupTime;
  final String deliveryDate;

  const LaundryCheckoutScreen({
    super.key,
    required this.service,
    required this.address,
    required this.phone,
    required this.pickupTime,
    required this.deliveryDate,
  });

  @override
  State<LaundryCheckoutScreen> createState() => _LaundryCheckoutScreenState();
}

class _LaundryCheckoutScreenState extends State<LaundryCheckoutScreen> {
  bool _isPlacing = false;

  Future<void> _placeOrder() async {
    setState(() => _isPlacing = true);
    final provider = context.read<LoggedCustomerProvider>();
    final orderId = await provider.placeLaundryOrder(
      context: context,
      service: widget.service,
      address: widget.address,
      phone: widget.phone,
      pickupTime: widget.pickupTime,
      deliveryDate: widget.deliveryDate,
    );
    if (!mounted) return;
    if (orderId != null) {
      await provider.fetchLaundryOrders(context: context);
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LaundryOrderTracking(orderId: orderId),
        ),
        (route) => route.isFirst,
      );
    } else {
      setState(() => _isPlacing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(title: l10.orderSummary),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 3.5),
            ),
          ],
        ),
        child: FilledBtn(
          isLoading: _isPlacing,
          onPressed: _isPlacing ? null : _placeOrder,
          title: l10.placeOrder,
          titleSize: 15,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.onPrimaryFixedVariant,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.local_laundry_service_rounded,
                    color: colors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10.laundry,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),
                    Text(
                      widget.service,
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Details card
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: colors.outline),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.local_laundry_service_outlined,
                    label: l10.selectService,
                    value: widget.service,
                    colors: colors,
                    isFirst: true,
                  ),
                  _DetailRow(
                    icon: Icons.location_on_outlined,
                    label: l10.address,
                    value: widget.address,
                    colors: colors,
                  ),
                  _DetailRow(
                    icon: Icons.phone_outlined,
                    label: l10.phone,
                    value: widget.phone,
                    colors: colors,
                  ),
                  _DetailRow(
                    icon: Icons.schedule_outlined,
                    label: l10.pickUp,
                    value: widget.pickupTime,
                    colors: colors,
                  ),
                  _DetailRow(
                    icon: Icons.calendar_month_outlined,
                    label: l10.deliveryDate,
                    value: widget.deliveryDate,
                    colors: colors,
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Pricing note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 18,
                    color: colors.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10.laundryPricingNote,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;
  final bool isFirst;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.primary),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
