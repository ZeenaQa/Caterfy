import 'package:caterfy/customers/screens/charity_checkout_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Data models ───────────────────────────────────────────────────────────────

class CharityOrg {
  final String name;
  final String category;
  final String description;
  final String mission;
  final Color color;
  final Color colorEnd;
  final IconData icon;
  final List<double> amounts;

  const CharityOrg({
    required this.name,
    required this.category,
    required this.description,
    required this.mission,
    required this.color,
    required this.colorEnd,
    required this.icon,
    required this.amounts,
  });
}

// ── Category keys ─────────────────────────────────────────────────────────────

const _kRelief = 'relief';
const _kHealth = 'health';
const _kEducation = 'education';
const _kEnvironment = 'environment';
const _kAnimals = 'animals';

// ── Charity catalogue ─────────────────────────────────────────────────────────

const _charities = <CharityOrg>[
  CharityOrg(
    name: 'Tkiyet Um Ali',
    category: _kRelief,
    description: 'Fighting food insecurity across Jordan',
    mission:
        'Tkiyet Um Ali is Jordan\'s first and largest non-profit organization dedicated to feeding the hungry. Since 2003, it has provided millions of meals to families in need across the Kingdom.',
    color: Color(0xFFE65100),
    colorEnd: Color(0xFFBF360C),
    icon: Icons.volunteer_activism,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Jordan Hashemite Charity',
    category: _kRelief,
    description: 'Emergency relief & humanitarian aid',
    mission:
        'The Jordan Hashemite Charity Organization provides emergency relief and humanitarian assistance to vulnerable populations in Jordan and across the region, including refugees and displaced families.',
    color: Color(0xFFD84315),
    colorEnd: Color(0xFFBF360C),
    icon: Icons.home_outlined,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'King Hussein Cancer Foundation',
    category: _kHealth,
    description: 'Advancing cancer care & research in Jordan',
    mission:
        'KHCF supports the King Hussein Cancer Center in providing world-class cancer treatment and funding research to improve outcomes for patients across Jordan and the broader Arab world.',
    color: Color(0xFFC62828),
    colorEnd: Color(0xFF8E0000),
    icon: Icons.favorite,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Jordan Heart Fund',
    category: _kHealth,
    description: 'Saving lives through cardiac care',
    mission:
        'The Jordan Heart Fund supports open-heart surgeries for children and adults who cannot afford treatment, ensuring that life-saving cardiac care is accessible to all Jordanians.',
    color: Color(0xFFAD1457),
    colorEnd: Color(0xFF880E4F),
    icon: Icons.monitor_heart_outlined,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Queen Rania Foundation',
    category: _kEducation,
    description: 'Transforming education for Arab youth',
    mission:
        'QRF drives education reform and innovation across the Arab world through programmes that empower teachers, expand digital learning, and champion early childhood education.',
    color: Color(0xFF1565C0),
    colorEnd: Color(0xFF0D47A1),
    icon: Icons.school_outlined,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Abdul Hameed Shoman Foundation',
    category: _kEducation,
    description: 'Championing science, culture & knowledge',
    mission:
        'The Abdul Hameed Shoman Foundation promotes scientific research, cultural activities, and lifelong learning in Jordan, supporting students, researchers, and creatives since 1978.',
    color: Color(0xFF283593),
    colorEnd: Color(0xFF1A237E),
    icon: Icons.menu_book_outlined,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Royal Society for Nature',
    category: _kEnvironment,
    description: 'Protecting Jordan\'s natural heritage',
    mission:
        'The Royal Society for the Conservation of Nature safeguards Jordan\'s biodiversity by managing nature reserves, running environmental education programmes, and promoting ecotourism.',
    color: Color(0xFF2E7D32),
    colorEnd: Color(0xFF1B5E20),
    icon: Icons.eco_outlined,
    amounts: [5, 10, 25, 50],
  ),
  CharityOrg(
    name: 'Jordan SPCA',
    category: _kAnimals,
    description: 'Protecting & rehoming animals in Jordan',
    mission:
        'The Jordan SPCA rescues stray and abused animals, provides veterinary care, and runs adoption programmes — giving thousands of animals a second chance each year.',
    color: Color(0xFFE65100),
    colorEnd: Color(0xFFBF360C),
    icon: Icons.pets,
    amounts: [5, 10, 25, 50],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class CharityScreen extends StatefulWidget {
  const CharityScreen({super.key});

  @override
  State<CharityScreen> createState() => _CharityScreenState();
}

class _CharityScreenState extends State<CharityScreen> {
  String _filter = 'all';

  List<CharityOrg> get _visible =>
      _filter == 'all'
          ? _charities
          : _charities.where((c) => c.category == _filter).toList();

  void _openDonation(CharityOrg org) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DonationSheet(org: org),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final filters = [
      ('all', l10.filterAll),
      (_kRelief, 'Relief'),
      (_kHealth, 'Health'),
      (_kEducation, 'Education'),
      (_kEnvironment, 'Nature'),
      (_kAnimals, 'Animals'),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/rounded_logo.svg',
                height: 30, width: 30),
            Text(
              l10.charity,
              style: const TextStyle(
                  fontSize: 17.5, fontWeight: FontWeight.w600),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 9),
                itemCount: filters.length,
                itemBuilder: (context, i) {
                  final (key, label) = filters[i];
                  final selected = _filter == key;
                  return Padding(
                    padding: EdgeInsets.only(
                        right: i < filters.length - 1 ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _filter = key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 6),
                        decoration: BoxDecoration(
                          color: selected
                              ? colors.primary
                              : colors.onPrimaryFixedVariant,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? colors.onPrimary
                                : colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ── Org list ───────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: ListView.builder(
                  key: ValueKey(_filter),
                  padding:
                      const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _CharityCard(
                      org: _visible[index],
                      onTap: () => _openDonation(_visible[index]),
                    ),
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

// ── Charity card ──────────────────────────────────────────────────────────────

class _CharityCard extends StatelessWidget {
  const _CharityCard({required this.org, required this.onTap});

  final CharityOrg org;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border:
              Border.all(color: colors.outline.withValues(alpha: 0.5)),
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [org.color, org.colorEnd],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(org.icon, color: Colors.white, size: 28),
                    const SizedBox(height: 6),
                    Text(
                      _categoryLabel(org.category),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(14, 14, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        org.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From 5 JOD',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: org.color,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [org.color, org.colorEnd]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Donate',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    switch (category) {
      case _kRelief:
        return 'Relief';
      case _kHealth:
        return 'Health';
      case _kEducation:
        return 'Education';
      case _kEnvironment:
        return 'Nature';
      case _kAnimals:
        return 'Animals';
      default:
        return category;
    }
  }
}

// ── Donation bottom sheet ─────────────────────────────────────────────────────

class _DonationSheet extends StatefulWidget {
  const _DonationSheet({required this.org});
  final CharityOrg org;

  @override
  State<_DonationSheet> createState() => _DonationSheetState();
}

class _DonationSheetState extends State<_DonationSheet> {
  double? _selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final org = widget.org;

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
        MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            Row(
              spacing: 14,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [org.color, org.colorEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: org.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child:
                        Icon(org.icon, color: Colors.white, size: 26),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        org.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        org.description,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Text(
              org.mission,
              style: TextStyle(
                fontSize: 13,
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 22),
            Text(
              'Select donation amount',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: org.amounts.map((amount) {
                final isSelected = _selected == amount;
                return GestureDetector(
                  onTap: () => setState(() => _selected = amount),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? org.color
                          : colors.onPrimaryFixedVariant,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? org.color
                            : colors.outline.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '${amount.toStringAsFixed(amount % 1 == 0 ? 0 : 2)} JOD',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : colors.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _selected == null
                    ? null
                    : () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CharityCheckoutScreen(
                              org: org,
                              amount: _selected!,
                            ),
                          ),
                        );
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: org.color,
                  disabledBackgroundColor:
                      colors.onPrimaryFixedVariant,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _selected == null
                      ? 'Select an amount'
                      : 'Donate ${_selected!.toStringAsFixed(_selected! % 1 == 0 ? 0 : 2)} JOD',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
