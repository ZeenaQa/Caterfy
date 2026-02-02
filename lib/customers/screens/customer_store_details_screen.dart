import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CustomerStoreDetailsScreen extends StatefulWidget {
  const CustomerStoreDetailsScreen({super.key, required this.store});

  final Store store;

  @override
  State<CustomerStoreDetailsScreen> createState() =>
      _CustomerStoreDetailsScreenState();
}

class _CustomerStoreDetailsScreenState
    extends State<CustomerStoreDetailsScreen> {

  int selectedRating = 0;
  Future<Map<String, dynamic>>? ratingFuture;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
    ratingFuture = context.read<GlobalProvider>().getStoreRatingDetails(widget.store.id);
  }

  Future<void> _loadUserRating() async {
    final globalProvider = context.read<GlobalProvider>();
    final userRating = await globalProvider.getUserRatingForStore(widget.store.id);
    if (userRating != null) {
      setState(() {
        selectedRating = userRating;
      });
    }
  }

 Future<void> submitRating(int rating) async {
  try {
    if (rating == 0) {
      return;
    }

    await context.read<GlobalProvider>().rateStore(
          storeId: widget.store.id,
          rating: rating,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Rating saved")),
    );
    // refresh displayed rating details for this screen
    ratingFuture = context.read<GlobalProvider>().getStoreRatingDetails(widget.store.id);
    setState(() {});

  } catch (e) {
    print('Rating error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to save rating: $e")),
    );
  }
}

  Widget buildRatingStars(ColorScheme colors) {
    return Row(
      spacing: 5,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
             setState(() {
                          selectedRating = index + 1;
                          submitRating(index + 1);
                        });
          },
          child: Icon(
            index < selectedRating
                ? FontAwesomeIcons.solidStar
                : FontAwesomeIcons.star,
            color: colors.secondaryContainer,
            size: 20,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final storeNameToShow =
        Localizations.localeOf(context).languageCode == 'ar' &&
                (widget.store.name_ar.isNotEmpty)
            ? widget.store.name_ar
            : widget.store.name;

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
                          widget.store.logoUrl!,
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
                          if (widget.store.tags != null &&
                              widget.store.tags!.isNotEmpty)
                            Text(
                              widget.store.tags!.join(', '),
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
                    FutureBuilder<Map<String, dynamic>>(
                      future: ratingFuture,
                      builder: (context, snapshot) {
                        double avgRating = 0;
                        int count = 0;
                        
                        if (snapshot.hasData) {
                          avgRating = snapshot.data?['average'] ?? 0;
                          count = snapshot.data?['count'] ?? 0;
                        }
                        
                        return InfoItem(
                          leftContent: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                FontAwesomeIcons.solidStar,
                                size: 16,
                                color: colors.secondaryContainer,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '$avgRating',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.5,
                                  color: colors.onSecondary,
                                ),
                              ),
                            ],
                          ),
                          leftText: "Store Rating",
                          rightText: count > 0 ? '${count} ratings' : 'No ratings yet',
                        );
                      },
                    ),
                    InfoItem(
                      leftContent: buildRatingStars(colors),
                      leftText: selectedRating.toString(),
                      rightText: "",
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
                      rightText: widget.store.storeArea!,
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
                      rightText:
                          "${context.read<GlobalProvider>().getDeliveryTime(widget.store.latitude, widget.store.longitude)} ${l10n.min}",
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
                      rightText:
                          '${context.read<GlobalProvider>().getDeliveryPrice(widget.store.latitude, widget.store.longitude)} ${l10n.jod}',
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
