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
    final l10 = AppLocalizations.of(context);
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

class OnGoingOrders extends StatelessWidget {
  const OnGoingOrders({super.key, required this.activeOrders});

  final List<Order> activeOrders;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: SizedBox(
        height: 130,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: activeOrders.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final activeOrder = activeOrders[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CustomerOrderTracking(order: activeOrder),
                  ),
                );
              },
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.shadow.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 18,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10.trackYourOrder,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            activeOrder.storeName,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
