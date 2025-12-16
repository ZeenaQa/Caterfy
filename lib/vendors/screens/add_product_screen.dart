import 'dart:io';

import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

class AddProductScreen extends StatefulWidget {
  final String subCategoryId;

  const AddProductScreen({
    super.key,
    required this.subCategoryId,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  String name = '';
  String description = '';
  String price = '';

  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  @override
  void dispose() {
    imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// NAME
                      LabeledTextField(
                        label: 'Name',
                        hint: 'Product name',
                        onChanged: (val) {
                          name = val.trim();
                        },
                      ),

                      const SizedBox(height: 16),

                      /// DESCRIPTION
                      LabeledTextField(
                        label: 'Description',
                        hint: 'Product description',
                        onChanged: (val) {
                          description = val.trim();
                        },
                      ),

                      const SizedBox(height: 16),

                      /// PRICE
                      LabeledTextField(
                        label: 'Price',
                        hint: '0.00',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          price = val.trim();
                        },
                      ),

                      const SizedBox(height: 16),

                      /// IMAGE
                      ValueListenableBuilder<File?>(
                        valueListenable: imageNotifier,
                        builder: (context, image, _) {
                          return GestureDetector(
                            onTap: () async {
                              final picked = await ImagePicker()
                                  .pickImage(source: ImageSource.gallery);

                              if (picked != null) {
                                imageNotifier.value = File(picked.path);
                              }
                            },
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: image == null
                                  ? const Icon(
                                      Icons.camera_alt,
                                      size: 40,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      /// SAVE BUTTON
                      FilledBtn(
                        title: 'Save',
                        isLoading: provider.isLoading,
                        onPressed: provider.isLoading
                            ? () {}
                            : () async {
                                if (name.isEmpty ||
                                    description.isEmpty ||
                                    price.isEmpty ||
                                    imageNotifier.value == null) {
                                  return;
                                }

                                await provider.addProduct(
                                  name: name,
                                  description: description,
                                  price: double.parse(price),
                                  imageFile: imageNotifier.value!,
                                  subCategoryId: widget.subCategoryId,
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
      ),
    );
  }
}
