import 'dart:io';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddProductScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const AddProductScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String productName = '';
  String productDescription = '';
  String productDinars = '';
  String productCents = '';
  bool showErrors = false;
  String? nameError;
  String? descriptionError;
  String? priceError;
  String? imageError;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  @override
  void dispose() {
    imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final l10 = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: l10.addProduct),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LabeledTextField(
                label: l10.productName,
                hint: l10.productNameHint,
                errorText: nameError,
                onChanged: (val) {
                  productName = val.trim();
                  if (nameError != null) {
                    setState(() => nameError = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              LabeledTextField(
                label: l10.description,
                hint: l10.description,
                maxLines: 4,
                errorText: descriptionError,
                onChanged: (val) {
                  productDescription = val.trim();
                  if (descriptionError != null) {
                    setState(() => descriptionError = null);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: LabeledTextField(
                      label: l10.dinars,
                      hint: '0',
                      errorText: priceError,
                      onChanged: (val) {
                        productDinars = val.trim();
                        if (priceError != null) {
                          setState(() => priceError = null);
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 14),
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
                      label: l10.cents,
                      hint: '00',
                      keyboardType: TextInputType.number,
                      onChanged: (val) => productCents = val.trim(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ValueListenableBuilder<File?>(
                valueListenable: imageNotifier,
                builder: (context, image, _) {
                  return GestureDetector(
                    onTap: () async {
                      final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked != null) {
                        imageNotifier.value = File(picked.path);
                      }
                    },
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: image == null
                          ? const Icon(Icons.camera_alt, size: 40)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(image, fit: BoxFit.cover),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              FilledBtn(
                title: l10.save,
                isLoading: provider.isLoading,
                onPressed: provider.isLoading
                    ? () {}
                    : () async {
                        setState(() {
                          nameError = productName.isEmpty ? l10.required : null;
                          descriptionError = productDescription.isEmpty
                              ? l10.required
                              : null;
                          priceError =
                              (productDinars.isEmpty && productCents.isEmpty)
                              ? l10.required
                              : null;
                          imageError = imageNotifier.value == null
                              ? l10.required
                              : null;
                        });
                        if (nameError != null ||
                            descriptionError != null ||
                            priceError != null ||
                            imageError != null) {
                          return;
                        }
                        final dinars = productDinars.isEmpty
                            ? '0'
                            : productDinars;
                        final cents = productCents.isEmpty ? '0' : productCents;
                        final price = double.parse(
                          '$dinars.${cents.padRight(2, '0')}',
                        );
                        await provider.addProduct(
                          name: productName,
                          description: productDescription,
                          price: price,
                          imageFile: imageNotifier.value!,
                          subCategoryId: widget.categoryId,
                        );
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
