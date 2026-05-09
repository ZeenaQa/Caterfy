import 'package:caterfy/customers/customer_widgets/customer_global_top_bar.dart';
import 'package:caterfy/customers/customer_widgets/customer_home_categories.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_order_tracking.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/util/wavy_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerHomeSection extends StatefulWidget {
  const CustomerHomeSection({super.key});

  @override
  _ScrollHideHeaderPageState createState() => _ScrollHideHeaderPageState();
}

class _ScrollHideHeaderPageState extends State<CustomerHomeSection>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  double headerHeight = 190;
  double currentHeaderOffset = 0;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      final double offset = _scrollController.offset;
      final double delta = offset - lastOffset;

      final double previousHeaderOffset = currentHeaderOffset;

      currentHeaderOffset -= delta;

      if (currentHeaderOffset > 0) {
        currentHeaderOffset = 0;
      } else if (currentHeaderOffset < -headerHeight) {
        currentHeaderOffset = -headerHeight;
      }

      if (currentHeaderOffset != previousHeaderOffset) {
        setState(() {});
      }

      lastOffset = offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final activeOrders = customerProvider.orderHistory
        .where((order) => order.isActiveOrder)
        .toList();

    final hasActiveOrders = activeOrders.isNotEmpty;

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(top: headerHeight),
            children: [
              if (hasActiveOrders) OnGoingOrders(activeOrders: activeOrders),
              CustomerHomeCategories(topMargin: hasActiveOrders ? 0 : 0),
            ],
          ),
          Transform.translate(
            offset: Offset(0, currentHeaderOffset),
            child: PhysicalShape(
              clipper: WavyClipper(waveHeight: 4),
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                height: headerHeight,
                padding: EdgeInsets.only(top: 25),
                child: CustomerGlobalTopBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ongoing orders strip ───────────────────────────────────────────────────────

class OnGoingOrders extends StatelessWidget {
  const OnGoingOrders({super.key, required this.activeOrders});

  final List<Order> activeOrders;

  static int stepFor(String? status) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 148,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: activeOrders.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final order = activeOrders[index];
            return _ActiveOrderCard(order: order, step: stepFor(order.status));
          },
        ),
      ),
    );
  }
}

// ── Single active-order card ───────────────────────────────────────────────────

class _ActiveOrderCard extends StatelessWidget {
  final Order order;
  final int step;

  const _ActiveOrderCard({required this.order, required this.step});

  static const _stageIcons = [
    Icons.receipt_long_outlined,
    Icons.restaurant_outlined,
    Icons.delivery_dining_outlined,
    Icons.check_circle_outline,
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final stageLabels = [
      l10.orderReceived,
      l10.preparingOrder,
      l10.outForDelivery,
      l10.delivered,
    ];

    final stageDescs = [
      l10.orderReceivedDesc,
      l10.preparingOrderDesc,
      l10.outForDeliveryDesc,
      l10.deliveredDesc,
    ];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerOrderTracking(orderId: order.id),
        ),
      ),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.primary.withAlpha(90), width: 1.5),
        ),
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: store logo + name + arrow ────────────────────────
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: order.storeLogo.isNotEmpty
                      ? Image.network(
                          order.storeLogo,
                          width: 38,
                          height: 38,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _LogoFallback(colors: colors),
                        )
                      : _LogoFallback(colors: colors),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.storeName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Stage label + description ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(_stageIcons[step], size: 16, color: colors.primary),
                const SizedBox(width: 7),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stageLabels[step],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: colors.onSurface,
                        ),
                      ),
                      Text(
                        stageDescs[step],
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.onSurfaceVariant,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Spacer(),

            // ── Mini segmented progress bar ────────────────────────────────
            Row(
              children: List.generate(4, (i) {
                final isActive = i <= step;
                return Expanded(
                  child: Container(
                    height: 3,
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: isActive
                          ? colors.primary
                          : colors.primary.withAlpha(30),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  final ColorScheme colors;
  const _LogoFallback({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      color: colors.onPrimaryFixedVariant,
      child: Icon(Icons.storefront_outlined, size: 20, color: colors.primary),
    );
  }
}
