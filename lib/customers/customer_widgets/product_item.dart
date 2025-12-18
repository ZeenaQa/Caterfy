import 'package:caterfy/customers/customer_widgets/product_drawer_content.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/product.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
    required this.product,
    this.isLastItem = false,
  });

  final Product product;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => openDrawer(
        context,
        padding: EdgeInsets.only(bottom: 0),
        isStack: true,
        child: ProductDrawerContent(product: product),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 150,
          padding: EdgeInsets.only(top: 10, bottom: 13),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isLastItem ? Colors.transparent : colors.outline,
              ),
            ),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        product.name,
                        style: TextStyle(
                          color: colors.onPrimaryFixed,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        product.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                          color: colors.secondary,
                          fontSize: 12.5,
                        ),
                      ),
                      Spacer(),
                      RichText(
                        text: TextSpan(
                          text: '${product.price.toString()} ',
                          style: TextStyle(
                            color: colors.onSurface,
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              text: l10.jod,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  width: 130,
                  height: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
