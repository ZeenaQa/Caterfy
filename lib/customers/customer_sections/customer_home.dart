import 'package:caterfy/customers/customer_widgets/customer_global_top_bar.dart';
import 'package:caterfy/customers/customer_widgets/customer_home_categories.dart';
import 'package:caterfy/util/wavy_clipper.dart';
import 'package:flutter/material.dart';

class CustomerHomeSection extends StatefulWidget {
  const CustomerHomeSection({super.key});

  @override
  _ScrollHideHeaderPageState createState() => _ScrollHideHeaderPageState();
}

class _ScrollHideHeaderPageState extends State<CustomerHomeSection>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  double headerHeight = 175;
  double currentHeaderOffset = 0;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double delta = offset - lastOffset;

      currentHeaderOffset -= delta;

      if (currentHeaderOffset > 0) currentHeaderOffset = 0;
      if (currentHeaderOffset < -headerHeight) {
        currentHeaderOffset = -headerHeight;
      }

      lastOffset = offset;

      setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomerHomeCategories(topMargin: headerHeight),
          Transform.translate(
            offset: Offset(0, currentHeaderOffset),
            child: PhysicalShape(
              clipper: WavyClipper(waveHeight: 4),
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                height: headerHeight,
                padding: EdgeInsets.only(top: 25),
                child: CustomerGlobalTopBar(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
