import 'package:caterfy/customers/customer_widgets/add_note.dart';
import 'package:caterfy/customers/customer_widgets/cart_item.dart';
import 'package:caterfy/customers/providers/logged_customer_provider.dart';
import 'package:caterfy/customers/screens/customer_store_screen.dart';
import 'package:caterfy/dummy_data.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/models/store.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_drawer.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomerCart extends StatefulWidget {
  const CustomerCart({super.key});

  @override
  State<CustomerCart> createState() => _CustomerCartState();
}

class _CustomerCartState extends State<CustomerCart> {
  Store? store;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final customerProvider = Provider.of<LoggedCustomerProvider>(
        context,
        listen: false,
      );
      final String? cartStoreId = customerProvider.cart?.storeId;

      if (cartStoreId == null) return;

      await customerProvider.fetchCartContent(
        storeId: cartStoreId,
        context: context,
      );
      store = customerProvider.getStoreById(cartStoreId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final items = customerProvider.cart?.items ?? const [];
    final bool isLoading = customerProvider.isCartLoading;
    final bool isCartEmpty = customerProvider.cart?.items.isEmpty ?? true;
    final storeNameToShow = store == null
        ? ''
        : (Localizations.localeOf(context).languageCode == 'ar' &&
                  store!.name_ar.isNotEmpty
              ? store!.name_ar
              : store!.name);

    return Scaffold(
      bottomNavigationBar: isLoading || isCartEmpty
          ? null
          : BottomNav(store: store),
      appBar: CustomAppBar(
        content: isCartEmpty
            ? null
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10.cart,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    storeNameToShow,
                    style: TextStyle(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
      body: isCartEmpty
          ? Center(
              child: Column(
                spacing: 20,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_rounded,
                    size: 120,
                    color: colors.outline,
                  ),
                  Text(
                    l10.emptyCartMessage,
                    style: TextStyle(
                      color: colors.onSurfaceVariant,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          : Skeletonizer(
              enabled: isLoading,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: isLoading ? 2 : items.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return CartItem(
                          orderItem: isLoading
                              ? dummyOrderItems[index]
                              : items[index],
                          isLastItem:
                              index == (isLoading ? 1 : items.length - 1),
                          isStoreOpen: store?.isOpen ?? true,
                        );
                      },
                    ),
                    CartSection(
                      sectionTitle: l10.specialRequest,
                      content: [SpecialRequest()],
                    ),
                    CartSection(
                      sectionTitle: l10.saveOnOrder,
                      content: [SaveOnOrder(), SizedBox(height: 14)],
                    ),
                    CartSection(
                      sectionTitle: l10.paymentSummary,
                      content: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                            left: 15,
                            right: 15,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 11,
                            children: [
                              PaymentRow(
                                title: l10.subtotal,
                                price: customerProvider.totalCartPrice
                                    .toString(),
                              ),
                              PaymentRow(title: l10.deliveryFee, price: '1.00'),
                              PaymentRow(title: l10.serviceFee, price: '0.20'),
                              Row(
                                children: [
                                  Text(
                                    l10.totalAmount,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${l10.jod} ${(customerProvider.totalCartPrice + 1.00 + 0.20).toString()}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, required this.store});

  final Store? store;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final l10 = AppLocalizations.of(context);
    final bool isStoreOpen = store?.isOpen ?? true;

    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.only(
          bottom: 18,
          // top: 25,
          left: 14,
          right: 14,
        ),
        decoration: BoxDecoration(
          color: colors.onInverseSurface,
          boxShadow: [
            BoxShadow(
              color: colors.shadow,
              blurRadius: 6,
              offset: const Offset(0, 3.5),
            ),
          ],
          // border: Border(top: BorderSide(color: colors.outline)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (!isStoreOpen) ...[
                SizedBox(height: 12),
                Text(l10.checkoutStoreClosed, style: TextStyle(fontSize: 13)),
              ],
              SizedBox(height: !isStoreOpen ? 13 : 25),
              Row(
                spacing: 18,
                children: [
                  Expanded(
                    child: OutlinedBtn(
                      onPressed: () {
                        if (store == null) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomerStoreScreen(store: store!),
                          ),
                        );
                      },
                      title: l10.addItems,
                      titleSize: 15,
                      innerVerticalPadding: 15,
                    ),
                  ),
                  Expanded(
                    child: FilledBtn(
                      loadingSize: 15,
                      isLoading: customerProvider.isPlaceOrderLoading,
                      onPressed: !isStoreOpen
                          ? null
                          : () async {
                              await customerProvider.placeOrder(
                                context: context,
                              );
                              if (context.mounted) Navigator.of(context).pop();
                            },
                      title: l10.checkout,
                      titleSize: 15,
                      innerVerticalPadding: 15,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentRow extends StatelessWidget {
  const PaymentRow({super.key, required this.title, required this.price});

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    // final colors = Theme.of(context).colorScheme;
    return Row(children: [Text(title), Spacer(), Text('${l10.jod} $price')]);
  }
}

class SpecialRequest extends StatelessWidget {
  const SpecialRequest({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final customerProvider = Provider.of<LoggedCustomerProvider>(context);
    final customerNote = customerProvider.cart?.note;
    final l10 = AppLocalizations.of(context);

    return TextButton(
      onPressed: () {
        openDrawer(
          context,
          showCloseBtn: false,
          child: AddNote(
            initialNote: customerProvider.cart?.note ?? "",
            onCloseNote: (note) => {
              customerProvider.setOrderNote(newNote: note),
            },
          ),
          borderRadius: 0,
          accountForKeyboard: true,
          padding: EdgeInsets.symmetric(horizontal: 15),
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: colors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Row(
          children: [
            Icon(FontAwesomeIcons.message, color: colors.onSurface, size: 18),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10.anySpecialRequests,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                    ),
                  ),
                  Text(
                    (customerNote == null || customerNote.isEmpty)
                        ? l10.specialRequestHint
                        : customerNote,
                    style: TextStyle(fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

class SaveOnOrder extends StatelessWidget {
  const SaveOnOrder({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: colors.outline, width: 1),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: l10.enterCouponCode,
              hintStyle: TextStyle(
                color: colors.outlineVariant,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RotatedBox(
                  quarterTurns: 45,
                  child: Icon(
                    FontAwesomeIcons.ticket,
                    color: colors.outlineVariant,
                    size: 18,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 0,
                maxWidth: 70,
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    l10.submit,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: colors.secondary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
              border: border,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
        ],
      ),
    );
  }
}

class CartSection extends StatelessWidget {
  const CartSection({
    super.key,
    required this.sectionTitle,
    this.content = const [],
  });

  final String sectionTitle;
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            sectionTitle,
            style: TextStyle(
              color: colors.onSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6),
        ...content,
        if (content.isNotEmpty) SizedBox(height: 20),
      ],
    );
  }
}
