import 'package:caterfy/l10n/app_localizations.dart';
import 'package:caterfy/shared_widgets.dart/filled_button.dart';
import 'package:caterfy/shared_widgets.dart/outlined_button.dart';
import 'package:caterfy/vendors/providers/vendor_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorSignupCarousel extends StatefulWidget {
  const VendorSignupCarousel({super.key});

  @override
  State<VendorSignupCarousel> createState() => _VendorSignupCarouselState();
}

class _VendorSignupCarouselState extends State<VendorSignupCarousel> {
  final PageController _controller = PageController();
  int currentPage = 0;

  /// ===== LOCAL STATE =====
  String storeType = '';
  String name = '';
  String email = '';
  String phoneNumber = '';
  String businessName = '';
  String selectedBusiness = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    super.initState();
    selectedBusiness = '';
  }

  bool get isStoreTypeValid => storeType.isNotEmpty;
  bool get isPersonalInfoValid =>
      name.isNotEmpty &&
      email.isNotEmpty &&
      phoneNumber.isNotEmpty;
  bool get isBusinessInfoValid =>
      businessName.isNotEmpty && selectedBusiness.isNotEmpty;
  bool get isPasswordValid => password.isNotEmpty && confirmPassword.isNotEmpty;

  Widget buildDots(Color active, Color inactive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == i ? 18 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == i ? active : inactive,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10 = AppLocalizations.of(context);
    final auth = Provider.of<VendorAuthProvider>(context);

    return PopScope(
      canPop: currentPage == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop && currentPage > 0) {
          _controller.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: colors.surface,
          elevation: 0,
          centerTitle: true,
          title: const SizedBox.shrink(),
          leading: currentPage > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
              : null,
        ),
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (i) => setState(() => currentPage = i),
          children: [
            /// ===== STORE TYPE SELECTION =====
            _buildStoreTypePage(l10, colors),

            /// ===== PERSONAL INFO =====
            _buildPersonalInfoPage(l10, auth, colors),

            /// ===== BUSINESS INFO =====
            _buildBusinessInfoPage(l10, auth, colors),

            /// ===== PASSWORD =====
            _buildPasswordPage(l10, auth, colors),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentPage > 0)
                    SizedBox(
                      width: 140,
                      child: OutlinedBtn(
                        title: l10.cancel,
                        onPressed: () {
                          _controller.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    )
                  else
                    const SizedBox(width: 140),
                  SizedBox(
                    width: 140,
                    child: FilledBtn(
                      title: currentPage == 3 ? l10.submitApplication : l10.next,
                      isLoading: auth.isLoading,
                      onPressed: () async {
                        bool canProceed = false;

                        switch (currentPage) {
                          case 0:
                            canProceed = isStoreTypeValid;
                            break;
                          case 1:
                            canProceed = auth.validatePersonalInfo(
                              email: email.trim(),
                              name: name.trim(),
                              phoneNumber: phoneNumber.trim(),
                              l10: l10,
                            );
                            break;
                          case 2:
                            canProceed = auth.validateBusinessInfo(
                              businessName: businessName,
                              businessType: selectedBusiness,
                              l10: l10,
                            );
                            break;
                          case 3:
                            canProceed = auth.validatePasswordInfo(
                              password: password,
                              confirmPassword: confirmPassword,
                              l10: l10,
                            );
                            if (canProceed) {
                              final success = await auth.signUp(
                                email: email,
                                name: name,
                                password: password,
                                confirmPassword: confirmPassword,
                                phoneNumber: phoneNumber,
                                businessName: businessName,
                                businessType: selectedBusiness,
                                storeType: storeType,
                                context: context,
                              );

                              if (success && context.mounted) {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              }
                            }
                            return;
                        }

                        if (canProceed) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              buildDots(colors.primary, colors.outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoreTypePage(AppLocalizations l10, ColorScheme colors) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
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

            /// Regular Store
            _buildOptionCard(
              l10.regularStore,
              l10.regularStoreDesc,
              storeType == 'regular',
              () => setState(() => storeType = 'regular'),
              colors,
            ),
            const SizedBox(height: 20),

            /// Service Provider
            _buildOptionCard(
              l10.serviceProvider,
              l10.serviceProviderDesc,
              storeType == 'service',
              () => setState(() => storeType = 'service'),
              colors,
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    String title,
    String description,
    bool isSelected,
    VoidCallback onTap,
    ColorScheme colors,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? colors.primaryContainer.withValues(alpha: 0.1)
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
                  color:
                      isSelected ? colors.primary : colors.outlineVariant,
                  width: 2,
                ),
              ),
              child: isSelected
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
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
    );
  }

  Widget _buildPersonalInfoPage(
    AppLocalizations l10,
    VendorAuthProvider auth,
    ColorScheme colors,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text(
            l10.personalInformation,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 23),
          _buildTextField(
            label: l10.name,
            hint: l10.firstLastName,
            value: name,
            onChanged: (v) {
              setState(() => name = v);
              auth.clearNameError();
            },
            errorText: auth.nameError,
            colors: colors,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: l10.email,
            hint: 'example@gmail.com',
            value: email,
            onChanged: (v) {
              setState(() => email = v);
              auth.clearEmailError();
            },
            errorText: auth.emailError,
            keyboardType: TextInputType.emailAddress,
            colors: colors,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            label: l10.phoneNumber,
            hint: l10.enterPhoneNumber,
            value: phoneNumber,
            onChanged: (v) {
              setState(() => phoneNumber = v);
              auth.clearPhoneError();
            },
            errorText: auth.phoneError,
            keyboardType: TextInputType.phone,
            colors: colors,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoPage(
    AppLocalizations l10,
    VendorAuthProvider auth,
    ColorScheme colors,
  ) {
    List<String> businessTypes = [
      l10.restaurant,
      l10.cafe,
      l10.bakery,
      l10.grocery,
      l10.other,
    ];

    // Initialize selectedBusiness if empty
    String currentBusiness = selectedBusiness.isEmpty && businessTypes.isNotEmpty
        ? businessTypes[0]
        : selectedBusiness;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          Text(
            l10.businessInformation,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 23),
          _buildTextField(
            label: l10.businessName,
            hint: l10.enterBusinessName,
            value: businessName,
            onChanged: (v) {
              setState(() => businessName = v);
              auth.clearBusinessNameError();
            },
            errorText: auth.businessNameError,
            colors: colors,
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 6),
                child: Text(
                  l10.businessType,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: currentBusiness.isEmpty ? businessTypes.first : currentBusiness,
                items: businessTypes
                    .map(
                      (type) => DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedBusiness = value);
                  }
                },
                decoration: InputDecoration(
                  filled: false,
                  errorText: auth.businessTypeError,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                dropdownColor: colors.surface,
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildPasswordPage(
    AppLocalizations l10,
    VendorAuthProvider auth,
    ColorScheme colors,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Center(
            child: Text(
              l10.setYourPassword,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 30),
          _buildPasswordField(
            label: l10.password,
            hint: '••••••••',
            value: password,
            onChanged: (v) {
              setState(() => password = v);
              auth.clearPassError();
            },
            errorText: auth.passwordError,
            colors: colors,
          ),
          const SizedBox(height: 15),
          _buildPasswordField(
            label: l10.confirmPassword,
            hint: '••••••••',
            value: confirmPassword,
            onChanged: (v) {
              setState(() => confirmPassword = v);
              auth.clearConfirmPassError();
            },
            errorText: auth.confirmPasswordError,
            colors: colors,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
        TextField(
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: false,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required String value,
    required Function(String) onChanged,
    String? errorText,
    required ColorScheme colors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
        TextField(
          onChanged: onChanged,
          obscureText: true,
          textDirection: TextDirection.ltr,
          decoration: InputDecoration(
            hintText: hint,
            filled: false,
            errorText: errorText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
