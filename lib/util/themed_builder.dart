import 'package:caterfy/util/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemedBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) builder;

  const ThemedBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    // This watches the ThemeController and triggers rebuilds when theme changes
    context.watch<ThemeController>();
    return builder(context);
  }
}
