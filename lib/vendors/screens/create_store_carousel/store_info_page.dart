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
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Store Info', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 20),

      
          LabeledTextField(
            label: 'Store Name (Arabic)',
            value: provider.storeNameAr,
            onChanged: (val) => provider.storeNameAr = val,
            errorText: provider.storeNameAr == null || provider.storeNameAr!.isEmpty
                ? 'Required'
                : null,
          ),
          const SizedBox(height: 16),

          LabeledTextField(
            label: 'Store Name (English)',
            value: provider.storeNameEn,
            onChanged: (val) => provider.storeNameEn = val,
            errorText: provider.storeNameEn == null || provider.storeNameEn!.isEmpty
                ? 'Required'
                : null,
          ),
          const SizedBox(height: 16),

       
          DropdownButtonFormField<String>(
            value: provider.storeCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: categories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat),
              );
            }).toList(),
            onChanged: (val) => provider.storeCategory = val,
          ),
        ],
      ),
    );
  }
}
