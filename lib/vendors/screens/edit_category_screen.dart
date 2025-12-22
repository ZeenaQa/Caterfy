import 'dart:io';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

class EditCategoryScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const EditCategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  String categoryName = '';
  bool showAddProductForm = false;
  String productName = '';
  String productDescription = '';
  String productDinars = '';
  String productCents = '';

  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);

  @override
  void initState() {
    super.initState();
    categoryName = widget.categoryName;
  }

  @override
  void dispose() {
    imageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
     appBar: CustomAppBar(
  title: 'Edit Category',
  actions: [
    PopupMenuButton<String>(
      onSelected: (value) async {
        if (value == 'delete') {
          final confirmed = await showCustomDialog(
            context,
            title: 'Delete Category',
            content:
                'This will delete the category and all its products. Are you sure?',
            confirmText: 'Delete',
            cancelText: 'Cancel',
            onConfirmAsync: () async {
              await context
                  .read<LoggedVendorProvider>()
                  .deleteCategory(widget.categoryId);
            },
          );

          if (confirmed == true && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Delete Category',
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
           
            children: [
  

             
              LabeledTextField(
              label: 'Category name',
              value: categoryName,
               onChanged: (val) => categoryName = val.trim(),
              ),

              const SizedBox(height: 24),
             

            ListTile(
  leading: Icon(Icons.add_box_outlined, color: colors.primary),
  title: Text(
   'Add Product',
  ),
  trailing: Icon(
    showAddProductForm
        ? Icons.keyboard_arrow_up
        : Icons.keyboard_arrow_down,
    color: colors.onSurfaceVariant,
  ),
  onTap: () {
    setState(() {
      showAddProductForm = !showAddProductForm;
    });
  },
),

   
              if (showAddProductForm) ...[
                const SizedBox(height: 16),

                LabeledTextField(
                  label: 'Product name',
                  hint: 'Product name',
                  onChanged: (val) => productName = val.trim(),
                ),

                const SizedBox(height: 16),

                LabeledTextField(
                  label: 'Description',
                  hint: 'Product description',
                  maxLines: 4,
                  onChanged: (val) =>
                      productDescription = val.trim(),
                ),

                const SizedBox(height: 16),

             
                Row(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: LabeledTextField(
                        label: 'Dinars',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            productDinars = val.trim(),
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
                        label: 'Cents',
                        hint: '00',
                        keyboardType: TextInputType.number,
                        onChanged: (val) =>
                            productCents = val.trim(),
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
                        final picked = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
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
                                child: Image.file(
                                  image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 32),

              FilledBtn(
                title: 'Save',
                isLoading: provider.isLoading,
                onPressed: provider.isLoading
                    ? () {}
                    : () async {
                    
                        if (categoryName.trim() !=
                            widget.categoryName) {
                          await provider.updateCategory(
                            categoryId: widget.categoryId,
                            newName: categoryName.trim(),
                          );
                        }

                        if (showAddProductForm) {
                          if (productName.isEmpty ||
                              productDescription.isEmpty ||
                              imageNotifier.value == null) {
                            return;
                          }

                          final dinars =
                              productDinars.isEmpty ? '0' : productDinars;
                          final cents =
                              productCents.isEmpty ? '0' : productCents;

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
                        }

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
