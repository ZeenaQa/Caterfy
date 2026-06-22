import 'package:caterfy/models/charity_donation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

Color _categoryColor(String category) {
  switch (category) {
    case 'relief':
      return const Color(0xFFE65100);
    case 'health':
      return const Color(0xFFC62828);
    case 'education':
      return const Color(0xFF1565C0);
    case 'environment':
      return const Color(0xFF2E7D32);
    case 'animals':
      return const Color(0xFFE65100);
    default:
      return const Color(0xFF6A1B9A);
  }
}

IconData _categoryIcon(String category) {
  switch (category) {
    case 'relief':
      return Icons.volunteer_activism;
    case 'health':
      return Icons.favorite;
    case 'education':
      return Icons.school_outlined;
    case 'environment':
      return Icons.eco_outlined;
    case 'animals':
      return Icons.pets;
    default:
      return Icons.favorite_border;
  }
}

String _categoryLabel(String category) {
  switch (category) {
    case 'relief':
      return 'Relief';
    case 'health':
      return 'Health';
    case 'education':
      return 'Education';
    case 'environment':
      return 'Nature';
    case 'animals':
      return 'Animals';
    default:
      return category;
  }
}

class CustomerCharityOrderCard extends StatelessWidget {
  const CustomerCharityOrderCard({super.key, required this.donation});

  final CharityDonation donation;

  void _showReceiptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ReceiptSheet(donation: donation),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = _categoryColor(donation.orgCategory);

    final orderDate = donation.createdAt != null
        ? DateFormat('MMM d - h:mm a')
            .format(DateTime.parse(donation.createdAt!).toLocal())
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
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.outline)),
            ),
            child: Row(
              spacing: 13,
              children: [
                Text(
                  'Donation',
                  style: TextStyle(
                    color: color,
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _categoryIcon(donation.orgCategory),
                    color: color,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        donation.orgName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _categoryLabel(donation.orgCategory),
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
                RichText(
                  text: TextSpan(
                    text: 'JOD ',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontWeight: FontWeight.normal,
                    ),
                    children: [
                      TextSpan(
                        text: donation.amountJod.toStringAsFixed(
                          donation.amountJod % 1 == 0 ? 0 : 2,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _showReceiptSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.outline),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      spacing: 6,
                      children: [
                        Icon(Icons.receipt_long_rounded,
                            size: 14, color: colors.onSurface),
                        Text(
                          'View Receipt',
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

// ── Receipt bottom sheet ──────────────────────────────────────────────────────

class _ReceiptSheet extends StatefulWidget {
  const _ReceiptSheet({required this.donation});
  final CharityDonation donation;

  @override
  State<_ReceiptSheet> createState() => _ReceiptSheetState();
}

class _ReceiptSheetState extends State<_ReceiptSheet> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(
        ClipboardData(text: widget.donation.reference));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final d = widget.donation;
    final color = _categoryColor(d.orgCategory);
    final amountStr =
        '${d.amountJod.toStringAsFixed(d.amountJod % 1 == 0 ? 0 : 2)} JOD';

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(26)),
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
          Container(
            width: 38,
            height: 4,
            margin: const EdgeInsets.only(bottom: 22),
            decoration: BoxDecoration(
              color: colors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(_categoryIcon(d.orgCategory),
                color: color, size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            d.orgName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Thank you for your donation of $amountStr',
            style: TextStyle(
                fontSize: 13.5, color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: colors.onPrimaryFixedVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Donation Reference',
                  style: TextStyle(
                      fontSize: 12, color: colors.onSurfaceVariant),
                ),
                const SizedBox(height: 8),
                Text(
                  d.reference,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: _copy,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _copied ? Colors.green : color,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    _copied ? 'Copied!' : 'Copy Reference',
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
        ],
      ),
    );
  }
}
