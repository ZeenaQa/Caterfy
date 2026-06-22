import 'package:caterfy/customers/customer_widgets/customer_charity_order_card.dart';
import 'package:caterfy/customers/customer_widgets/customer_laundry_order_card.dart';
import 'package:caterfy/customers/customer_widgets/customer_no_orders.dart';
import 'package:caterfy/customers/customer_widgets/customer_order_card.dart';
import 'package:caterfy/customers/customer_widgets/customer_ticket_order_card.dart';
import 'package:caterfy/customers/customer_widgets/customer_voucher_order_card.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/charity_donation.dart';
import 'package:caterfy/models/laundry_order.dart';
import 'package:caterfy/models/order.dart';
import 'package:caterfy/models/ticket_order.dart';
import 'package:caterfy/models/voucher_order.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ── Unified entry ─────────────────────────────────────────────────────────────

class _OrderEntry {
  final Order? regularOrder;
  final LaundryOrder? laundryOrder;
  final VoucherOrder? voucherOrder;
  final TicketOrder? ticketOrder;
  final CharityDonation? charityDonation;
  final DateTime date;

  _OrderEntry.regular(Order o)
      : regularOrder = o,
        laundryOrder = null,
        voucherOrder = null,
        ticketOrder = null,
        charityDonation = null,
        date = DateTime.tryParse(o.createdAt ?? '') ?? DateTime(0);

  _OrderEntry.laundry(LaundryOrder o)
      : regularOrder = null,
        laundryOrder = o,
        voucherOrder = null,
        ticketOrder = null,
        charityDonation = null,
        date = DateTime.tryParse(o.createdAt ?? '') ?? DateTime(0);

  _OrderEntry.voucher(VoucherOrder o)
      : regularOrder = null,
        laundryOrder = null,
        voucherOrder = o,
        ticketOrder = null,
        charityDonation = null,
        date = DateTime.tryParse(o.createdAt ?? '') ?? DateTime(0);

  _OrderEntry.ticket(TicketOrder o)
      : regularOrder = null,
        laundryOrder = null,
        voucherOrder = null,
        ticketOrder = o,
        charityDonation = null,
        date = DateTime.tryParse(o.createdAt ?? '') ?? DateTime(0);

  _OrderEntry.charity(CharityDonation o)
      : regularOrder = null,
        laundryOrder = null,
        voucherOrder = null,
        ticketOrder = null,
        charityDonation = o,
        date = DateTime.tryParse(o.createdAt ?? '') ?? DateTime(0);
}

List<_OrderEntry> _buildUnified(
  List<Order> orders,
  List<LaundryOrder> laundryOrders,
  List<VoucherOrder> voucherOrders,
  List<TicketOrder> ticketOrders,
  List<CharityDonation> charityDonations,
) {
  final all = [
    ...orders.map(_OrderEntry.regular),
    ...laundryOrders.map(_OrderEntry.laundry),
    ...voucherOrders.map(_OrderEntry.voucher),
    ...ticketOrders.map(_OrderEntry.ticket),
    ...charityDonations.map(_OrderEntry.charity),
  ];
  all.sort((a, b) => b.date.compareTo(a.date));
  return all;
}

// ── Screen ────────────────────────────────────────────────────────────────────

class CustomerOrdersSection extends StatelessWidget {
  const CustomerOrdersSection({super.key, this.removeTitle = false});
  final bool removeTitle;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);

    final isLoading = customerProvider.isOrderHistoryLoading;

    final unified = _buildUnified(
      customerProvider.orderHistory,
      customerProvider.laundryOrders,
      customerProvider.voucherOrders,
      customerProvider.ticketOrders,
      customerProvider.charityDonations,
    );

    return SafeArea(
      child: Skeletonizer(
        enabled: isLoading,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!removeTitle)
                Skeleton.keep(
                  child: Text(
                    l10.orders,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (unified.isEmpty && !isLoading)
                CustomerNoOrders()
              else ...[
                if (!removeTitle) const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: isLoading ? dummyOrders.length : unified.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final isLast = index ==
                          (isLoading ? dummyOrders.length : unified.length) - 1;

                      Widget card;
                      if (isLoading) {
                        card = CustomerOrderCard(
                          order: dummyOrders[index],
                          dummyImage: true,
                        );
                      } else {
                        final entry = unified[index];
                        if (entry.regularOrder != null) {
                          card = CustomerOrderCard(order: entry.regularOrder!);
                        } else if (entry.laundryOrder != null) {
                          card = CustomerLaundryOrderCard(order: entry.laundryOrder!);
                        } else if (entry.voucherOrder != null) {
                          card = CustomerVoucherOrderCard(order: entry.voucherOrder!);
                        } else if (entry.charityDonation != null) {
                          card = CustomerCharityOrderCard(donation: entry.charityDonation!);
                        } else {
                          card = CustomerTicketOrderCard(order: entry.ticketOrder!);
                        }
                      }

                      return isLast
                          ? Column(children: [card, const SizedBox(height: 25)])
                          : card;
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
