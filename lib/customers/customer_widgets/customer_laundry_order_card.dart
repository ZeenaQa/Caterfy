import 'package:caterfy/models/laundry_order.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerLaundryOrderCard extends StatelessWidget {
  const CustomerLaundryOrderCard({super.key, required this.order});

  final LaundryOrder order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final orderDate = order.createdAt != null
        ? DateFormat("MMM d - h:mm a").format(DateTime.parse(order.createdAt!).toLocal())
        : '';

    final statusLabel = () {
      switch (order.status?.toLowerCase()) {
        case 'delivered':
          return 'Delivered';
        case 'in_progress':
        case 'in progress':
          return 'In Progress';
        case 'scheduled':
        default:
          return 'Scheduled';
      }
    }();

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
          // ── Header ─────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outline)),
            ),
            child: Row(
              spacing: 13,
              children: [
                Text(
                  statusLabel,
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

          // ── Body ───────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon box
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.local_laundry_service_rounded,
                    color: Colors.blue.shade400,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Laundry Service',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        order.service,
                        style: TextStyle(
                          height: 1.2,
                          color: colors.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Details ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                _DetailChip(
                  icon: Icons.schedule_rounded,
                  label: 'Pickup: ${order.pickupTime}',
                ),
                _DetailChip(
                  icon: Icons.calendar_today_rounded,
                  label: 'Delivery: ${order.deliveryDate}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        Icon(icon, size: 13, color: colors.onSurfaceVariant),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }
}
