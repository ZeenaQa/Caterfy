import 'dart:math';

import 'package:caterfy/customers/customer_widgets/customer_cart_section.dart';
import 'package:caterfy/customers/customer_widgets/customer_payment_row.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_add_card.dart';
import 'package:caterfy/customers/screens/customer_checkout.dart';
import 'package:caterfy/customers/screens/evouchers_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/voucher_order.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EVoucherCheckoutScreen extends StatefulWidget {
  const EVoucherCheckoutScreen({
    super.key,
    required this.provider,
    required this.denomination,
  });

  final VoucherProvider provider;
  final VoucherDenomination denomination;

  @override
  State<EVoucherCheckoutScreen> createState() => _EVoucherCheckoutScreenState();
}

class _EVoucherCheckoutScreenState extends State<EVoucherCheckoutScreen> {
  String _payment = 'cash';
  bool _useWallet = false;
  bool _isPlacing = false;
  VoucherOrder? _completedOrder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<LoggedCustomerProvider>(context, listen: false);
      final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
      await customerProvider.fetchPaymentMethods(context: context);
      await globalProvider.fetchUser();
    });
  }

  void _pickMethod(String val) => setState(() => _payment = val);

  bool _toggleWallet() {
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    final walletBalance =
        globalProvider.user != null ? (globalProvider.user['wallet_balance'] as num).toDouble() : 0.0;
    bool willReturn = false;
    if (!_useWallet) {
      if (walletBalance >= widget.denomination.priceJod) {
        willReturn = true;
        _pickMethod('wallet');
      }
    } else {
      if (_payment == 'wallet') _pickMethod('cash');
    }
    setState(() => _useWallet = !_useWallet);
    return willReturn;
  }

  Future<void> _confirmPurchase() async {
    setState(() => _isPlacing = true);

    final activationCode = VoucherOrder.generateCode(widget.provider.codeFormat);
    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    final walletBalance =
        globalProvider.user != null ? (globalProvider.user['wallet_balance'] as num).toDouble() : 0.0;

    final customerProvider = Provider.of<LoggedCustomerProvider>(context, listen: false);
    final order = await customerProvider.placeVoucherOrder(
      context: context,
      provider: widget.provider.name,
      providerCategory: widget.provider.category,
      denominationLabel: widget.denomination.label,
      priceJod: widget.denomination.priceJod,
      activationCode: activationCode,
      isUsingWallet: _useWallet,
      walletTransaction: _useWallet ? min(walletBalance, widget.denomination.priceJod) : 0,
    );

    if (!mounted) return;

    if (order != null && _useWallet) {
      // Refresh wallet balance shown elsewhere in the app
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

    final bool walletOnly = walletBalance >= widget.denomination.priceJod && _useWallet;

    final priceStr =
        '${widget.denomination.priceJod.toStringAsFixed(widget.denomination.priceJod % 1 == 0 ? 0 : 2)} ${l10.jod}';

    // ── Success screen ──────────────────────────────────────────────────────
    if (_completedOrder != null) {
      return Scaffold(
        appBar: CustomAppBar(
          content: Row(
            spacing: 10,
            children: [
              SvgPicture.asset('assets/icons/rounded_logo.svg', height: 30, width: 30),
              const Text(
                'Your Voucher',
                style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 32),
            child: _SuccessView(order: _completedOrder!, provider: widget.provider),
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
            SvgPicture.asset('assets/icons/rounded_logo.svg', height: 30, width: 30),
            const Text(
              'Checkout',
              style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      bottomNavigationBar: isPageLoading
          ? null
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
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
                            MaterialPageRoute(builder: (_) => const CustomerAddCard()),
                          );
                          return;
                        }
                        _confirmPurchase();
                      },
                title: 'Confirm Purchase — $priceStr',
                titleSize: 15,
              ),
            ),
      body: SafeArea(
        child: Skeletonizer(
          enabled: isPageLoading,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            children: [
              // ── Provider banner ───────────────────────────────────────────
              _ProviderBanner(provider: widget.provider),
              const SizedBox(height: 25),

              // ── Pay with ──────────────────────────────────────────────────
              PayWith(
                payment: _payment,
                pickMethod: _pickMethod,
                useWallet: _useWallet,
                toggleWallet: _toggleWallet,
                walletOnly: walletOnly,
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
                          title: widget.denomination.label,
                          price: widget.denomination.priceJod.toStringAsFixed(
                            widget.denomination.priceJod % 1 == 0 ? 0 : 2,
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
                              '$priceStr',
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

// ── Provider banner ───────────────────────────────────────────────────────────

class _ProviderBanner extends StatelessWidget {
  const _ProviderBanner({required this.provider});
  final VoucherProvider provider;

  @override
  Widget build(BuildContext context) {
    final p = provider;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [p.color, p.colorEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: p.color.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 14,
        children: [
          if (p.icon != null)
            FaIcon(p.icon!, color: Colors.white, size: 30)
          else
            Text(
              p.initials!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          Text(
            p.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatefulWidget {
  const _SuccessView({required this.order, required this.provider});
  final VoucherOrder order;
  final VoucherProvider provider;

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
    _checkScale = CurvedAnimation(parent: _checkController, curve: Curves.elasticOut);
    _checkController.forward();
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  Future<void> _copyCode() async {
    await Clipboard.setData(ClipboardData(text: widget.order.activationCode));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final o = widget.order;
    final p = widget.provider;

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
            child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 52),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Purchase Successful!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${p.name} · ${o.denominationLabel}',
          style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 32),

        // Activation code card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                p.color.withValues(alpha: 0.12),
                p.colorEnd.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: p.color.withValues(alpha: 0.25), width: 1.5),
          ),
          child: Column(
            children: [
              Text(
                'Your Activation Code',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: p.color.withValues(alpha: 0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  o.activationCode,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _copyCode,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: _copied ? Colors.green : p.color,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Icon(
                        _copied ? Icons.check_rounded : Icons.copy_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        _copied ? 'Copied!' : 'Copy Code',
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

        // Redemption note
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colors.onPrimaryFixedVariant,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            spacing: 10,
            children: [
              Icon(Icons.info_outline_rounded, size: 18, color: colors.onSurfaceVariant),
              Expanded(
                child: Text(
                  'Redeem on the ${p.name} platform. This code is also saved in your order history.',
                  style: TextStyle(fontSize: 12.5, color: colors.onSurfaceVariant),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Summary
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
              _SummaryRow(label: 'Provider', value: p.name),
              _SummaryRow(label: 'Denomination', value: o.denominationLabel),
              _SummaryRow(
                label: 'Paid',
                value:
                    '${o.priceJod.toStringAsFixed(o.priceJod % 1 == 0 ? 0 : 2)} JOD',
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
  const _SummaryRow({required this.label, required this.value, this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant)),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
