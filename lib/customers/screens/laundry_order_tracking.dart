import 'dart:async';

import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/laundry_order.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LaundryOrderTracking extends StatefulWidget {
  final String orderId;

  const LaundryOrderTracking({super.key, required this.orderId});

  @override
  State<LaundryOrderTracking> createState() => _LaundryOrderTrackingState();
}

class _LaundryOrderTrackingState extends State<LaundryOrderTracking> {
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
      provider.silentFetchLaundryOrderStatus(widget.orderId);
    });
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  LaundryOrder? _findOrder(LoggedCustomerProvider provider) {
    try {
      return provider.laundryOrders.firstWhere((o) => o.id == widget.orderId);
    } catch (_) {
      return provider.laundryOrders.isNotEmpty
          ? provider.laundryOrders.first
          : null;
    }
  }

  int _stepFor(String? status) {
    switch (status?.toLowerCase()) {
      case 'processing':
        return 1;
      case 'out_for_delivery':
        return 2;
      case 'delivered':
        return 3;
      default:
        return 0;
    }
  }

  IconData _iconFor(int step) {
    switch (step) {
      case 1:
        return Icons.local_laundry_service_outlined;
      case 2:
        return Icons.delivery_dining_outlined;
      case 3:
        return Icons.check_circle_outline;
      default:
        return Icons.schedule_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedCustomerProvider>();
    final order = _findOrder(provider);

    final step = _stepFor(order?.status);

    final stepLabels = [
      l10.laundryOrderPlaced,
      l10.laundryInCleaning,
      l10.laundryOnTheWay,
      l10.delivered,
    ];

    final stepDescs = [
      l10.laundryOrderPlacedDesc,
      l10.laundryInCleaningDesc,
      l10.laundryOnTheWayDesc,
      l10.laundryDeliveredDesc,
    ];

    return Scaffold(
      backgroundColor: colors.surface,

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledBtn(
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            title: l10.back,
            innerVerticalPadding: 15,
          ),
        ),
      ),

      body: Column(
        children: [
          // ── Top tinted area ──────────────────────────────────────────────────
          Container(
            color: colors.onPrimaryFixedVariant,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

          // ── Scrollable content ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 18, 12, 4),
                    child: _LaundryTrackingSteps(
                      currentStep: step,
                      activeColor: colors.primary,
                      labels: stepLabels,
                    ),
                  ),

                  const SizedBox(height: 4),
                  _Divider(colors),

                  // Status title + description
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
                              stepDescs[step],
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

                  // Order details
                  if (order != null)
                    _Section(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10.orderSummary,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _OrderDetailRow(
                            icon: Icons.local_laundry_service_outlined,
                            label: l10.selectService,
                            value: order.service,
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _OrderDetailRow(
                            icon: Icons.location_on_outlined,
                            label: l10.address,
                            value: order.address,
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _OrderDetailRow(
                            icon: Icons.schedule_outlined,
                            label: l10.pickUp,
                            value: order.pickupTime,
                            colors: colors,
                          ),
                          const SizedBox(height: 10),
                          _OrderDetailRow(
                            icon: Icons.calendar_month_outlined,
                            label: l10.deliveryDate,
                            value: order.deliveryDate,
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

// ── Laundry-specific tracking steps ──────────────────────────────────────────

class _LaundryTrackingSteps extends StatefulWidget {
  final int currentStep;
  final Color activeColor;
  final List<String> labels;

  const _LaundryTrackingSteps({
    required this.currentStep,
    required this.activeColor,
    required this.labels,
  });

  @override
  State<_LaundryTrackingSteps> createState() => _LaundryTrackingStepsState();
}

class _LaundryTrackingStepsState extends State<_LaundryTrackingSteps>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  late final Animation<double> _glowAnim;

  static const _nodeSize = 44.0;
  static const _circleSize = 32.0;
  static const _icons = [
    Icons.schedule_outlined,
    Icons.local_laundry_service_outlined,
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
    _glowAnim = Tween<double>(begin: 0.10, end: 0.32)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));
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
            color: widget.activeColor.withAlpha((_glowAnim.value * 255).round()),
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

    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: children);
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
  final ColorScheme colors;
  const _Divider(this.colors);

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: colors.outline);
  }
}

class _OrderDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ColorScheme colors;

  const _OrderDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: colors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: colors.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
