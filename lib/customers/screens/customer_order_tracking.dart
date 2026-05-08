import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOrderTracking extends StatefulWidget {
  final Order? order;
  final String? initialStatus;

  const CustomerOrderTracking({super.key, this.order, this.initialStatus});

  @override
  State<CustomerOrderTracking> createState() => _CustomerOrderTrackingState();
}

class _CustomerOrderTrackingState extends State<CustomerOrderTracking> {
  static const _orange = Color(0xFFFF6B00);
  static const _cream = Color(0xFFFFF0E6);

  Future<void> _refreshOrders() async {
    final provider = context.read<LoggedCustomerProvider>();
    await provider.fetchOrderHistory(context: context);
  }

  int _currentStep(Order? order) {
    final status = order?.status ?? widget.initialStatus;
    if (status == null || status.isEmpty) return 0;
    switch (status.toLowerCase()) {
      case 'preparing':
      case 'processing':
      case 'accepted':
      case 'confirmed':
        return 1;
      case 'out_for_delivery':
      case 'out for delivery':
      case 'on_the_way':
      case 'picked_up':
      case 'shipped':
      case 'enroute':
      case 'delivering':
        return 2;
      case 'delivered':
      case 'completed':
        return 3;
      default:
        return 0;
    }
  }

  String _statusTitle(AppLocalizations l10, int step) {
    switch (step) {
      case 0: return l10.orderReceived;       // e.g. "Order Placed! We're on it"
      case 1: return l10.preparingOrder;
      case 2: return l10.outForDelivery;      // e.g. "Your order on the way"
      case 3: return l10.delivered;
      default: return '';
    }
  }

  String _statusSubtitle(AppLocalizations l10, int step) {
    switch (step) {
      case 0: return l10.orderReceivedDesc;   // e.g. "Your order is under approval"
      case 1: return l10.preparingOrderDesc;
      case 2: return l10.outForDeliveryDesc;  // e.g. "Omar has picked up your order..."
      case 3: return l10.deliveredDesc;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final provider = context.watch<LoggedCustomerProvider>();
    final activeOrder = widget.order ??
        (provider.orderHistory.isNotEmpty ? provider.orderHistory.first : null);
    final step = _currentStep(activeOrder);
    final isOutForDelivery = step == 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Cream illustration area ────────────────────────────────────────
          Container(
            color: _cream,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(38, 38),
                      ),
                    ),
                  ),

                  // TODO: replace with your video/Lottie per-status animation
                  SizedBox(
                    height: 180,
                    child: Center(
                      child: Icon(
                        isOutForDelivery
                            ? Icons.delivery_dining
                            : Icons.receipt_long_outlined,
                        size: 100,
                        color: _orange.withOpacity(0.22),
                      ),
                    ),
                  ),

                  // ETA + segmented bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'l10.estimatedArrival',
                          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '22 mins',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _SegmentedBar(totalSteps: 4, currentStep: step, color: _orange),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── White scrollable content ───────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status title + subtitle
                  _Section(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _statusTitle(l10, step),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _statusSubtitle(l10, step),
                          style: TextStyle(fontSize: 13, color: Colors.grey[500], height: 1.5),
                        ),
                      ],
                    ),
                  ),

                  _Divider(),

                  // Delivery hero row (only when out for delivery)
                  if (isOutForDelivery) ...[
                    _Section(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Omar', // TODO: replace with driver name from order
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'is your delivery hero for today',
                                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          // TODO: replace with driver avatar image
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: _cream,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: _orange, size: 28),
                          ),
                        ],
                      ),
                    ),
                    _Divider(),
                    // Contact row
                    _Section(
                      child: Row(
                        children: [
                          const Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.chevron_right, color: Colors.grey[400]),
                        ],
                      ),
                    ),
                    _Divider(),
                  ],

                  // Delivering to
                  _Section(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivering to',
                          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Home', // TODO: from order model
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Egypt, Cairo, Elmohandseen', // TODO: from order model
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                        Text(
                          'Mobile Number: 01275318664', // TODO: from order model
                          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  _Divider(),

                  // Your order from
                  if (activeOrder != null)
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your order from',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activeOrder.storeName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Area: ${'activeOrder.storeArea' ?? ''}', // TODO: add storeArea to model if missing
                                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                              // TODO: replace with store logo image
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _cream,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.storefront_outlined, color: _orange),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Order items
                          ...activeOrder.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _Divider(),

                  // Payment summary
                  if (activeOrder != null)
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Payment summary',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _PaymentRow(
                            label: 'Subtotal',
                            value: 'activeOrder.subtotal', // e.g. "EGP 120.00"
                          ),
                          const SizedBox(height: 6),
                          _PaymentRow(
                            label: 'Delivery fee',
                            value: activeOrder.deliveryPrice.toString(),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                          ),
                          _PaymentRow(
                            label: 'Total amount',
                            value: 'activeOrder.totalAmount',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  // Cancel / back button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).popUntil((r) => r.isFirst),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: step == 3 ? Colors.grey[300] : _orange,
                          foregroundColor: step == 3 ? Colors.black54 : Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          step == 3 ? l10.back : l10.cancel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Section extends StatelessWidget {
  final Widget child;
  const _Section({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2));
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: bold ? Colors.black87 : Colors.grey[600],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

// ── Segmented progress bar ────────────────────────────────────────────────────
class _SegmentedBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final Color color;

  const _SegmentedBar({
    required this.totalSteps,
    required this.currentStep,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
            decoration: BoxDecoration(
              color: i <= currentStep ? color : const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}