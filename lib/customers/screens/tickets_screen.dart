import 'package:caterfy/customers/screens/ticket_checkout_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ── Ticket tier ───────────────────────────────────────────────────────────────

class TicketTier {
  final String name;
  final double priceJod;
  final String description;
  const TicketTier({
    required this.name,
    required this.priceJod,
    required this.description,
  });
}

// ── Event data model ──────────────────────────────────────────────────────────

class EventItem {
  final String name;
  final String category;
  final String date;
  final String venue;
  final String description;
  final Color color;
  final Color colorEnd;
  final IconData icon;
  final List<TicketTier> tiers;

  const EventItem({
    required this.name,
    required this.category,
    required this.date,
    required this.venue,
    required this.description,
    required this.color,
    required this.colorEnd,
    required this.icon,
    required this.tiers,
  });
}

// ── Category keys ─────────────────────────────────────────────────────────────

const _kMusic = 'music';
const _kCulture = 'culture';
const _kSports = 'sports';
const _kFamily = 'family';

// ── Events catalogue ──────────────────────────────────────────────────────────

const _events = <EventItem>[
  // ── Music ────────────────────────────────────────────────────────────────────
  EventItem(
    name: 'Jerash Festival',
    category: _kMusic,
    date: 'Jul 23 – Aug 2, 2026',
    venue: 'Roman City of Jerash, Jerash',
    description:
        'Jordan\'s premier cultural event held among ancient Roman ruins. Features local and international performing artists, music, and dance.',
    color: Color(0xFF7C3AED),
    colorEnd: Color(0xFF5B21B6),
    icon: Icons.theater_comedy_rounded,
    tiers: [
      TicketTier(name: 'General Admission', priceJod: 15, description: 'Open area standing / bleachers'),
      TicketTier(name: 'Seated (Tier B)', priceJod: 25, description: 'Covered seating, mid section'),
      TicketTier(name: 'Seated (Tier A)', priceJod: 40, description: 'Premium covered seating, front'),
      TicketTier(name: 'VIP', priceJod: 75, description: 'VIP lounge, reserved front-row seating'),
    ],
  ),
  EventItem(
    name: 'Amman Jazz Festival',
    category: _kMusic,
    date: 'Oct 10–12, 2026',
    venue: 'Rainbow Street Open Air, Amman',
    description:
        'Three nights of jazz under the Amman sky. Local jazz ensembles and regional artists gather on Rainbow Street.',
    color: Color(0xFF0F4C75),
    colorEnd: Color(0xFF1B6CA8),
    icon: Icons.music_note_rounded,
    tiers: [
      TicketTier(name: 'General Entry', priceJod: 10, description: 'Open area access all 3 nights'),
      TicketTier(name: 'Reserved Seat', priceJod: 20, description: 'Numbered seat for selected night'),
      TicketTier(name: 'VIP Table', priceJod: 60, description: 'Private table for 2, all 3 nights'),
    ],
  ),
  EventItem(
    name: 'Wadi Rum Music Night',
    category: _kMusic,
    date: 'Nov 1, 2026',
    venue: 'Wadi Rum Desert, Aqaba Governorate',
    description:
        'A one-of-a-kind acoustic concert experience in the heart of Wadi Rum. International and Arab artists perform under a starlit desert sky.',
    color: Color(0xFFB45309),
    colorEnd: Color(0xFF92400E),
    icon: Icons.stars_rounded,
    tiers: [
      TicketTier(name: 'Desert Floor', priceJod: 35, description: 'Open desert floor seating (cushions provided)'),
      TicketTier(name: 'Elevated Deck', priceJod: 55, description: 'Raised wooden platform with reserved spots'),
      TicketTier(name: 'Glamping VIP', priceJod: 120, description: 'Overnight glamping tent + concert access'),
    ],
  ),
  EventItem(
    name: 'Dead Sea Electronic Night',
    category: _kMusic,
    date: 'Dec 6, 2026',
    venue: 'Kempinski Ishtar, Dead Sea',
    description:
        'An open-air electronic music event by the shores of the Dead Sea. Featuring regional DJs and international headline acts.',
    color: Color(0xFF065F46),
    colorEnd: Color(0xFF047857),
    icon: Icons.equalizer_rounded,
    tiers: [
      TicketTier(name: 'General', priceJod: 20, description: 'General floor access'),
      TicketTier(name: 'VIP Area', priceJod: 50, description: 'Dedicated VIP zone with bar access'),
    ],
  ),

  // ── Culture ───────────────────────────────────────────────────────────────────
  EventItem(
    name: 'Petra by Night',
    category: _kCulture,
    date: 'Every Mon, Wed & Thu',
    venue: 'The Treasury (Al-Khazneh), Petra',
    description:
        'Walk the candlelit Siq to the Treasury under a sky full of stars. An unforgettable Bedouin music and storytelling experience.',
    color: Color(0xFFC2410C),
    colorEnd: Color(0xFF9A3412),
    icon: Icons.account_balance_rounded,
    tiers: [
      TicketTier(name: 'Adult', priceJod: 17, description: 'Standard adult ticket'),
      TicketTier(name: 'Child (6–12)', priceJod: 8, description: 'Children under 12'),
    ],
  ),
  EventItem(
    name: 'Amman Design Week',
    category: _kCulture,
    date: 'Oct 18–26, 2026',
    venue: 'Ras Al-Ain, Downtown Amman',
    description:
        'An annual festival celebrating design, art, and innovation in the Middle East. Workshops, exhibitions, and talks spread across Amman.',
    color: Color(0xFF1D4ED8),
    colorEnd: Color(0xFF1E40AF),
    icon: Icons.palette_rounded,
    tiers: [
      TicketTier(name: 'Day Pass', priceJod: 5, description: 'Access all exhibitions for one day'),
      TicketTier(name: 'Full Festival Pass', priceJod: 18, description: 'Unlimited access all 8 days'),
      TicketTier(name: 'Workshop Bundle', priceJod: 35, description: 'Festival pass + 3 workshops of choice'),
    ],
  ),
  EventItem(
    name: 'Jordan Heritage Fair',
    category: _kCulture,
    date: 'Sep 5–7, 2026',
    venue: 'Roman Amphitheater, Downtown Amman',
    description:
        'Celebrate Jordanian craftsmanship and heritage. Traditional food, handmade crafts, folk music, and cultural performances.',
    color: Color(0xFF991B1B),
    colorEnd: Color(0xFF7F1D1D),
    icon: Icons.flag_rounded,
    tiers: [
      TicketTier(name: 'Entry', priceJod: 3, description: 'General entry for one day'),
      TicketTier(name: '3-Day Pass', priceJod: 8, description: 'Full weekend access'),
    ],
  ),

  // ── Sports ─────────────────────────────────────────────────────────────────────
  EventItem(
    name: 'Al-Wehdat vs Al-Faisaly',
    category: _kSports,
    date: 'Sep 20, 2026',
    venue: 'King Abdullah II Stadium, Amman',
    description:
        'The biggest rivalry in Jordanian football. The Amman Derby between Al-Wehdat and Al-Faisaly at the national stadium.',
    color: Color(0xFF059669),
    colorEnd: Color(0xFF047857),
    icon: Icons.sports_soccer_rounded,
    tiers: [
      TicketTier(name: 'South Stand', priceJod: 5, description: 'Al-Wehdat supporter end'),
      TicketTier(name: 'North Stand', priceJod: 5, description: 'Al-Faisaly supporter end'),
      TicketTier(name: 'East Stand', priceJod: 10, description: 'Neutral family seating'),
      TicketTier(name: 'VIP Lounge', priceJod: 30, description: 'Climate-controlled VIP box'),
    ],
  ),
  EventItem(
    name: 'Jordan International Rally',
    category: _kSports,
    date: 'Oct 25–27, 2026',
    venue: 'Wadi Rum & Dead Sea Route',
    description:
        'Jordan\'s iconic off-road rally race traversing desert dunes, rocky terrain, and scenic landscapes. Watch from dedicated spectator zones.',
    color: Color(0xFFDC2626),
    colorEnd: Color(0xFFB91C1C),
    icon: Icons.directions_car_rounded,
    tiers: [
      TicketTier(name: 'Spectator Day Pass', priceJod: 8, description: 'Access to one designated spectator zone'),
      TicketTier(name: '3-Day Pass', priceJod: 20, description: 'All spectator zones, all 3 days'),
      TicketTier(name: 'Paddock VIP', priceJod: 45, description: 'Paddock access + meet the drivers'),
    ],
  ),
  EventItem(
    name: 'Amman Marathon',
    category: _kSports,
    date: 'Apr 4, 2027',
    venue: 'Sport City, Amman',
    description:
        'Run through the streets of Amman in this annual marathon event. Choose your distance: 5K, 10K, or full marathon.',
    color: Color(0xFF0284C7),
    colorEnd: Color(0xFF0369A1),
    icon: Icons.directions_run_rounded,
    tiers: [
      TicketTier(name: '5K Entry', priceJod: 10, description: 'Fun run, all ages welcome'),
      TicketTier(name: '10K Entry', priceJod: 15, description: '10 kilometer competitive run'),
      TicketTier(name: 'Full Marathon', priceJod: 25, description: '42.2 km official timed race'),
    ],
  ),

  // ── Family ────────────────────────────────────────────────────────────────────
  EventItem(
    name: 'Jordan Kids Expo',
    category: _kFamily,
    date: 'Nov 14–16, 2026',
    venue: 'Zara Expo, Amman',
    description:
        'Three days of educational fun for children. Science experiments, arts & crafts, storytelling, and interactive shows.',
    color: Color(0xFFD97706),
    colorEnd: Color(0xFFB45309),
    icon: Icons.child_care_rounded,
    tiers: [
      TicketTier(name: 'Child (1 day)', priceJod: 8, description: 'One child, one day access'),
      TicketTier(name: 'Child (3 days)', priceJod: 20, description: 'One child, all 3 days'),
      TicketTier(name: 'Family Pack (1 day)', priceJod: 25, description: '2 adults + 2 children, one day'),
    ],
  ),
  EventItem(
    name: 'Amman International Book Fair',
    category: _kFamily,
    date: 'Oct 29 – Nov 8, 2026',
    venue: 'King Hussein Parks, Amman',
    description:
        'The largest book fair in the Arab world. Hundreds of publishers, authors, and cultural programs for all ages.',
    color: Color(0xFF4338CA),
    colorEnd: Color(0xFF3730A3),
    icon: Icons.menu_book_rounded,
    tiers: [
      TicketTier(name: 'Day Entry', priceJod: 2, description: 'Single day general entry'),
      TicketTier(name: 'Season Pass', priceJod: 12, description: 'Unlimited access all 10 days'),
    ],
  ),
  EventItem(
    name: 'Winter Wonderland Amman',
    category: _kFamily,
    date: 'Dec 20, 2026 – Jan 5, 2027',
    venue: 'The Abdali Mall Outdoor, Amman',
    description:
        'Amman\'s festive winter fair. Ice skating, light installations, holiday markets, live performances, and seasonal food stalls.',
    color: Color(0xFF0EA5E9),
    colorEnd: Color(0xFF0284C7),
    icon: Icons.ac_unit_rounded,
    tiers: [
      TicketTier(name: 'Entry', priceJod: 5, description: 'General fair entry'),
      TicketTier(name: 'Ice Skating', priceJod: 12, description: 'Entry + 1 hour ice skating session'),
      TicketTier(name: 'Full Experience', priceJod: 20, description: 'Entry + skating + rides + hot drinks'),
    ],
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  String _filter = 'all';

  List<EventItem> get _visible =>
      _filter == 'all' ? _events : _events.where((e) => e.category == _filter).toList();

  void _openTiers(EventItem event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _TierSheet(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final filters = [
      ('all', l10.filterAll),
      (_kMusic, l10.filterMusic),
      (_kCulture, l10.filterCulture),
      (_kSports, l10.filterSports),
      (_kFamily, l10.filterFamily),
    ];

    return Scaffold(
      appBar: CustomAppBar(
        content: Row(
          spacing: 10,
          children: [
            SvgPicture.asset('assets/icons/rounded_logo.svg', height: 30, width: 30),
            Text(
              l10.ticketsAndEvents,
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

            // ── Events list ────────────────────────────────────────────────────
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: ListView.builder(
                  key: ValueKey(_filter),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _EventCard(
                      event: _visible[index],
                      onTap: () => _openTiers(_visible[index]),
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

// ── Event card ────────────────────────────────────────────────────────────────

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event, required this.onTap});

  final EventItem event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: colors.outline.withValues(alpha: 0.5)),
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
            // Colored side band with icon
            Container(
              width: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [event.color, event.colorEnd],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(event.icon, color: Colors.white, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    _categoryLabel(event.category, l10),
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

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 12, color: colors.onSurfaceVariant),
                        Expanded(
                          child: Text(
                            event.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.location_on_rounded,
                            size: 12, color: colors.onSurfaceVariant),
                        Expanded(
                          child: Text(
                            event.venue,
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _buildFromPrice(event, l10),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: event.color,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [event.color, event.colorEnd]),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10.getTickets,
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

  String _buildFromPrice(EventItem event, AppLocalizations l10) {
    final minPrice = event.tiers
        .map((t) => t.priceJod)
        .reduce((a, b) => a < b ? a : b);
    final priceStr = minPrice.toStringAsFixed(minPrice % 1 == 0 ? 0 : 2);
    return '${l10.fromPrice} $priceStr ${l10.jod}';
  }

  String _categoryLabel(String category, AppLocalizations l10) {
    switch (category) {
      case _kMusic:
        return l10.filterMusic;
      case _kCulture:
        return l10.filterCulture;
      case _kSports:
        return l10.filterSports;
      case _kFamily:
        return l10.filterFamily;
      default:
        return category;
    }
  }
}

// ── Tier bottom sheet ─────────────────────────────────────────────────────────

class _TierSheet extends StatefulWidget {
  const _TierSheet({required this.event});
  final EventItem event;

  @override
  State<_TierSheet> createState() => _TierSheetState();
}

class _TierSheetState extends State<_TierSheet> {
  TicketTier? _selected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final e = widget.event;

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
      child: SingleChildScrollView(
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

            // Event header
            Row(
              spacing: 14,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [e.color, e.colorEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: e.color.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(e.icon, color: Colors.white, size: 26),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.name,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.location_on_rounded,
                              size: 12, color: colors.onSurfaceVariant),
                          Expanded(
                            child: Text(
                              e.venue,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colors.onSurfaceVariant),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Date chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: e.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 6,
                children: [
                  Icon(Icons.calendar_today_rounded, size: 13, color: e.color),
                  Text(
                    e.date,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: e.color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              e.description,
              style: TextStyle(
                fontSize: 13,
                color: colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              l10.selectTicketType,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 12),

            // Tier options
            ...e.tiers.map((tier) {
              final isSelected = _selected == tier;
              return GestureDetector(
                onTap: () => setState(() => _selected = tier),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? e.color.withValues(alpha: 0.08)
                        : colors.onPrimaryFixedVariant,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? e.color
                          : colors.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tier.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isSelected
                                    ? e.color
                                    : colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tier.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${tier.priceJod.toStringAsFixed(tier.priceJod % 1 == 0 ? 0 : 2)} JOD',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isSelected ? e.color : colors.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? e.color
                                : colors.outline,
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            FilledBtn(
              onPressed: _selected != null
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TicketCheckoutScreen(
                            event: e,
                            tier: _selected!,
                          ),
                        ),
                      );
                    }
                  : null,
              title: _selected != null
                  ? '${l10.continueBtn} — ${_selected!.priceJod.toStringAsFixed(_selected!.priceJod % 1 == 0 ? 0 : 2)} ${l10.jod}'
                  : l10.selectTicketType,
              titleSize: 15,
            ),
          ],
        ),
      ),
    );
  }
}
