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
  Future<void> _refreshOrders() async {
    final provider = context.read<LoggedCustomerProvider>();
    await provider.fetchOrderHistory(context: context);
  }

  int _currentStep(Order? activeOrder) {
    final status = activeOrder?.status ?? widget.initialStatus;
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

  String _labelForStep(AppLocalizations l10, int step) {
    switch (step) {
      case 0:
        return l10.orderReceived;
      case 1:
        return l10.preparingOrder;
      case 2:
        return l10.outForDelivery;
      case 3:
        return l10.delivered;
      default:
        return '';
    }
  }

  String _subtitleForStep(AppLocalizations l10, int step) {
    switch (step) {
      case 0:
        return l10.orderReceivedDesc;
      case 1:
        return l10.preparingOrderDesc;
      case 2:
        return l10.outForDeliveryDesc;
      case 3:
        return l10.deliveredDesc;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final provider = context.watch<LoggedCustomerProvider>();
    final activeOrder = widget.order ??
        (provider.orderHistory.isNotEmpty
            ? provider.orderHistory.first
            : null);
    final currentStep = _currentStep(activeOrder);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10.orderTracking),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshOrders,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10.trackOrderDesc,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (activeOrder != null) ...[
                        Text(
                          activeOrder.storeName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activeOrder.items.length == 1
                              ? '${activeOrder.items.length} item'
                              : '${activeOrder.items.length} items',
                          style: TextStyle(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                      Expanded(
                        child: ListView.builder(
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            final isActive = index <= currentStep;
                            final isLast = index == 3;
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isActive
                                            ? colors.primary
                                            : colors.onSurfaceVariant.withOpacity(0.2),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          isActive ? Icons.check : Icons.circle,
                                          size: 14,
                                          color: isActive
                                              ? colors.onPrimary
                                              : colors.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    if (!isLast)
                                      Container(
                                        width: 2,
                                        height: 70,
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        color: colors.onSurfaceVariant.withOpacity(0.25),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _labelForStep(l10, index),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: isActive
                                              ? colors.onSurface
                                              : colors.onSurfaceVariant,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _subtitleForStep(l10, index),
                                        style: TextStyle(
                                          color: colors.onSurfaceVariant,
                                          height: 1.5,
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.primary),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          l10.back,
                          style: TextStyle(color: colors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
