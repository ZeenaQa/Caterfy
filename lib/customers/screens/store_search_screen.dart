import 'package:caterfy/customers/customer_widgets/product_drawer_content.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:flutter/material.dart';

class StoreSearchScreen extends StatefulWidget {
  const StoreSearchScreen({
    super.key,
    required this.products,
    required this.store,
  });

  final List<Product> products;
  final Store store;

  @override
  State<StoreSearchScreen> createState() => _StoreSearchScreenState();
}

class _StoreSearchScreenState extends State<StoreSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final q = _controller.text.trim().toLowerCase();
      if (q != _query) setState(() => _query = q);
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Product> get _results {
    if (_query.isEmpty) return widget.products;
    return widget.products.where((p) {
      return p.name.toLowerCase().contains(_query) ||
          p.description.toLowerCase().contains(_query) ||
          p.subCategory.toLowerCase().contains(_query);
    }).toList();
  }

  void _openProduct(Product product) {
    openDrawer(
      context,
      padding: EdgeInsets.zero,
      isStack: true,
      child: ProductDrawerContent(
        product: product,
        isStoreOpen: widget.store.isOpen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final storeName = isArabic && widget.store.name_ar.isNotEmpty
        ? widget.store.name_ar
        : widget.store.name;

    final results = _results;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Search bar ──────────────────────────────────────────────────
            Row(
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
                    style: TextStyle(fontSize: 15.5, color: colors.onSurface),
                    decoration: InputDecoration(
                      filled: false,
                      hintText: 'Search in $storeName',
                      hintStyle: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 15.5,
                      ),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: colors.onSurfaceVariant,
                                size: 20,
                              ),
                              onPressed: () {
                                _controller.clear();
                                _focusNode.requestFocus();
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      isDense: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
            Divider(height: 1, thickness: 1, color: colors.outline),

            // ── Results ─────────────────────────────────────────────────────
            Expanded(
              child: results.isEmpty
                  ? _NoResults(query: _query)
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        return _ProductRow(
                          product: results[i],
                          isLast: i == results.length - 1,
                          isStoreOpen: widget.store.isOpen,
                          onTap: () => _openProduct(results[i]),
                          l10: l10,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Product row (Talabat style) ───────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.product,
    required this.isLast,
    required this.isStoreOpen,
    required this.onTap,
    required this.l10,
  });

  final Product product;
  final bool isLast;
  final bool isStoreOpen;
  final VoidCallback onTap;
  final AppLocalizations l10;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final hasImage = (product.imageUrl ?? '').isNotEmpty;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color: colors.outline,
                    width: 1,
                  ),
                ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ── Image LEFT ──────────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: hasImage
                  ? Image.network(
                      product.imageUrl!,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          _ImagePlaceholder(size: 75),
                    )
                  : _ImagePlaceholder(size: 75),
            ),

            const SizedBox(width: 14),

            // ── Text ────────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: colors.onSurfaceVariant,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    '${product.price.toStringAsFixed(2)} ${l10.jod}',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // ── Add button ──────────────────────────────────────────────────
            if (isStoreOpen)
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    color: colors.onPrimary,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFFF1F1F1),
      child: Icon(Icons.fastfood_outlined, size: size * 0.4, color: Colors.grey[400]),
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
          Icon(Icons.search_off_rounded, size: 58, color: colors.outline),
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
          ),
        ],
      ),
    );
  }
}
