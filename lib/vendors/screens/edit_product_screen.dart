import 'dart:io';

import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late String productName;
  late String productDescription;
  late String dinars;
  late String cents;

  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  @override
  void initState() {
    super.initState();

    productName = widget.name;
    productDescription = widget.description;

    final priceParts = widget.price.toStringAsFixed(2).split('.');
    dinars = priceParts[0];
    cents = priceParts[1];
  }

  @override
  void dispose() {
    imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
     appBar: CustomAppBar(
  title: productName,
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'delete') {
          final confirmed = await showCustomDialog(
            context,
            title: 'Delete Product',
            content: 'This will delete the product. Are you sure?',
            confirmText: 'Delete',
            cancelText: 'Cancel',
            onConfirmAsync: () async {
              await context
                  .read<LoggedVendorProvider>()
                  .deleteProduct(widget.productId);
            },
          );

          if (confirmed == true && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Delete Product',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    ),
  ],
),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
           
              Row(
                children: [
                        Icon(Icons.check_circle,
                      color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Text(
                   'Available',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

                 Text(
                    'Customers can view and order this product during store hours',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
              OutlinedBtn(
                onPressed: () {},
                 title: 'Mark as Unavailable Today',
               
              ),
               Divider(thickness:4,color: colors.surfaceContainer,),

              ValueListenableBuilder<File?>(
                valueListenable: imageNotifier,
                builder: (context, image, _) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: LabeledTextField(
                          label: 'Name',
                          value: productName,
                          onChanged: (val) {
                            setState(() {
                              productName = val.trim();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () async {
                          final picked = await ImagePicker()
                              .pickImage(
                                  source: ImageSource.gallery);
                          if (picked != null) {
                            imageNotifier.value =
                                File(picked.path);
                          }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: image == null
                              ? Image.network(
                                  widget.imageUrl,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  image,
                                  width: 72,
                                  height: 72,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
                  );
                },
              ),

          

              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: LabeledTextField(
                      label: 'Dinars',
                      value: dinars,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => dinars = val.trim(),
                    ),
                  ),
         
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      '.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
               
                  Expanded(
                    child: LabeledTextField(
                      label: 'Cents',
                      value: cents,
                      keyboardType: TextInputType.number,
                      onChanged: (val) => cents = val.trim(),
                    ),
                  ),
                ],
              ),

              LabeledTextField(
                label: 'Description',
                value: productDescription,
                maxLines: 4,
                onChanged: (val) =>
                    productDescription = val.trim(),
              ),

         Column(
  spacing: 0,
  children: [
    FilledBtn(
      title: 'Save Changes',
      isLoading: provider.isLoading,
      onPressed: provider.isLoading
          ? () {}
          : () async {
              final price = double.parse(
                '${dinars.isEmpty ? '0' : dinars}.${cents.isEmpty ? '00' : cents.padRight(2, '0')}',
              );

              await provider.updateProductData(
                productId: widget.productId,
                name: productName,
                description: productDescription,
                price: price,
                imageFile: imageNotifier.value,
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
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
