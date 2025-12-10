import 'dart:io';
import 'package:caterfy/vendors/providers/logged_vendor_provider.dart';
import 'package:caterfy/vendors/vendor_widgets/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StoreBrandBannerPage extends StatelessWidget {
  const StoreBrandBannerPage({super.key});

  Future<void> _pickImage(BuildContext context, bool isLogo) async {
    final picker = ImagePicker();
    final provider = context.read<LoggedVendorProvider>();

    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      if (isLogo) {
        provider.logoFile = File(image.path);
      } else {
        provider.bannerFile = File(image.path);
      }
      provider.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<LoggedVendorProvider>();

    return PageWrapper(
      title: "Brand & Banner",
      subtitle: "Upload your store logo and banner",
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
              onTap: () => _pickImage(context, false),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: provider.bannerFile != null
                      ? DecorationImage(
                          image: FileImage(provider.bannerFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: provider.bannerFile == null
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
          Positioned(
            bottom: 200,
            left: 16,
            child: GestureDetector(
              onTap: () => _pickImage(context, true),
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
                  image: provider.logoFile != null
                      ? DecorationImage(
                          image: FileImage(provider.logoFile!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: provider.logoFile == null
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
