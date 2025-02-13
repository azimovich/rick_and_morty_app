import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:rick_and_morty_app/src/core/style/app_colors.dart";

import "../routes/router_config.dart";
import "package:flutter/material.dart";

class AppMaterialContext extends ConsumerWidget {
  const AppMaterialContext({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Builder(
      builder: (context) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: RouterConfigService.router,
          theme: ThemeData(
            appBarTheme: AppBarTheme(backgroundColor: AppColors.c272B33),
            scaffoldBackgroundColor: AppColors.c272B33,
          ),
        );
      },
    );
  }
}
