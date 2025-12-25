import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/l10n/app_localizations.dart';
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
    final l10 = AppLocalizations.of(context);

    String catLabel(String cat) {
      switch (cat) {
        case 'electronics':
          return l10.electronics;
        case 'food':
          return l10.food;
        case 'groceries':
          return l10.groceries;
        case 'pharmacy':
          return l10.pharmacy;
        case 'toysAndKids':
          return l10.toysAndKids;
        case 'healthAndBeauty':
          return l10.healthAndBeauty;
        default:
          return cat;
      }
    }

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
          Text(l10.storeInfo, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 20),

          /// ===== STORE NAME (AR) =====
          LabeledTextField(
            label: l10.storeNameArabic,
            hint: l10.storeNameArabicHint,
            value: storeForm.name_ar,
            errorText: provider.showStoreInfoErrors && storeForm.name_ar.isEmpty
                ? l10.required
                : null,
            onChanged: (val) {
              provider.updateStoreForm(nameAr: val);
              provider.showStoreInfoErrors = false;
            },
          ),

          const SizedBox(height: 16),

          /// ===== STORE NAME (EN) =====
          LabeledTextField(
            label: l10.storeNameEnglish,
            hint: l10.storeNameEnglishHint,
            value: storeForm.name,
            errorText: provider.showStoreInfoErrors && storeForm.name.isEmpty
                ? l10.required
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
              labelText: l10.category,
              errorText:
                  provider.showStoreInfoErrors && storeForm.category.isEmpty
                  ? l10.required
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: categories
                .map((cat) => DropdownMenuItem(value: cat, child: Text(catLabel(cat))))
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
