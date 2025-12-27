import 'dart:io';
import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/custom_dialog.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:caterfy/l10n/app_localizations.dart';
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
  String categoryNameAr = '';
  String originalCategoryNameAr = '';
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

    final provider = Provider.of<LoggedVendorProvider>(context, listen: false);
    final cat = provider.subCategories.firstWhere(
      (c) => c['id'] == widget.categoryId,
      orElse: () => {},
    );

    categoryNameAr = cat.isNotEmpty ? (cat['name_ar'] ?? '') : '';
    originalCategoryNameAr = categoryNameAr;
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
    final l10 = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: l10.editCategory,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete') {
                final confirmed = await showCustomDialog(
                  context,
                  title: l10.deleteCategory,
                  content: l10.deleteCategoryConfirmation,
                  confirmText: l10.delete,
                  cancelText: l10.cancel,
                  onConfirmAsync: () async {
                    await context.read<LoggedVendorProvider>().deleteCategory(
                      widget.categoryId,
                    );
                  },
                );

                if (confirmed == true && context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      l10.deleteCategory,
                      style: const TextStyle(color: Colors.red),
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
                label: l10.categoryName,
                value: categoryName,
                onChanged: (val) => categoryName = val.trim(),
              ),

              const SizedBox(height: 12),

              LabeledTextField(
                label: l10.categoryNameArabic,
                value: categoryNameAr,
                onChanged: (val) => categoryNameAr = val.trim(),
              ),

              const SizedBox(height: 24),

              FilledBtn(
                title: l10.save,
                isLoading: provider.isLoading,
                onPressed: provider.isLoading
                    ? () {}
                    : () async {
                        if (categoryName.trim() != widget.categoryName ||
                            categoryNameAr.trim() != originalCategoryNameAr) {
                          await provider.updateCategory(
                            categoryId: widget.categoryId,
                            newName: categoryName.trim(),
                            newNameAr: categoryNameAr.isEmpty
                                ? null
                                : categoryNameAr.trim(),
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
