import 'dart:async';

import 'package:caterfy/customers/screens/customer_store_screen.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Product result model (includes embedded store) ────────────────────────────

class _ProductResult {
  final String id;
  final String name;
  final String? imageUrl;
  final double price;
  final Store store;

  _ProductResult({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.price,
    required this.store,
  });

  factory _ProductResult.fromMap(Map<String, dynamic> map) {
    return _ProductResult(
      id: map['id'],
      name: map['name'],
      imageUrl: map['image_url'],
      price: (map['price'] as num).toDouble(),
      store: Store.fromMap(Map<String, dynamic>.from(map['stores'] as Map)),
    );
  }
}

// ── Screen ────────────────────────────────────────────────────────────────────

class GlobalSearchScreen extends StatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  State<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends State<GlobalSearchScreen> {
  final _supabase = Supabase.instance.client;
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Timer? _debounce;

  String _query = '';
  List<Store> _storeResults = [];
  List<_ProductResult> _productResults = [];
  bool _isLoading = false;
  List<String> _recentSearches = [];

  static const _kPrefsKey = 'global_recent_searches';

  @override
  void initState() {
    super.initState();
    _loadRecent();
    _controller.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Query handling ──────────────────────────────────────────────────────────

  void _onChanged() {
    final q = _controller.text.trim();
    if (q == _query) return;
    setState(() => _query = q);

    _debounce?.cancel();
    if (q.isEmpty) {
      setState(() {
        _storeResults = [];
        _productResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() => _isLoading = true);
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(q));
  }

  Future<void> _search(String q) async {
    await Future.wait([_searchStores(q), _searchProducts(q)]);
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (q.isNotEmpty && q == _controller.text.trim()) {
      _saveRecent(q);
    }
  }

  Future<void> _searchStores(String q) async {
    try {
      final data = await _supabase
          .from('stores')
          .select()
          .or('name.ilike.%$q%,name_ar.ilike.%$q%')
          .limit(10);
      if (!mounted) return;
      setState(
        () => _storeResults = (data as List)
            .map((e) => Store.fromMap(e))
            .toList(),
      );
    } catch (_) {}
  }

  Future<void> _searchProducts(String q) async {
    try {
      final data = await _supabase
          .from('products')
          .select(
            'id, name, price, image_url, '
            'stores:store_id(id, name, name_ar, logo_url, banner_url, '
            'is_open, latitude, longitude, category, vendor_id, store_area, tags)',
          )
          .ilike('name', '%$q%')
          .limit(10);
      if (!mounted) return;
      setState(
        () => _productResults = (data as List)
            .map((e) => _ProductResult.fromMap(e))
            .toList(),
      );
    } catch (_) {}
  }

  // ── Recent searches ─────────────────────────────────────────────────────────

  Future<void> _loadRecent() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => _recentSearches = prefs.getStringList(_kPrefsKey) ?? []);
  }

  Future<void> _saveRecent(String q) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kPrefsKey) ?? [];
    list.remove(q);
    list.insert(0, q);
    if (list.length > 8) list.removeLast();
    await prefs.setStringList(_kPrefsKey, list);
    if (mounted) setState(() => _recentSearches = list);
  }

  Future<void> _removeRecent(String q) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kPrefsKey) ?? [];
    list.remove(q);
    await prefs.setStringList(_kPrefsKey, list);
    setState(() => _recentSearches = list);
  }

  Future<void> _clearAllRecent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPrefsKey);
    setState(() => _recentSearches = []);
  }

  void _applyRecent(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: q.length),
    );
  }

  void _navigateToStore(Store store) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CustomerStoreScreen(store: store)),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final bool hasQuery = _query.isNotEmpty;
    final bool hasResults =
        _storeResults.isNotEmpty || _productResults.isNotEmpty;
    final bool noResults = hasQuery && !_isLoading && !hasResults;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────────
          _SearchBar(
            controller: _controller,
            focusNode: _focusNode,
            isLoading: _isLoading,
            onBack: () => Navigator.pop(context),
            onClear: () {
              _controller.clear();
              _focusNode.requestFocus();
            },
            l10: l10,
          ),

          // ── Body ────────────────────────────────────────────────────────────
          Expanded(
            child: hasQuery
                ? _isLoading && !hasResults
                      // Full-page shimmer only on first load
                      ? _LoadingShimmer()
                      : noResults
                      ? _NoResults(query: _query, l10: l10)
                      : _ResultsView(
                          storeResults: _storeResults,
                          productResults: _productResults,
                          onStoreTap: _navigateToStore,
                          l10: l10,
                        )
                : _RecentView(
                    searches: _recentSearches,
                    onTap: _applyRecent,
                    onRemove: _removeRecent,
                    onClearAll: _clearAllRecent,
                    l10: l10,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Search bar widget ─────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isLoading,
    required this.onBack,
    required this.onClear,
    required this.l10,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isLoading;
  final VoidCallback onBack;
  final VoidCallback onClear;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 16, 10),
            child: Row(
              children: [
                // Back
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: onBack,
                  color: colors.onSurface,
                ),
                // Field
                Expanded(
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: 15, color: colors.onSurface),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: l10.search,
                      hintStyle: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colors.onSurfaceVariant,
                        size: 22,
                      ),
                      suffixIcon: controller.text.isNotEmpty
                          ? GestureDetector(
                              onTap: onClear,
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Thin loading bar
          SizedBox(
            height: 2,
            child: isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    color: colors.primary,
                  )
                : const SizedBox.shrink(),
          ),
          Divider(height: 1, thickness: 1, color: colors.outline),
        ],
      ),
    );
  }
}

// ── Recent searches ───────────────────────────────────────────────────────────

class _RecentView extends StatelessWidget {
  const _RecentView({
    required this.searches,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
    required this.l10,
  });

  final List<String> searches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;
  final AppLocalizations l10;

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
              'Search stores and items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Find restaurants, dishes, and more',
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

// ── Results view ──────────────────────────────────────────────────────────────

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.storeResults,
    required this.productResults,
    required this.onStoreTap,
    required this.l10,
  });

  final List<Store> storeResults;
  final List<_ProductResult> productResults;
  final ValueChanged<Store> onStoreTap;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        // ── Stores section ──────────────────────────────────────────────────
        if (storeResults.isNotEmpty) ...[
          _SectionHeader(title: 'Stores'),
          ...storeResults.map(
            (store) => _StoreRow(
              store: store,
              onTap: () => onStoreTap(store),
              l10: l10,
            ),
          ),
        ],

        // ── Products section ────────────────────────────────────────────────
        if (productResults.isNotEmpty) ...[
          if (storeResults.isNotEmpty) _SectionHeader(title: 'Items'),
          ...productResults.map(
            (p) => _ProductRow(
              product: p,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerStoreScreen(store: p.store),
                ),
              ),
              l10: l10,
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: colors.onSurfaceVariant,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Store row ─────────────────────────────────────────────────────────────────

class _StoreRow extends StatelessWidget {
  const _StoreRow({
    required this.store,
    required this.onTap,
    required this.l10,
  });
  final Store store;
  final VoidCallback onTap;
  final AppLocalizations l10;

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

// ── Product row ───────────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.onTap,
    required this.l10,
  });
  final _ProductResult product;
  final VoidCallback onTap;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    final storeName = locale == 'ar' && product.store.name_ar.isNotEmpty
        ? product.store.name_ar
        : product.store.name;
    final hasImage = (product.imageUrl ?? '').isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: hasImage
                  ? Image.network(
                      product.imageUrl!,
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _ItemPlaceholder(colors: colors),
                    )
                  : _ItemPlaceholder(colors: colors),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    storeName,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Price
            Text(
              '${l10.jod} ${product.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemPlaceholder extends StatelessWidget {
  const _ItemPlaceholder({required this.colors});
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
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.fastfood_outlined,
        size: 22,
        color: colors.onSurfaceVariant,
      ),
    );
  }
}

// ── No results ────────────────────────────────────────────────────────────────

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query, required this.l10});
  final String query;
  final AppLocalizations l10;

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
            'Try different keywords or check your spelling',
            style: TextStyle(fontSize: 13, color: colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Loading shimmer ───────────────────────────────────────────────────────────

class _LoadingShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 13,
                    width: 140,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 11,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.07)
                          : Colors.black.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
