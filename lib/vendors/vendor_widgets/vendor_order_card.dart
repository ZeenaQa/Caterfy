import 'package:caterfy/customers/screens/customer_order_details_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/vendor_order.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

const url =
    'https://marketplace.canva.com/EAGMppVJ_aY/1/0/1600w/canva-dark-green-cute-and-playful-kitchen-restaurant-logo-S2LGeYCK5eM.jpg';

class VendorOrderCard extends StatefulWidget {
  const VendorOrderCard({super.key, required this.order});

  final VendorOrder order;

  @override
  State<VendorOrderCard> createState() => _VendorOrderCardState();
}

class _VendorOrderCardState extends State<VendorOrderCard> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.status ?? 'pending';
  }

  String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'preparing':
        return 'Preparing';
      case 'out_for_delivery':
        return 'Out for Delivery';
      case 'delivered':
        return 'Delivered';
      default:
        return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    String getInitial(String name) {
      if (name.isEmpty) return '';
      return name[0].toUpperCase();
    }

    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final vendorProvider = Provider.of<LoggedVendorProvider>(context, listen: false);
    final orderDate = widget.order.createdAt != null
        ? DateFormat(
            "MMM d - h:mm a",
          ).format(DateTime.parse(widget.order.createdAt!).toLocal())
        : '';

    double getTotalPrice() {
      double totalPrice = 0;
      for (int i = 0; i < widget.order.items.length; i++) {
        final price = widget.order.items[i].price;
        final quantity = widget.order.items[i].quantity;
        totalPrice += price * quantity;
      }
      return totalPrice;
    }

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outline)),
            ),
            child: Row(
              spacing: 13,
              children: [
                Text(
                  getStatusText(_selectedStatus),
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  orderDate,
                  style: TextStyle(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.onPrimaryContainer,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          getInitial(widget.order.customerName ?? ''),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.order.customerName ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: 'JOD ',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: getTotalPrice().toStringAsFixed(2),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 2),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerOrderDetailScreen(),
                          ),
                        ),
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          l10.viewDetails,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: colors.onSurface,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(value: 'preparing', child: Text('Preparing')),
                      DropdownMenuItem(value: 'out_for_delivery', child: Text('Out for Delivery')),
                      DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                    ],
                    onChanged: (value) async {
                      if (value != null) {
                        final previousStatus = _selectedStatus;
                        final messenger = ScaffoldMessenger.of(context);

                        setState(() {
                          _selectedStatus = value;
                        });

                        final success = await vendorProvider.updateOrderStatus(
                          orderId: widget.order.id,
                          status: value,
                        );

                        if (!success) {
                          setState(() {
                            _selectedStatus = previousStatus;
                          });
                          messenger.showSnackBar(
                            SnackBar(content: Text(l10.somethingWentWrong)),
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}