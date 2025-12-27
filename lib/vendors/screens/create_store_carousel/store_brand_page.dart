import 'dart:io';

import 'package:caterfy/util/image_utils.dart';
import 'package:caterfy/vendors/vendor_widgets/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:caterfy/l10n/app_localizations.dart';

class StoreBrandBannerPage extends StatelessWidget {
  final File? logoFile;
  final File? bannerFile;
  final Function(File file) onLogoSelected;
  final Function(File file) onBannerSelected;

  const StoreBrandBannerPage({
    super.key,
    required this.onLogoSelected,
    required this.onBannerSelected,
    this.logoFile,
    this.bannerFile,
  });

 Future<void> _pickImage(BuildContext context, {required bool isLogo}) async {
  final file = await pickAndCropImage(); 
  if (file == null) return;

  if (isLogo) {
    onLogoSelected(file);
  } else {
    onBannerSelected(file);
  }
}


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);

    return PageWrapper(
      title: l10.brandAndBanner,
      subtitle: l10.uploadLogoBanner,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _pickImage(context, isLogo: false),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: bannerFile != null
                      ? DecorationImage(
                          image: FileImage(bannerFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: bannerFile == null
                    ? Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: colors.primary.withOpacity(0.6),
                          size: 44,
                        ),
                      )
                    : null,
              ),
            ),
          ),

          /// LOGO
          Positioned(
            bottom: 200,
            left: 16,
            child: GestureDetector(
              onTap: () => _pickImage(context, isLogo: true),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                  image: logoFile != null
                      ? DecorationImage(
                          image: FileImage(logoFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: logoFile == null
                    ? Icon(Icons.add_a_photo, color: colors.primary)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
