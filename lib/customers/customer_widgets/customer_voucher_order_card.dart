import 'package:caterfy/models/voucher_order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CustomerVoucherOrderCard extends StatelessWidget {
  const CustomerVoucherOrderCard({super.key, required this.order});

  final VoucherOrder order;

  void _showCodeDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _CodeSheet(order: order),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final orderDate = order.createdAt != null
        ? DateFormat("MMM d - h:mm a").format(DateTime.parse(order.createdAt!).toLocal())
        : '';

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
                  'Completed',
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
                    color: colors.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.confirmation_number_rounded,
                    color: colors.primary,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.provider,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        order.denominationLabel,
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

          // ── Footer ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price
                RichText(
                  text: TextSpan(
                    text: 'JOD ',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: order.priceJod.toStringAsFixed(
                          order.priceJod % 1 == 0 ? 0 : 2,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // View Code button
                GestureDetector(
                  onTap: () => _showCodeDialog(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.outline),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      spacing: 6,
                      children: [
                        Icon(Icons.key_rounded, size: 14, color: colors.onSurface),
                        Text(
                          'View Code',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: colors.onSurface,
                          ),
                        ),
                      ],
                    ),
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

// ── Code bottom sheet ─────────────────────────────────────────────────────────

class _CodeSheet extends StatefulWidget {
  const _CodeSheet({required this.order});
  final VoucherOrder order;

  @override
  State<_CodeSheet> createState() => _CodeSheetState();
}

class _CodeSheetState extends State<_CodeSheet> {
  bool _copied = false;

  Future<void> _copy() async {
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

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Provider + denomination
          Text(
            o.provider,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            o.denominationLabel,
            style: TextStyle(fontSize: 14, color: colors.onSurfaceVariant),
          ),

          const SizedBox(height: 24),

          // Code box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: colors.onPrimaryFixedVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              o.activationCode,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.8,
                fontFamily: 'monospace',
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 16),

          // Copy button
          GestureDetector(
            onTap: _copy,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _copied ? Colors.green : colors.primary,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),
          Text(
            'Redeem on the ${o.provider} platform.',
            style: TextStyle(fontSize: 12.5, color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
