import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomerStoreDetailsScreen extends StatelessWidget {
  const CustomerStoreDetailsScreen({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final storeNameToShow = Localizations.localeOf(context).languageCode == 'ar' && (store.name_ar.isNotEmpty) ? store.name_ar : store.name;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.storeDetails),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 12,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          store.logoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.store,
                              size: 30,
                              color: Colors.grey[400],
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            storeNameToShow,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (store.tags != null && store.tags!.isNotEmpty)
                            Text(
                              store.tags!.join(', '),
                              maxLines: 2,
                              style: TextStyle(
                                color: colors.onSurfaceVariant,
                                fontSize: 13.5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    InfoItem(
                      leftContent: Row(
                        spacing: 5,
                        children: [
                          Icon(
                            FontAwesomeIcons.solidStar,
                            color: colors.secondaryContainer,
                            size: 15,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            color: colors.secondaryContainer,
                            size: 15,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            color: colors.secondaryContainer,
                            size: 15,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            color: colors.secondaryContainer,
                            size: 15,
                          ),
                          Icon(
                            FontAwesomeIcons.solidStar,
                            color: colors.secondaryContainer,
                            size: 15,
                          ),
                        ],
                      ),
                      leftText: "5",
                      rightText: "1k+",
                    ),
                    InfoItem(
                      leftContent: SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(
                          FontAwesomeIcons.mapPin,
                          size: 20,
                          color: colors.onSecondary,
                        ),
                      ),
                      leftText: l10n.storeArea,
                      rightText: store.storeArea!,
                    ),
                    InfoItem(
                      leftContent: SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(
                          Icons.delivery_dining_rounded,
                          size: 23,
                          color: colors.onSecondary,
                        ),
                      ),
                      leftText: l10n.deliveryTime,
                      rightText: "25-30 mins",
                    ),
                    InfoItem(
                      leftContent: SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(
                          Icons.receipt_outlined,
                          size: 23,
                          color: colors.onSecondary,
                        ),
                      ),
                      leftText: l10n.deliveryFee,
                      rightText: '1.00 ${l10n.jod}',
                    ),
                    InfoItem(
                      leftContent: SizedBox(
                        width: 23,
                        height: 23,
                        child: Icon(
                          Icons.store_outlined,
                          size: 23,
                          color: colors.onSecondary,
                        ),
                      ),
                      leftText: l10n.legalName,
                      rightText: storeNameToShow,
                      isLastItem: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  const InfoItem({
    super.key,
    this.isLastItem = false,
    required this.leftContent,
    this.leftText = '',
    this.rightContent,
    this.rightText = '',
  });

  final bool isLastItem;
  final Widget leftContent;
  final String leftText;
  final Widget? rightContent;
  final String rightText;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 15),
      decoration: BoxDecoration(
        border: isLastItem
            ? null
            : Border(bottom: BorderSide(color: colors.outline)),
      ),
      child: Row(
        children: [
          leftContent,
          SizedBox(width: 13),
          Text(
            leftText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: colors.onSecondary,
            ),
          ),
          Spacer(),
          if (rightContent != null) rightContent!,
          if (rightText.isNotEmpty)
            Text(
              rightText,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: colors.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}
