import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../widgets/app_material_context.dart";
import "../widgets/custom_screen_util.dart";

class App extends StatelessWidget {
  const App({super.key});

  static void run() => runApp(const ProviderScope(child: App()));

  @override
  Widget build(BuildContext context) => const CustomScreenUtil(
        enabledPreview: false,
        child: AppMaterialContext(),
      );
}
