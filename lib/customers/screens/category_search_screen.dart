import 'package:caterfy/customers/screens/customer_store_screen.dart';
import 'package:caterfy/customers/utils/localization_helpers.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategorySearchScreen extends StatefulWidget {
  const CategorySearchScreen({
    super.key,
    required this.stores,
    required this.category,
  });

  final List<Store> stores;
  final String category;

  @override
  State<CategorySearchScreen> createState() => _CategorySearchScreenState();
}

class _CategorySearchScreenState extends State<CategorySearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  List<String> _recentSearches = [];

  String get _prefsKey => 'category_recent_searches_${widget.category}';

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _controller.addListener(() {
      final q = _controller.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Recent searches ─────────────────────────────────────────────────────────

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recentSearches = prefs.getStringList(_prefsKey) ?? []);
  }

  Future<void> _saveRecent(String q) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    list.remove(q);
    list.insert(0, q);
    if (list.length > 8) list.removeLast();
    await prefs.setStringList(_prefsKey, list);
    if (mounted) setState(() => _recentSearches = list);
  }

  Future<void> _removeRecent(String q) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_prefsKey) ?? [];
    list.remove(q);
    await prefs.setStringList(_prefsKey, list);
    setState(() => _recentSearches = list);
  }

  Future<void> _clearAllRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    setState(() => _recentSearches = []);
  }

  void _applyRecent(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: q.length),
    );
  }

  // ── Filtering ────────────────────────────────────────────────────────────────

  List<Store> get _results => widget.stores.where((s) {
    return s.name.toLowerCase().contains(_query) ||
        s.name_ar.toLowerCase().contains(_query);
  }).toList();

  void _navigateToStore(Store store) {
    // Save the current query as a recent search when opening a store
    if (_query.isNotEmpty) _saveRecent(_controller.text.trim());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerStoreScreen(store: store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final results = _results;
    final noResults = _query.isNotEmpty && results.isEmpty;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        children: [
          // ── Search bar ────────────────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: () => Navigator.pop(context),
                        color: colors.onSurface,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: colors.onSurface,
                          ),
                          decoration: InputDecoration(
                            filled: false,
                            hintText:
                                '${l10.searchAbout} ${getLocalizedCategory(context, widget.category)}',
                            hintStyle: TextStyle(
                              color: colors.onSurfaceVariant,
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: colors.onSurfaceVariant,
                              size: 22,
                            ),
                            suffixIcon: _controller.text.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _controller.clear();
                                      _focusNode.requestFocus();
                                    },
                                    child: Icon(
                                      Icons.cancel_rounded,
                                      color: colors.onSurfaceVariant,
                                      size: 20,
                                    ),
                                  )
                                : null,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, thickness: 1, color: colors.outline),
              ],
            ),
          ),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: _query.isEmpty
                ? _RecentView(
                    searches: _recentSearches,
                    category: widget.category,
                    onTap: _applyRecent,
                    onRemove: _removeRecent,
                    onClearAll: _clearAllRecent,
                  )
                : noResults
                ? _NoResults(query: _query)
                : Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: results.length,
                      itemBuilder: (context, i) => _StoreRow(
                        store: results[i],
                        onTap: () => _navigateToStore(results[i]),
                        l10: l10,
                        isLast: i == results.length - 1,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Recent searches view ──────────────────────────────────────────────────────

class _RecentView extends StatelessWidget {
  const _RecentView({
    required this.searches,
    required this.category,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  final List<String> searches;
  final String category;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (searches.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_rounded, size: 60, color: colors.outlineVariant),
            const SizedBox(height: 14),
            Text(
              'Search ${getLocalizedCategory(context, category)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Find stores in this category',
              style: TextStyle(fontSize: 13, color: colors.outlineVariant),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent searches',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Items
        ...searches.map(
          (q) => InkWell(
            onTap: () => onTap(q),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              child: Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      q,
                      style: TextStyle(fontSize: 15, color: colors.onSurface),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onRemove(q),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Store row ─────────────────────────────────────────────────────────────────

class _StoreRow extends StatelessWidget {
  const _StoreRow({
    required this.store,
    required this.onTap,
    required this.l10,
    required this.isLast,
  });

  final Store store;
  final VoidCallback onTap;
  final AppLocalizations l10;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final name = locale == 'ar' && store.name_ar.isNotEmpty
        ? store.name_ar
        : store.name;
    final hasLogo = (store.logoUrl ?? '').isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(bottom: BorderSide(color: colors.outline, width: 0.8)),
        ),
        child: Row(
          children: [
            // Logo
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: hasLogo
                  ? Image.network(
                      store.logoUrl!,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _LogoPlaceholder(colors: colors),
                    )
                  : _LogoPlaceholder(colors: colors),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!store.isOpen)
                        Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: colors.errorContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            l10.closed,
                            style: TextStyle(
                              fontSize: 11,
                              color: colors.onErrorContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Consumer<GlobalProvider>(
                    builder: (_, gp, __) {
                      final deliveryTime = gp.getDeliveryTime(
                        store.latitude,
                        store.longitude,
                      );
                      final deliveryPrice = gp.getDeliveryPrice(
                        store.latitude,
                        store.longitude,
                      );
                      return Text(
                        '${store.storeArea != null ? '${store.storeArea} · ' : ''}'
                        '$deliveryTime ${l10.min} · ${l10.jod} $deliveryPrice',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: colors.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: colors.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder({required this.colors});
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.storefront_outlined,
        size: 24,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}

// ── No results ────────────────────────────────────────────────────────────────

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: colors.outlineVariant,
          ),
          const SizedBox(height: 14),
          Text(
            'No results for "$query"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different keyword',
            style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
