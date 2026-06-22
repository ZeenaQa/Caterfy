import 'package:caterfy/customers/customer_widgets/product_drawer_content.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_cart.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/order_item.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// ── Category metadata ────────────────────────────────────────────────────────

const Map<String, String> _catEmoji = {
  'Fresh Produce': '🥦',
  'Dairy & Eggs': '🥛',
  'Beverages': '🥤',
  'Snacks': '🍫',
  'Bakery': '🍞',
  'Household': '🧴',
  'Meat & Poultry': '🥩',
  'Frozen': '🧊',
  'Personal Care': '🛁',
  'Baby & Kids': '🧸',
};

const Map<String, Color> _catColor = {
  'Fresh Produce': Color(0xFFE8F5E9),
  'Dairy & Eggs': Color(0xFFE3F2FD),
  'Beverages': Color(0xFFFFF3E0),
  'Snacks': Color(0xFFFFF8E1),
  'Bakery': Color(0xFFF3E5F5),
  'Household': Color(0xFFE0F2F1),
  'Meat & Poultry': Color(0xFFFCE4EC),
  'Frozen': Color(0xFFE8EAF6),
  'Personal Care': Color(0xFFEDE7F6),
  'Baby & Kids': Color(0xFFF9FBE7),
};

const Map<String, IconData> _catIcon = {
  'Fresh Produce': Icons.eco_outlined,
  'Dairy & Eggs': Icons.egg_alt_outlined,
  'Beverages': Icons.local_drink_outlined,
  'Snacks': Icons.cookie_outlined,
  'Bakery': Icons.bakery_dining_outlined,
  'Household': Icons.cleaning_services_outlined,
  'Meat & Poultry': Icons.set_meal_outlined,
  'Frozen': Icons.ac_unit_outlined,
  'Personal Care': Icons.face_outlined,
  'Baby & Kids': Icons.child_care_outlined,
};

// ── Screen ───────────────────────────────────────────────────────────────────

class CeemartScreen extends StatefulWidget {
  const CeemartScreen({super.key});

  @override
  State<CeemartScreen> createState() => _CeemartScreenState();
}

class _CeemartScreenState extends State<CeemartScreen> {
  Store? _store;
  bool _loadDone = false;
  String _selectedCategory = 'all';
  bool _showSearch = false;
  final TextEditingController _searchCtrl = TextEditingController();
  final ScrollController _gridScroll = ScrollController();
  final ScrollController _chipScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final store = await Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      ).fetchCeemartProducts(context);
      if (mounted) setState(() { _store = store; _loadDone = true; });
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _gridScroll.dispose();
    _chipScroll.dispose();
    super.dispose();
  }

  void _pickCategory(String cat) {
    setState(() => _selectedCategory = cat);
    _gridScroll.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final isLoading = provider.isProductsLoading;

    final query = _searchCtrl.text.toLowerCase();
    final all = provider.products;
    final searched = query.isEmpty
        ? all
        : all
            .where((p) =>
                p.name.toLowerCase().contains(query) ||
                p.description.toLowerCase().contains(query))
            .toList();

    final catLabels = <String, String>{
      'all': l10.ceemartAll,
      for (final p in searched)
        if (p.subCategoryEn.isNotEmpty) p.subCategoryEn: p.subCategory,
    };
    final cats = catLabels.keys.toList();
    final effCat = cats.contains(_selectedCategory) ? _selectedCategory : 'all';
    final filtered = effCat == 'all'
        ? searched
        : searched.where((p) => p.subCategoryEn == effCat).toList();

    final showCart = _store != null && provider.cart?.storeId == _store!.id;

    return Scaffold(
      backgroundColor: colors.surfaceContainer,
      body: Column(
        children: [
          // ── Header ──────────────────────────────────────────────────────
          _Header(
            showSearch: _showSearch,
            searchCtrl: _searchCtrl,
            onSearchToggle: () => setState(() {
              _showSearch = !_showSearch;
              if (!_showSearch) { _searchCtrl.clear(); setState(() {}); }
            }),
            onSearchChanged: (_) => setState(() {}),
            colors: colors,
            l10: l10,
            store: _store,
          ),

          // ── Category chips ───────────────────────────────────────────────
          if (!isLoading && cats.length > 2)
            _ChipsBar(
              categories: cats,
              catLabels: catLabels,
              selected: effCat,
              onTap: _pickCategory,
              chipScroll: _chipScroll,
              colors: colors,
              l10: l10,
            ),

          // ── Content ──────────────────────────────────────────────────────
          Expanded(
            child: isLoading
                ? _SkeletonGrid(colors: colors)
                : !_loadDone || (_store == null && !isLoading)
                ? _StoreNotFound(colors: colors, l10: l10)
                : filtered.isEmpty
                ? _NoResults(colors: colors, l10: l10)
                : GridView.builder(
                    controller: _gridScroll,
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _ProductCard(
                      product: filtered[i],
                      store: _store!,
                    ),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: showCart
          ? _CartBar(store: _store!, provider: provider, l10: l10, colors: colors)
          : null,
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.showSearch,
    required this.searchCtrl,
    required this.onSearchToggle,
    required this.onSearchChanged,
    required this.colors,
    required this.l10,
    required this.store,
  });

  final bool showSearch;
  final TextEditingController searchCtrl;
  final VoidCallback onSearchToggle;
  final ValueChanged<String> onSearchChanged;
  final ColorScheme colors;
  final AppLocalizations l10;
  final Store? store;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colors.primary,
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
              child: Row(
                children: [
                  _HeaderBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                    colors: colors,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: showSearch
                        ? Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextField(
                              controller: searchCtrl,
                              autofocus: true,
                              onChanged: onSearchChanged,
                              style: TextStyle(
                                color: colors.onPrimary,
                                fontSize: 14,
                              ),
                              cursorColor: colors.onPrimary,
                              decoration: InputDecoration(
                                hintText: l10.ceemartSearch,
                                hintStyle: TextStyle(
                                  color: colors.onPrimary.withValues(alpha: 0.6),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 11,
                                ),
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  color: colors.onPrimary.withValues(alpha: 0.7),
                                  size: 18,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Ceemart',
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              Text(
                                l10.ceemartDeliveryNote,
                                style: TextStyle(
                                  color: colors.onPrimary.withValues(alpha: 0.75),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(width: 8),
                  _HeaderBtn(
                    icon: showSearch
                        ? Icons.close_rounded
                        : Icons.search_rounded,
                    onTap: onSearchToggle,
                    colors: colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _HeaderBtn extends StatelessWidget {
  const _HeaderBtn({
    required this.icon,
    required this.onTap,
    required this.colors,
  });
  final IconData icon;
  final VoidCallback onTap;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: colors.onPrimary, size: 18),
      ),
    );
  }
}

// ── Category chips bar ────────────────────────────────────────────────────────

class _ChipsBar extends StatelessWidget {
  const _ChipsBar({
    required this.categories,
    required this.catLabels,
    required this.selected,
    required this.onTap,
    required this.chipScroll,
    required this.colors,
    required this.l10,
  });

  final List<String> categories;
  final Map<String, String> catLabels;
  final String selected;
  final ValueChanged<String> onTap;
  final ScrollController chipScroll;
  final ColorScheme colors;
  final AppLocalizations l10;

  String _label(String cat) => catLabels[cat] ?? cat;
  String _emoji(String cat) => cat == 'all' ? '🛒' : (_catEmoji[cat] ?? '📦');

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colors.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              controller: chipScroll,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = categories[i];
                final sel = cat == selected;
                return GestureDetector(
                  onTap: () => onTap(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? colors.primary : colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: sel ? colors.primary : colors.outline,
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_emoji(cat), style: const TextStyle(fontSize: 13)),
                        const SizedBox(width: 5),
                        Text(
                          _label(cat),
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: sel ? colors.onPrimary : colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1, thickness: 1, color: colors.outline),
        ],
      ),
    );
  }
}

// ── Product card ──────────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.store});

  final Product product;
  final Store store;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LoggedCustomerProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    final cartItems = provider.cart?.items ?? const [];
    final qty = cartItems
        .where((i) => i.productId == product.id)
        .fold<int>(0, (s, i) => s + i.quantity);

    final placeholderColor =
        _catColor[product.subCategoryEn] ?? const Color(0xFFF5F5F5);
    final placeholderIcon =
        _catIcon[product.subCategoryEn] ?? Icons.shopping_bag_outlined;

    final isOpen = store.isOpen;

    final cartItem = cartItems.where((i) => i.productId == product.id).firstOrNull;

    return GestureDetector(
      onTap: () => openDrawer(
        context,
        padding: const EdgeInsets.only(bottom: 0),
        isStack: true,
        child: ProductDrawerContent(
          product: product,
          isInCart: cartItem != null,
          orderItem: cartItem,
          isStoreOpen: isOpen,
        ),
      ),
      child: Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: qty > 0
              ? colors.primary.withValues(alpha: 0.35)
              : colors.outline,
          width: qty > 0 ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ─────────────────────────────────────────────────────
          Expanded(
            flex: 10,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: placeholderColor),
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  Image.network(
                    product.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _Placeholder(
                      color: placeholderColor,
                      icon: placeholderIcon,
                    ),
                  )
                else
                  _Placeholder(color: placeholderColor, icon: placeholderIcon),
                if (!isOpen)
                  Container(
                    color: Colors.black.withValues(alpha: 0.4),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          l10.closed,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Info ──────────────────────────────────────────────────────
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: colors.onSurfaceVariant,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const Spacer(),
                  // ── Price row ─────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10.jod,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurfaceVariant,
                                letterSpacing: 0.4,
                              ),
                            ),
                            Text(
                              product.price.toStringAsFixed(3),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: colors.onSurface,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ── Add / qty control ──────────────────────────
                      if (isOpen)
                        qty == 0
                            ? _AddBtn(
                                onTap: () =>
                                    _addOne(context, provider),
                                colors: colors,
                              )
                            : _QtyControl(
                                qty: qty,
                                onMinus: () =>
                                    _removeOne(context, provider),
                                onPlus: () =>
                                    _addOne(context, provider),
                                colors: colors,
                              ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ), // GestureDetector
    );
  }

  void _addOne(BuildContext context, LoggedCustomerProvider provider) {
    provider.addToCart(
      item: OrderItem(
        id: const Uuid().v4(),
        productId: product.id,
        storeId: store.id,
        name: product.name,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
        quantity: 1,
      ),
    );
  }

  void _removeOne(BuildContext context, LoggedCustomerProvider provider) {
    final items = provider.cart?.items ?? const [];
    final match = items.lastWhere(
      (i) => i.productId == product.id,
      orElse: () =>
          OrderItem(id: '', productId: '', storeId: '', name: '', price: 0),
    );
    if (match.id.isEmpty) return;
    if (match.quantity <= 1) {
      provider.deleteItemFromCart(orderItemId: match.id);
    } else {
      provider.setItemQuantity(item: match, newQuantity: match.quantity - 1);
    }
  }
}

// ── Add button ────────────────────────────────────────────────────────────────

class _AddBtn extends StatelessWidget {
  const _AddBtn({required this.onTap, required this.colors});
  final VoidCallback onTap;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(Icons.add_rounded, color: colors.onPrimary, size: 20),
      ),
    );
  }
}

// ── Qty control ───────────────────────────────────────────────────────────────

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
    required this.colors,
  });
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onMinus,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colors.outline, width: 1.2),
              color: colors.surface,
            ),
            child: Icon(Icons.remove_rounded, size: 14, color: colors.onSurface),
          ),
        ),
        SizedBox(
          width: 26,
          child: Text(
            '$qty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
        ),
        GestureDetector(
          onTap: onPlus,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_rounded, size: 14, color: colors.onPrimary),
          ),
        ),
      ],
    );
  }
}

// ── Image placeholder ─────────────────────────────────────────────────────────

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color, required this.icon});
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Icon(icon, size: 42, color: Colors.black.withValues(alpha: 0.18)),
      ),
    );
  }
}

// ── Skeleton grid ─────────────────────────────────────────────────────────────

class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid({required this.colors});
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => _SkeletonCard(colors: colors),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.colors});
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.outline),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              decoration: BoxDecoration(
                color: colors.onPrimaryFixedVariant,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bone(width: double.infinity, height: 12),
                  const SizedBox(height: 5),
                  _Bone(width: 80, height: 10),
                  const Spacer(),
                  Row(
                    children: [
                      _Bone(width: 55, height: 20),
                      const Spacer(),
                      _Bone(width: 34, height: 34, radius: 17),
                    ],
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

class _Bone extends StatelessWidget {
  const _Bone({required this.width, required this.height, this.radius = 4});
  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: colors.onPrimaryFixedVariant,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Empty / error states ──────────────────────────────────────────────────────

class _StoreNotFound extends StatelessWidget {
  const _StoreNotFound({required this.colors, required this.l10});
  final ColorScheme colors;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.storefront_outlined,
                size: 64, color: colors.onSurfaceVariant.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(
              'Ceemart is coming soon!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'re stocking up. Check back shortly.',
              style: TextStyle(fontSize: 13.5, color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.colors, required this.l10});
  final ColorScheme colors;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 56, color: colors.onSurfaceVariant.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          Text(
            l10.noProductsYet,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ── Cart bar ──────────────────────────────────────────────────────────────────

class _CartBar extends StatelessWidget {
  const _CartBar({
    required this.store,
    required this.provider,
    required this.l10,
    required this.colors,
  });

  final Store store;
  final LoggedCustomerProvider provider;
  final AppLocalizations l10;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: FilledBtn(
          onPressed: !store.isOpen
              ? null
              : () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CustomerCart()),
                  ),
          innerVerticalPadding: 10,
          innerHorizontalPadding: 12,
          content: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Center(
                  child: Text(
                    '${provider.totalCartQuantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                l10.viewCart,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                '${l10.jod} ${provider.totalCartPrice.toStringAsFixed(3)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
