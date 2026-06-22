import 'package:caterfy/customers/customer_widgets/customer_payment_row.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/charity_screen.dart';
import 'package:caterfy/customers/screens/customer_checkout.dart';
import 'package:caterfy/models/charity_donation.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CharityCheckoutScreen extends StatefulWidget {
  const CharityCheckoutScreen({
    super.key,
    required this.org,
    required this.amount,
  });

  final CharityOrg org;
  final double amount;

  @override
  State<CharityCheckoutScreen> createState() =>
      _CharityCheckoutScreenState();
}

class _CharityCheckoutScreenState extends State<CharityCheckoutScreen> {
  String _payment = 'add';
  bool _useWallet = false;
  bool _isPlacing = false;
  bool _donated = false;
  late String _refNumber;

  @override
  void initState() {
    super.initState();
    _refNumber = _generateRef();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider =
          Provider.of<LoggedCustomerProvider>(context, listen: false);
      final globalProvider =
          Provider.of<GlobalProvider>(context, listen: false);
      await customerProvider.fetchPaymentMethods(context: context);
      await globalProvider.fetchUser();
    });
  }

  String _generateRef() => CharityDonation.generateRef();

  void _pickMethod(String val) => setState(() => _payment = val);

  bool _toggleWallet() {
    final globalProvider =
        Provider.of<GlobalProvider>(context, listen: false);
    final balance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;
    bool willReturn = false;
    if (!_useWallet) {
      if (balance >= widget.amount) {
        willReturn = true;
        _pickMethod('wallet');
      }
    } else {
      if (_payment == 'wallet') _pickMethod('add');
    }
    setState(() => _useWallet = !_useWallet);
    return willReturn;
  }

  Future<void> _confirmDonation() async {
    setState(() => _isPlacing = true);
    final globalProvider =
        context.read<GlobalProvider>();
    final walletBalance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;
    final result =
        await context.read<LoggedCustomerProvider>().placeCharityDonation(
              context: context,
              orgName: widget.org.name,
              orgCategory: widget.org.category,
              amountJod: widget.amount,
              reference: _refNumber,
              isUsingWallet: _useWallet,
              walletTransaction:
                  _useWallet ? walletBalance.clamp(0, widget.amount) : 0,
            );
    if (!mounted) return;
    if (result != null) {
      if (_useWallet) await globalProvider.fetchUser();
      setState(() {
        _isPlacing = false;
        _donated = true;
      });
    } else {
      setState(() => _isPlacing = false);
    }
  }

  // ── Success screen ────────────────────────────────────────────────────────────

  Widget _buildSuccess(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final org = widget.org;
    final amountStr =
        '${widget.amount.toStringAsFixed(widget.amount % 1 == 0 ? 0 : 2)} ${l10.jod}';

    return Scaffold(
      appBar: CustomAppBar(
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/rounded_logo.svg',
                height: 30, width: 30),
            const Text(
              'Donation Confirmed',
              style: TextStyle(
                  fontSize: 17.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (_, v, child) =>
                    Transform.scale(scale: v, child: child),
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [org.color, org.colorEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(Icons.favorite,
                      color: Colors.white, size: 42),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Thank you!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your donation of $amountStr to\n${org.name} has been received.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.5,
                  color: colors.onSurfaceVariant,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 28),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(18),
                  border:
                      Border.all(color: colors.outline.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: org.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Icon(Icons.tag_rounded,
                              size: 15, color: org.color),
                          Text(
                            _refNumber,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              color: org.color,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Clipboard.setData(
                                ClipboardData(text: _refNumber)),
                            child: Icon(Icons.copy_rounded,
                                size: 15, color: org.color),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _SummaryRow(
                        label: 'Organisation',
                        value: org.name,
                        colors: colors),
                    const SizedBox(height: 10),
                    _SummaryRow(
                        label: 'Cause',
                        value: _categoryLabel(org.category),
                        colors: colors),
                    const SizedBox(height: 10),
                    _SummaryRow(
                        label: 'Amount',
                        value: amountStr,
                        colors: colors,
                        valueColor: org.color),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: org.color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 17, color: org.color),
                    Expanded(
                      child: Text(
                        'Your donation goes directly to ${org.name}. A receipt has been sent to your registered email.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.onSurface,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Checkout screen ───────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_donated) return _buildSuccess(context);

    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final globalProvider = context.watch<GlobalProvider>();
    final customerProvider = context.watch<LoggedCustomerProvider>();
    final org = widget.org;

    final bool isLoading =
        customerProvider.isCheckoutLoading || globalProvider.isFetchingUser;

    final walletBalance = globalProvider.user != null
        ? (globalProvider.user['wallet_balance'] as num).toDouble()
        : 0.0;
    final walletOnly = walletBalance >= widget.amount && _useWallet;
    final amountStr =
        '${widget.amount.toStringAsFixed(widget.amount % 1 == 0 ? 0 : 2)} ${l10.jod}';

    return Scaffold(
      appBar: CustomAppBar(title: 'Donation Summary'),
      bottomNavigationBar: Container(
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
          onPressed: _isPlacing ? null : _confirmDonation,
          title: 'Confirm Donation',
          titleSize: 15,
        ),
      ),
      body: Skeletonizer(
        enabled: isLoading,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Row(
                spacing: 14,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [org.color, org.colorEnd],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(org.icon, color: Colors.white, size: 26),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        org.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: org.color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colors.outline),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.volunteer_activism,
                      label: 'Cause',
                      value: _categoryLabel(org.category),
                      color: org.color,
                      colors: colors,
                      isFirst: true,
                    ),
                    _DetailRow(
                      icon: Icons.payments_outlined,
                      label: 'Donation Amount',
                      value: amountStr,
                      color: org.color,
                      colors: colors,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              PayWith(
                payment: _payment,
                pickMethod: _pickMethod,
                useWallet: _useWallet,
                toggleWallet: _toggleWallet,
                walletOnly: walletOnly,
              ),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: org.color.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 18, color: org.color),
                    Expanded(
                      child: Text(
                        '100% of your donation goes directly to ${org.name}. Caterfy does not take any fees.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.onSurface,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    if (category == 'relief') return 'Relief';
    if (category == 'health') return 'Health';
    if (category == 'education') return 'Education';
    if (category == 'environment') return 'Nature';
    if (category == 'animals') return 'Animals';
    return category;
  }
}

// ── Detail row ────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ColorScheme colors;
  final bool isFirst;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.colors,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Summary row ───────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ColorScheme colors;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.colors,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: colors.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? colors.onSurface,
          ),
        ),
      ],
    );
  }
}
