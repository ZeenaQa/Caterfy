import 'dart:math';

import 'package:caterfy/customers/customer_widgets/customer_cart_section.dart';
import 'package:caterfy/customers/customer_widgets/customer_payment_row.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_add_card.dart';
import 'package:caterfy/customers/screens/customer_checkout.dart';
import 'package:caterfy/customers/screens/tickets_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/ticket_order.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TicketCheckoutScreen extends StatefulWidget {
  const TicketCheckoutScreen({
    super.key,
    required this.event,
    required this.tier,
  });

  final EventItem event;
  final TicketTier tier;

  @override
  State<TicketCheckoutScreen> createState() => _TicketCheckoutScreenState();
}

class _TicketCheckoutScreenState extends State<TicketCheckoutScreen> {
  String _payment = 'add';
  bool _useWallet = false;
  bool _isPlacing = false;
  TicketOrder? _completedOrder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider =
          Provider.of<LoggedCustomerProvider>(context, listen: false);
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);
      await customerProvider.fetchPaymentMethods(context: context);
      await globalProvider.fetchUser();
    });
  }

  void _pickMethod(String val) => setState(() => _payment = val);

  bool _toggleWallet() {
    final globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    final walletBalance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;
    bool willReturn = false;
    if (!_useWallet) {
      if (walletBalance >= widget.tier.priceJod) {
        willReturn = true;
        _pickMethod('wallet');
      }
    } else {
      if (_payment == 'wallet') _pickMethod('add');
    }
    setState(() => _useWallet = !_useWallet);
    return willReturn;
  }

  Future<void> _confirmPurchase() async {
    setState(() => _isPlacing = true);

    final bookingRef = TicketOrder.generateBookingRef();
    final globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    final walletBalance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;

    final customerProvider =
        Provider.of<LoggedCustomerProvider>(context, listen: false);
    final order = await customerProvider.placeTicketOrder(
      context: context,
      eventName: widget.event.name,
      eventCategory: widget.event.category,
      ticketType: widget.tier.name,
      eventDate: widget.event.date,
      venue: widget.event.venue,
      priceJod: widget.tier.priceJod,
      bookingRef: bookingRef,
      isUsingWallet: _useWallet,
      walletTransaction:
          _useWallet ? min(walletBalance, widget.tier.priceJod) : 0,
    );

    if (!mounted) return;

    if (order != null && _useWallet) {
      await globalProvider.fetchUser();
    }

    setState(() {
      _isPlacing = false;
      _completedOrder = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final globalProvider = Provider.of<GlobalProvider>(context);
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);

    final bool isPageLoading =
        customerProvider.isCheckoutLoading || globalProvider.isFetchingUser;

    final walletBalance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;

    final bool walletOnly =
        walletBalance >= widget.tier.priceJod && _useWallet;

    final priceStr =
        '${widget.tier.priceJod.toStringAsFixed(widget.tier.priceJod % 1 == 0 ? 0 : 2)} ${l10.jod}';

    // ── Success screen ──────────────────────────────────────────────────────
    if (_completedOrder != null) {
      return Scaffold(
        appBar: CustomAppBar(
          content: Row(
            spacing: 10,
            children: [
              SvgPicture.asset('assets/icons/rounded_logo.svg',
                  height: 30, width: 30),
              Text(
                l10.yourTicket,
                style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
            child: _SuccessView(
                order: _completedOrder!, event: widget.event),
          ),
        ),
      );
    }

    // ── Checkout screen ─────────────────────────────────────────────────────
    return Scaffold(
      appBar: CustomAppBar(
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/rounded_logo.svg',
                height: 30, width: 30),
            Text(
              l10.checkout,
              style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isPageLoading
          ? null
          : Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
                onPressed: _isPlacing
                    ? null
                    : () {
                        if (_payment == 'add') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CustomerAddCard()),
                          );
                          return;
                        }
                        _confirmPurchase();
                      },
                title: '${l10.confirm} — $priceStr',
                titleSize: 15,
              ),
            ),
      body: SafeArea(
        child: Skeletonizer(
          enabled: isPageLoading,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            children: [
              // ── Event banner ──────────────────────────────────────────────
              _EventBanner(event: widget.event, tier: widget.tier),
              const SizedBox(height: 25),

              // ── Pay with ──────────────────────────────────────────────────
              PayWith(
                payment: _payment,
                pickMethod: _pickMethod,
                useWallet: _useWallet,
                toggleWallet: _toggleWallet,
                walletOnly: walletOnly,
                noCash: true,
              ),
              const SizedBox(height: 25),

              // ── Price summary ─────────────────────────────────────────────
              CartSection(
                titlePadding: false,
                sectionTitle: l10.paymentSummary,
                content: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 6),
                    child: Column(
                      spacing: 11,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaymentRow(
                          title: '${widget.event.name} · ${widget.tier.name}',
                          price: widget.tier.priceJod.toStringAsFixed(
                            widget.tier.priceJod % 1 == 0 ? 0 : 2,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              l10.totalAmount,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              priceStr,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        if (_payment != 'cash' && _payment != 'wallet')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10.cardCheckoutTos),
                              Text(
                                l10.tos,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Event banner ──────────────────────────────────────────────────────────────

class _EventBanner extends StatelessWidget {
  const _EventBanner({required this.event, required this.tier});
  final EventItem event;
  final TicketTier tier;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [event.color, event.colorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: event.color.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              Icon(event.icon, color: Colors.white, size: 28),
              Expanded(
                child: Text(
                  event.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                _BannerRow(
                  icon: Icons.confirmation_number_rounded,
                  text: tier.name,
                ),
                _BannerRow(
                  icon: Icons.calendar_today_rounded,
                  text: event.date,
                ),
                _BannerRow(
                  icon: Icons.location_on_rounded,
                  text: event.venue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerRow extends StatelessWidget {
  const _BannerRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.85), size: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatefulWidget {
  const _SuccessView({required this.order, required this.event});
  final TicketOrder order;
  final EventItem event;

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  bool _copied = false;
  late AnimationController _checkController;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _checkScale =
        CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _checkController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Future<void> _copyRef() async {
    await Clipboard.setData(
        ClipboardData(text: widget.order.bookingRef));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final o = widget.order;
    final e = widget.event;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Animated check
        ScaleTransition(
          scale: _checkScale,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Colors.green, size: 52),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10.bookingConfirmed,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${e.name} · ${o.ticketType}',
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Booking reference card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                e.color.withValues(alpha: 0.12),
                e.colorEnd.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: e.color.withValues(alpha: 0.25), width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                l10.bookingReference,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: e.color.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  o.bookingRef,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _copyRef,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _copied ? Colors.green : e.color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Icon(
                        _copied
                            ? Icons.check_rounded
                            : Icons.copy_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        _copied ? l10.copiedLabel : l10.copyReference,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Info note
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.onPrimaryFixedVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.info_outline_rounded,
                  size: 18, color: colors.onSurfaceVariant),
              Expanded(
                child: Text(
                  l10.showBookingRefNote,
                  style: TextStyle(
                      fontSize: 12.5, color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Summary table
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.onPrimaryFixedVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            spacing: 8,
            children: [
              _SummaryRow(label: l10.eventLabel, value: e.name),
              _SummaryRow(label: l10.ticketLabel, value: o.ticketType),
              _SummaryRow(label: l10.dateLabel, value: o.eventDate),
              _SummaryRow(label: l10.venueLabel, value: o.venue),
              _SummaryRow(
                label: l10.paidLabel,
                value:
                    '${o.priceJod.toStringAsFixed(o.priceJod % 1 == 0 ? 0 : 2)} ${l10.jod}',
                bold: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(
      {required this.label, required this.value, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style:
                TextStyle(fontSize: 13.5, color: colors.onSurfaceVariant),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
