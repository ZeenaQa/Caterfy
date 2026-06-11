import 'package:caterfy/customers/screens/evoucher_checkout_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ── Denomination ──────────────────────────────────────────────────────────────

class VoucherDenomination {
  final String label;     // e.g. "$10 Gift Card" or "800 Robux"
  final double priceJod;  // price charged in JOD
  const VoucherDenomination({required this.label, required this.priceJod});
}

// ── Provider data model ───────────────────────────────────────────────────────

class VoucherProvider {
  final String name;
  final Color color;
  final Color colorEnd;
  final IconData? icon;
  final String? initials;
  final String category;
  final List<VoucherDenomination> denominations;
  final String codeFormat; // 'X' = random alphanumeric char

  const VoucherProvider({
    required this.name,
    required this.color,
    Color? colorEnd,
    this.icon,
    this.initials,
    required this.category,
    required this.denominations,
    required this.codeFormat,
  }) : colorEnd = colorEnd ?? color;
}

// ── Category keys ─────────────────────────────────────────────────────────────

const _kGaming = 'gaming';
const _kStreaming = 'streaming';
const _kShopping = 'shopping';

// ── Provider catalogue ────────────────────────────────────────────────────────

const _providers = <VoucherProvider>[
  // ── Gaming ──────────────────────────────────────────────────────────────────
  VoucherProvider(
    name: 'Xbox',
    color: Color(0xFF107C10),
    colorEnd: Color(0xFF0D6A0D),
    icon: FontAwesomeIcons.xbox,
    category: _kGaming,
    codeFormat: 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX',
    denominations: [
      VoucherDenomination(label: '\$10 Gift Card', priceJod: 7),
      VoucherDenomination(label: '\$25 Gift Card', priceJod: 18),
      VoucherDenomination(label: '\$50 Gift Card', priceJod: 36),
      VoucherDenomination(label: '\$100 Gift Card', priceJod: 72),
    ],
  ),
  VoucherProvider(
    name: 'PlayStation',
    color: Color(0xFF003087),
    colorEnd: Color(0xFF0070D1),
    icon: FontAwesomeIcons.playstation,
    category: _kGaming,
    codeFormat: 'XXXXX-XXXXX-XXXXX',
    denominations: [
      VoucherDenomination(label: '\$10 PSN Card', priceJod: 7),
      VoucherDenomination(label: '\$25 PSN Card', priceJod: 18),
      VoucherDenomination(label: '\$50 PSN Card', priceJod: 36),
      VoucherDenomination(label: '\$100 PSN Card', priceJod: 72),
    ],
  ),
  VoucherProvider(
    name: 'Steam',
    color: Color(0xFF1B2838),
    colorEnd: Color(0xFF2A475E),
    icon: FontAwesomeIcons.steam,
    category: _kGaming,
    codeFormat: 'XXXXX-XXXXX-XXXXX',
    denominations: [
      VoucherDenomination(label: '\$5 Wallet Card', priceJod: 4),
      VoucherDenomination(label: '\$10 Wallet Card', priceJod: 7),
      VoucherDenomination(label: '\$20 Wallet Card', priceJod: 14),
      VoucherDenomination(label: '\$50 Wallet Card', priceJod: 36),
      VoucherDenomination(label: '\$100 Wallet Card', priceJod: 72),
    ],
  ),
  VoucherProvider(
    name: 'Nintendo',
    color: Color(0xFFE60012),
    colorEnd: Color(0xFFC4000F),
    initials: 'Nin',
    category: _kGaming,
    codeFormat: 'XXXX-XXXX-XXXX-XXXX',
    denominations: [
      VoucherDenomination(label: '\$10 eShop Card', priceJod: 7),
      VoucherDenomination(label: '\$20 eShop Card', priceJod: 14),
      VoucherDenomination(label: '\$35 eShop Card', priceJod: 25),
      VoucherDenomination(label: '\$50 eShop Card', priceJod: 36),
    ],
  ),
  VoucherProvider(
    name: 'Roblox',
    color: Color(0xFFE92929),
    colorEnd: Color(0xFFBF1F1F),
    initials: 'Rbx',
    category: _kGaming,
    codeFormat: 'XXXXXXXXXXXXXXXX',
    denominations: [
      VoucherDenomination(label: '800 Robux', priceJod: 7),
      VoucherDenomination(label: '2,000 Robux', priceJod: 18),
      VoucherDenomination(label: '4,500 Robux', priceJod: 36),
    ],
  ),
  // ── Streaming ────────────────────────────────────────────────────────────────
  VoucherProvider(
    name: 'Netflix',
    color: Color(0xFFE50914),
    colorEnd: Color(0xFFB20710),
    initials: 'N',
    category: _kStreaming,
    codeFormat: 'XXXX-XXXX-XXXX',
    denominations: [
      VoucherDenomination(label: '\$15 Gift Card', priceJod: 11),
      VoucherDenomination(label: '\$30 Gift Card', priceJod: 21),
      VoucherDenomination(label: '\$60 Gift Card', priceJod: 43),
    ],
  ),
  VoucherProvider(
    name: 'Spotify',
    color: Color(0xFF1DB954),
    colorEnd: Color(0xFF158A3E),
    icon: FontAwesomeIcons.spotify,
    category: _kStreaming,
    codeFormat: 'XXXXXXXXXXXXXXXX',
    denominations: [
      VoucherDenomination(label: '1 Month Premium', priceJod: 7),
      VoucherDenomination(label: '3 Months Premium', priceJod: 21),
      VoucherDenomination(label: '6 Months Premium', priceJod: 42),
    ],
  ),
  // ── Shopping ─────────────────────────────────────────────────────────────────
  VoucherProvider(
    name: 'Google Play',
    color: Color(0xFF4285F4),
    colorEnd: Color(0xFF1A73E8),
    icon: FontAwesomeIcons.google,
    category: _kShopping,
    codeFormat: 'XXXX-XXXX-XXXX-XXXX',
    denominations: [
      VoucherDenomination(label: '\$10 Gift Card', priceJod: 7),
      VoucherDenomination(label: '\$25 Gift Card', priceJod: 18),
      VoucherDenomination(label: '\$50 Gift Card', priceJod: 36),
    ],
  ),
  VoucherProvider(
    name: 'Apple',
    color: Color(0xFF555555),
    colorEnd: Color(0xFF2D2D2D),
    icon: FontAwesomeIcons.apple,
    category: _kShopping,
    codeFormat: 'XXXX-XXXX-XXXX-XXXX',
    denominations: [
      VoucherDenomination(label: '\$10 App Store & iTunes', priceJod: 7),
      VoucherDenomination(label: '\$25 App Store & iTunes', priceJod: 18),
      VoucherDenomination(label: '\$50 App Store & iTunes', priceJod: 36),
      VoucherDenomination(label: '\$100 App Store & iTunes', priceJod: 72),
    ],
  ),
  VoucherProvider(
    name: 'Amazon',
    color: Color(0xFFFF9900),
    colorEnd: Color(0xFFD47900),
    icon: FontAwesomeIcons.amazon,
    category: _kShopping,
    codeFormat: 'XXXX-XXXX-XXXX',
    denominations: [
      VoucherDenomination(label: '\$10 Gift Card', priceJod: 7),
      VoucherDenomination(label: '\$25 Gift Card', priceJod: 18),
      VoucherDenomination(label: '\$50 Gift Card', priceJod: 36),
      VoucherDenomination(label: '\$100 Gift Card', priceJod: 72),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class EVouchersScreen extends StatefulWidget {
  const EVouchersScreen({super.key});

  @override
  State<EVouchersScreen> createState() => _EVouchersScreenState();
}

class _EVouchersScreenState extends State<EVouchersScreen> {
  String _filter = 'all';

  List<VoucherProvider> get _visible =>
      _filter == 'all' ? _providers : _providers.where((p) => p.category == _filter).toList();

  void _openDenominations(VoucherProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DenominationSheet(provider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final filters = [
      ('all', l10.filterAll),
      (_kGaming, l10.filterGaming),
      (_kStreaming, l10.filterStreaming),
      (_kShopping, l10.filterShopping),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/rounded_logo.svg', height: 30, width: 30),
            Text(
              l10.eVouchers,
              style: const TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Filter chips ───────────────────────────────────────────────────
            SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                itemCount: filters.length,
                itemBuilder: (context, i) {
                  final (key, label) = filters[i];
                  final selected = _filter == key;
                  return Padding(
                    padding: EdgeInsets.only(right: i < filters.length - 1 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected ? colors.primary : colors.onPrimaryFixedVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected ? colors.onPrimary : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Provider grid ──────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: GridView.builder(
                  key: ValueKey(_filter),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) => _ProviderCard(
                    provider: _visible[index],
                    onTap: () => _openDenominations(_visible[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Provider card ─────────────────────────────────────────────────────────────

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider, required this.onTap});

  final VoucherProvider provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [provider.color, provider.colorEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: provider.color.withValues(alpha: 0.35),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (provider.icon != null)
              FaIcon(provider.icon!, color: Colors.white, size: 30)
            else
              Text(
                provider.initials!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                provider.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Denomination bottom sheet ─────────────────────────────────────────────────

class _DenominationSheet extends StatefulWidget {
  const _DenominationSheet({required this.provider});
  final VoucherProvider provider;

  @override
  State<_DenominationSheet> createState() => _DenominationSheetState();
}

class _DenominationSheetState extends State<_DenominationSheet> {
  VoucherDenomination? _selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final p = widget.provider;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 38,
              height: 4,
              margin: const EdgeInsets.only(bottom: 22),
              decoration: BoxDecoration(
                color: colors.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Provider header
          Row(
            spacing: 14,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [p.color, p.colorEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: p.color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: p.icon != null
                      ? FaIcon(p.icon!, color: Colors.white, size: 24)
                      : Text(
                          p.initials!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    l10.selectDenomination,
                    style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Denomination chips
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: p.denominations.map((d) {
              final isSelected = _selected == d;
              return GestureDetector(
                onTap: () => setState(() => _selected = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? p.color : colors.onPrimaryFixedVariant,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: p.color.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d.label,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isSelected ? Colors.white : colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${d.priceJod.toStringAsFixed(d.priceJod % 1 == 0 ? 0 : 2)} JOD',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.85)
                              : colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 26),

          FilledBtn(
            onPressed: _selected != null
                ? () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EVoucherCheckoutScreen(
                          provider: p,
                          denomination: _selected!,
                        ),
                      ),
                    );
                  }
                : null,
            title: _selected != null
                ? '${l10.continueBtn} — ${_selected!.priceJod.toStringAsFixed(_selected!.priceJod % 1 == 0 ? 0 : 2)} ${l10.jod}'
                : l10.selectDenomination,
            titleSize: 15,
          ),
        ],
      ),
    );
  }
}
