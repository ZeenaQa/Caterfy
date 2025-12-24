import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class StoreInfoPage extends StatelessWidget {
  const StoreInfoPage({super.key});

  static const categories = [
    'electronics',
    'food',
    'groceries',
    'pharmacy',
    'toysAndKids',
    'healthAndBeauty',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoggedVendorProvider>();

    if (provider.storeForm == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.initStoreForm();
      });
      return const Center(child: CircularProgressIndicator());
    }

    final storeForm = provider.storeForm!;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Store Info', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 20),

          /// ===== STORE NAME (AR) =====
          LabeledTextField(
            label: 'Store Name (Arabic)',
            hint: 'اكتب اسم المتجر بالعربية',
            value: storeForm.name_ar,
            errorText: provider.showStoreInfoErrors && storeForm.name_ar.isEmpty
                ? 'Required'
                : null,
            onChanged: (val) {
              provider.updateStoreForm(nameAr: val);
              provider.showStoreInfoErrors = false;
            },
          ),

          const SizedBox(height: 16),

          /// ===== STORE NAME (EN) =====
          LabeledTextField(
            label: 'Store Name (English)',
            hint: 'Write store name in English',
            value: storeForm.name,
            errorText: provider.showStoreInfoErrors && storeForm.name.isEmpty
                ? 'Required'
                : null,
            onChanged: (val) {
              provider.updateStoreForm(name: val);
              provider.showStoreInfoErrors = false;
            },
          ),

          const SizedBox(height: 21),

          /// ===== CATEGORY =====
          DropdownButtonFormField<String>(
            value: storeForm.category.isEmpty ? null : storeForm.category,
            decoration: InputDecoration(
              labelText: 'Category',
              errorText:
                  provider.showStoreInfoErrors && storeForm.category.isEmpty
                  ? 'Required'
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                .toList(),
            onChanged: (val) {
              provider.updateStoreForm(category: val);
              provider.showStoreInfoErrors = false;
            },
          ),
        ],
      ),
    );
  }
}
