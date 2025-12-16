import 'package:caterfy/shared_widgets.dart/textfields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

class StoreInfoPage extends StatelessWidget {
  const StoreInfoPage({super.key});

  static const List<String> categories = [
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
    final storeForm = provider.storeForm;

    if (storeForm == null) {
      return const SizedBox(); 
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Store Info',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 20),

          LabeledTextField(
            label: 'Store Name (Arabic)',
            value: storeForm.name_ar,
            onChanged: (val) {
              provider.updateStoreForm(nameAr: val);

              if (provider.showStoreInfoErrors) {
                provider.showStoreInfoErrors = false;
              }
            },
            errorText: provider.showStoreInfoErrors &&
                    storeForm.name_ar.isEmpty
                ? 'Required'
                : null,
          ),

          const SizedBox(height: 16),

     
          LabeledTextField(
            label: 'Store Name (English)',
            value: storeForm.name,
            onChanged: (val) {
              provider.updateStoreForm(name: val);

              if (provider.showStoreInfoErrors) {
                provider.showStoreInfoErrors = false;
              }
            },
            errorText: provider.showStoreInfoErrors &&
                    storeForm.name.isEmpty
                ? 'Required'
                : null,
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: storeForm.category.isEmpty
                ? null
                : storeForm.category,
            decoration: InputDecoration(
              labelText: 'Category',
              border: const OutlineInputBorder(),
              errorText: provider.showStoreInfoErrors &&
                      storeForm.category.isEmpty
                  ? 'Required'
                  : null,
            ),
            items: categories
                .map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  ),
                )
                .toList(),
            onChanged: (val) {
              provider.updateStoreForm(category: val);
            },
          ),
        ],
      ),
    );
  }
}
