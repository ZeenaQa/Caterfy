import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/vendors/screens/vendor_signup/personal_info.dart';
import 'package:flutter/material.dart';

class StoreTypeSelection extends StatefulWidget {
  const StoreTypeSelection({super.key});

  @override
  State<StoreTypeSelection> createState() => _StoreTypeSelectionState();
}

class _StoreTypeSelectionState extends State<StoreTypeSelection> {
  String? selectedStoreType;

  void handleNext(BuildContext context, l10) {
    if (selectedStoreType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10.emptyField),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) =>
            VendorPersonalInfo(storeType: selectedStoreType!),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10 = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Center(
                child: Text(
                  l10.selectStoreType,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  l10.selectStoreTypeDesc,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: colors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 50),

              /// Regular Store Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStoreType = 'regular';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedStoreType == 'regular'
                          ? colors.primary
                          : colors.outlineVariant,
                      width: selectedStoreType == 'regular' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedStoreType == 'regular'
                        ? colors.primaryContainer.withOpacity(0.1)
                        : colors.surface,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedStoreType == 'regular'
                                ? colors.primary
                                : colors.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: selectedStoreType == 'regular'
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10.regularStore,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10.regularStoreDesc,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Service Provider Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStoreType = 'service';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedStoreType == 'service'
                          ? colors.primary
                          : colors.outlineVariant,
                      width: selectedStoreType == 'service' ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: selectedStoreType == 'service'
                        ? colors.primaryContainer.withOpacity(0.1)
                        : colors.surface,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selectedStoreType == 'service'
                                ? colors.primary
                                : colors.outlineVariant,
                            width: 2,
                          ),
                        ),
                        child: selectedStoreType == 'service'
                            ? Center(
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colors.primary,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10.serviceProvider,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10.serviceProviderDesc,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              Align(
                alignment: Alignment.centerRight,
                child: FilledBtn(
                  onPressed: () => handleNext(context, l10),
                  title: l10.next,
                  stretch: false,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
