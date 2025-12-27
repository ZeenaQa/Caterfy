import 'package:flutter/material.dart';
import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/textfields.dart';

class StoreInfoPage extends StatefulWidget {
  final void Function(String name, String nameAr, String category) onChanged;

  final bool showErrors;

  final String initialName;
  final String initialNameAr;
  final String initialCategory;

  const StoreInfoPage({
    super.key,
    required this.onChanged,
    required this.showErrors,
    this.initialName = '',
    this.initialNameAr = '',
    this.initialCategory = '',
  });

  static const categories = [
    'electronics',
    'food',
    'groceries',
    'pharmacy',
    'toysAndKids',
    'healthAndBeauty',
  ];

  @override
  State<StoreInfoPage> createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends State<StoreInfoPage> {
  late String _name;
  late String _nameAr;
  String? _category;

  @override
  void initState() {
    super.initState();
    _name = widget.initialName;
    _nameAr = widget.initialNameAr;
    _category = widget.initialCategory.isEmpty ? null : widget.initialCategory;
  }

  void _notifyParent() {
    widget.onChanged(_name.trim(), _nameAr.trim(), _category ?? '');
  }

  @override
  Widget build(BuildContext context) {
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
            value: _nameAr,
            errorText: widget.showErrors && _nameAr.trim().isEmpty
                ? l10.required
                : null,
            onChanged: (val) {
              setState(() => _nameAr = val);
              _notifyParent();
            },
          ),

          const SizedBox(height: 16),

          /// ===== STORE NAME (EN) =====
          LabeledTextField(
            label: l10.storeNameEnglish,
            hint: l10.storeNameEnglishHint,
            value: _name,
            errorText: widget.showErrors && _name.trim().isEmpty
                ? l10.required
                : null,
            onChanged: (val) {
              setState(() => _name = val);
              _notifyParent();
            },
          ),

          const SizedBox(height: 21),

          /// ===== CATEGORY =====
          DropdownButtonFormField<String>(
            value: _category,
            decoration: InputDecoration(
              labelText: l10.category,
              errorText:
                  widget.showErrors && (_category == null || _category!.isEmpty)
                  ? l10.required
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: StoreInfoPage.categories
                .map(
                  (cat) =>
                      DropdownMenuItem(value: cat, child: Text(catLabel(cat))),
                )
                .toList(),
            onChanged: (val) {
              setState(() => _category = val);
              _notifyParent();
            },
          ),
        ],
      ),
    );
  }
}
