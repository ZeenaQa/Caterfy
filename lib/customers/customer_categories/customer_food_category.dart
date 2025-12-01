import 'package:caterfy/shared_widgets.dart/custom_appBar.dart';
import 'package:caterfy/shared_widgets.dart/outlined_icon_btn.dart';
import 'package:flutter/material.dart';

class CustomerFoodCategory extends StatefulWidget {
  const CustomerFoodCategory({super.key});

  @override
  State<CustomerFoodCategory> createState() => _CustomerFoodCategoryState();
}

class _CustomerFoodCategoryState extends State<CustomerFoodCategory> {
  late ScrollController _scrollController;

  double searchBarHeight = 60;
  double currentSearchBarOffset = 0;
  double lastOffset = 0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double delta = offset - lastOffset;

      currentSearchBarOffset -= delta;

      if (currentSearchBarOffset > 0) currentSearchBarOffset = 0;
      if (currentSearchBarOffset < -searchBarHeight)
        currentSearchBarOffset = -searchBarHeight;

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
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        content: Expanded(
          child: Row(
            spacing: 10,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: colors.onSurface),
                    children: [
                      TextSpan(text: 'Deliver to '),
                      TextSpan(
                        text: 'Hashemite University',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              OutlinedIconBtn(icon: Icons.favorite_outline),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: searchBarHeight + 26,
            ),
            itemCount: 50,
            itemBuilder: (context, index) {
              return ListTile(title: Text('Item $index'));
            },
          ),
          Transform.translate(
            offset: Offset(0, currentSearchBarOffset),
            child: Container(
              color: colors.surface,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 12,
                bottom: 10,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search food",
                    hintStyle: TextStyle(fontSize: 15),
                    filled: true,
                    fillColor: colors.outline,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    prefixIconConstraints: BoxConstraints(minHeight: 0),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 13.0, right: 5),
                      child: Icon(Icons.search, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
