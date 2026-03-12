import 'package:flutter/material.dart';

class CartSection extends StatelessWidget {
  const CartSection({
    super.key,
    required this.sectionTitle,
    this.content = const [],
  });

  final String sectionTitle;
  final List<Widget> content;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            sectionTitle,
            style: TextStyle(
              color: colors.onSecondary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 6),
        ...content,
        if (content.isNotEmpty) SizedBox(height: 20),
      ],
    );
  }
}
