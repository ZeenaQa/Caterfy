import 'package:caterfy/customers/customer_widgets/authenticated_customer.dart';
import 'package:caterfy/providers/global_provider.dart';
import 'package:caterfy/shared_widgets.dart/custom_spinner.dart';
import 'package:caterfy/vendors/screens/vendor_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialLoaderScreen extends StatefulWidget {
  final Map<String, dynamic> entryData;
  const InitialLoaderScreen({super.key, required this.entryData});

  @override
  State<InitialLoaderScreen> createState() => _InitialLoaderScreenState();
}

class _InitialLoaderScreenState extends State<InitialLoaderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setProviderStateAndNavigate();
    });
  }

  void _setProviderStateAndNavigate() {
    final role = widget.entryData['role'];
    final fetchedUser = widget.entryData['fetchedUser'];

    final globalProvider = Provider.of<GlobalProvider>(context, listen: false);
    globalProvider.setUser(fetchedUser);

    if (role == "customer") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AuthenticatedCustomer()),
      );
    } else {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => VendorHomeScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CustomThreeLineSpinner()));
  }
}
