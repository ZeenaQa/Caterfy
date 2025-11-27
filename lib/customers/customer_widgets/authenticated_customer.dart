import 'package:caterfy/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../customer_sections/customer_home.dart';
import '../customer_sections/customer_account.dart';
import '../customer_sections/customer_orders.dart';

class AuthenticatedCustomer extends StatefulWidget {
  const AuthenticatedCustomer({super.key});

  @override
  State<AuthenticatedCustomer> createState() => AuthenticatedCustomerState();
}

class AuthenticatedCustomerState extends State<AuthenticatedCustomer> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    CustomerHomeSection(),
    CustomerOrdersSection(),
    CustomerAccountSection(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(66, 226, 226, 226),
                blurRadius: 6,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: TextStyle(fontSize: 12, height: 2),
              unselectedLabelStyle: TextStyle(fontSize: 12, height: 2),
              backgroundColor: colors.surface,
              iconSize: 20,
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: SvgPicture.asset(
                      'assets/icons/caterfy_initial.svg',
                      height: 15,
                      width: 15,
                      colorFilter: ColorFilter.mode(
                        _currentIndex == 0
                            ? colors.primary
                            : colors.onSurfaceVariant,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                  label: l10n.home,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: Icon(Icons.receipt_outlined),
                  ),
                  label: l10n.orders,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 1),
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  label: l10n.account,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
