import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';

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
          Text(
            'Store Info',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 20),

          LabeledInput(
            label: 'Store Name (Arabic)',
            hint: 'اكتب اسم المتجر بالعربية',
            errorText: provider.showStoreInfoErrors &&
                    storeForm.name_ar.isEmpty
                ? 'Required'
                : null,
            onChanged: (val) {
              provider.updateStoreForm(nameAr: val);
              provider.showStoreInfoErrors = false;
            },
          ),

          const SizedBox(height: 16),

          LabeledInput(
            label: 'Store Name (English)',
            hint: 'Write store name in English',
            errorText: provider.showStoreInfoErrors &&
                    storeForm.name.isEmpty
                ? 'Required'
                : null,
            onChanged: (val) {
              provider.updateStoreForm(name: val);
              provider.showStoreInfoErrors = false;
            },
          ),

          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value:
                storeForm.category.isEmpty ? null : storeForm.category,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
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
              provider.showStoreInfoErrors = false;
            },
          ),
        ],
      ),
    );
  }
}


class LabeledInput extends StatelessWidget {
  final String label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String> onChanged;
  final TextInputType keyboardType;

  const LabeledInput({
    super.key,
    required this.label,
    required this.onChanged,
    this.hint,
    this.errorText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6, left: 12),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: errorText != null ? colors.error : colors.onSurface,
            ),
          ),
        ),
        TextField(
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
