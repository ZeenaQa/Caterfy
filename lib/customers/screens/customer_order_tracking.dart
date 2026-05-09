import 'dart:async';

import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerOrderTracking extends StatefulWidget {
  final String orderId;

  const CustomerOrderTracking({super.key, required this.orderId});

  @override
  State<CustomerOrderTracking> createState() => _CustomerOrderTrackingState();
}

class _CustomerOrderTrackingState extends State<CustomerOrderTracking> {
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (!mounted) return;
      final provider = context.read<LoggedCustomerProvider>();
      final order = _findOrder(provider);
      if (order == null || order.isDelivered) {
        _pollTimer?.cancel();
        return;
      }
      provider.silentFetchOrderStatus(widget.orderId);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Order? _findOrder(LoggedCustomerProvider provider) {
    try {
      return provider.orderHistory.firstWhere((o) => o.id == widget.orderId);
    } catch (_) {
      return provider.orderHistory.isNotEmpty
          ? provider.orderHistory.first
          : null;
    }
  }

  int _stepFor(String? status) {
    switch (status?.toLowerCase()) {
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

  IconData _iconFor(int step) {
    switch (step) {
      case 1:
        return Icons.restaurant_outlined;
      case 2:
        return Icons.delivery_dining;
      case 3:
        return Icons.check_circle_outline;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedCustomerProvider>();
    final order = _findOrder(provider);

    final step = _stepFor(order?.status);
    final isDelivered = step == 3;

    final subtotal = order?.subtotal ?? 0.0;
    final deliveryFee = order?.deliveryPrice ?? 0.0;
    const serviceFee = 0.2;
    final total = subtotal + deliveryFee + serviceFee;

    final stepLabels = [
      l10.orderReceived,
      l10.preparingOrder,
      l10.outForDelivery,
      l10.delivered,
    ];

    return Scaffold(
      backgroundColor: colors.surface,

      // ── Fixed cancel / back button ─────────────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledBtn(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            title: isDelivered ? l10.back : l10.back,
            innerVerticalPadding: 15,
          ),
        ),
      ),

      body: Column(
        children: [
          // ── Top tinted area ─────────────────────────────────────────────────
          Container(
            color: colors.onPrimaryFixedVariant,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: colors.onSurface,
                        size: 20,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: colors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(38, 38),
                      ),
                    ),
                  ),

                  // Animated status icon
                  SizedBox(
                    height: 150,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: ScaleTransition(scale: anim, child: child),
                        ),
                        child: Icon(
                          key: ValueKey(step),
                          _iconFor(step),
                          size: 90,
                          color: colors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Scrollable white content ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step circles — outside the colored area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 18, 12, 4),
                    child: _TrackingSteps(
                      currentStep: step,
                      activeColor: colors.primary,
                      labels: stepLabels,
                    ),
                  ),

                  const SizedBox(height: 4),
                  _Divider(colors),

                  // Status title + subtitle
                  _Section(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: SizedBox(
                        key: ValueKey(step),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stepLabels[step],
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                l10.orderReceivedDesc,
                                l10.preparingOrderDesc,
                                l10.outForDeliveryDesc,
                                l10.deliveredDesc,
                              ][step],
                              style: TextStyle(
                                fontSize: 13,
                                color: colors.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  _Divider(colors),

                  // Store + items
                  if (order != null)
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your order from',
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  order.storeName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: colors.onSurface,
                                  ),
                                ),
                              ),
                              if (order.storeLogo.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    order.storeLogo,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _StoreFallback(colors),
                                  ),
                                )
                              else
                                _StoreFallback(colors),
                            ],
                          ),
                          const SizedBox(height: 14),
                          ...order.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      color: colors.primary.withAlpha(26),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${item.quantity}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: colors.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: colors.onSurface,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${l10.jod} ${(item.price * item.quantity).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _Divider(colors),

                  // Payment summary
                  if (order != null)
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10.paymentSummary,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _PaymentRow(
                            label: l10.subtotal,
                            value: '${l10.jod} ${subtotal.toStringAsFixed(2)}',
                            colors: colors,
                          ),
                          const SizedBox(height: 6),
                          _PaymentRow(
                            label: l10.deliveryFee,
                            value:
                                '${l10.jod} ${deliveryFee.toStringAsFixed(2)}',
                            colors: colors,
                          ),
                          const SizedBox(height: 6),
                          _PaymentRow(
                            label: l10.serviceFee,
                            value:
                                '${l10.jod} ${serviceFee.toStringAsFixed(2)}',
                            colors: colors,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: colors.outline),
                          ),
                          _PaymentRow(
                            label: l10.totalAmount,
                            value: '${l10.jod} ${total.toStringAsFixed(2)}',
                            bold: true,
                            colors: colors,
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step circles (below top area) ─────────────────────────────────────────────

class _TrackingSteps extends StatefulWidget {
  final int currentStep;
  final Color activeColor;
  final List<String> labels;

  const _TrackingSteps({
    required this.currentStep,
    required this.activeColor,
    required this.labels,
  });

  @override
  State<_TrackingSteps> createState() => _TrackingStepsState();
}

class _TrackingStepsState extends State<_TrackingSteps>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _glowAnim;

  static const _nodeSize = 44.0;
  static const _circleSize = 32.0;
  static const _icons = [
    Icons.receipt_long_outlined,
    Icons.restaurant_outlined,
    Icons.delivery_dining_outlined,
    Icons.home_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(
      begin: 0.10,
      end: 0.32,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  Widget _buildNode(int i) {
    final isCompleted = i < widget.currentStep;
    final isCurrent = i == widget.currentStep;
    final isActive = isCompleted || isCurrent;

    final innerCircle = Container(
      width: _circleSize,
      height: _circleSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? widget.activeColor : Colors.grey.withAlpha(45),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: widget.activeColor.withAlpha(65),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Icon(
        _icons[i],
        size: 15,
        color: isActive ? Colors.white : Colors.grey[500],
      ),
    );

    Widget node;
    if (isCurrent) {
      node = AnimatedBuilder(
        animation: _glowAnim,
        builder: (_, child) => Container(
          width: _nodeSize,
          height: _nodeSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.activeColor.withAlpha(
              (_glowAnim.value * 255).round(),
            ),
          ),
          child: Center(child: child),
        ),
        child: innerCircle,
      );
    } else {
      node = SizedBox(
        width: _nodeSize,
        height: _nodeSize,
        child: Center(child: innerCircle),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        node,
        const SizedBox(height: 5),
        SizedBox(
          width: 58,
          child: Text(
            widget.labels[i],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? widget.activeColor : Colors.grey[500],
              height: 1.2,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const connectorTopPad = (_nodeSize - 2) / 2;
    final children = <Widget>[];

    for (int i = 0; i < 4; i++) {
      children.add(_buildNode(i));
      if (i < 3) {
        children.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: connectorTopPad),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                height: 2,
                decoration: BoxDecoration(
                  color: i < widget.currentStep
                      ? widget.activeColor
                      : Colors.grey.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _StoreFallback extends StatelessWidget {
  final ColorScheme colors;
  const _StoreFallback(this.colors);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: colors.onPrimaryFixedVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.storefront_outlined, color: colors.primary),
    );
  }
}

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
  final ColorScheme colors;
  const _Divider(this.colors);

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: colors.outline);
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final ColorScheme colors;

  const _PaymentRow({
    required this.label,
    required this.value,
    required this.colors,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 15 : 13,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: bold ? colors.onSurface : colors.onSurfaceVariant,
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
