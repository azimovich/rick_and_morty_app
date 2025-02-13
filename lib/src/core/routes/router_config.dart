import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/character_page/view/pages/character_page.dart';
import '../../feature/character_page/view/pages/search_character_page.dart';
import 'app_route_names.dart';

GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();

Page<dynamic> customEachTransitionAnimation(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<Object>(
    transitionsBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
    ) {
      var begin = const Offset(1.0, 0.0); // From right
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    child: child,
  );
}

@immutable
final class RouterConfigService {
  const RouterConfigService._();

  static final GoRouter router = GoRouter(
    // debugLogDiagnostics: true,
    navigatorKey: parentNavigatorKey,
    initialLocation: AppRouteNames.characterPage,
    // initialLocation: AppRouteNames.login,
    routes: <RouteBase>[
      // Home
      GoRoute(
        path: AppRouteNames.characterPage,
        builder: (context, state) => const CharacterPage(),
        routes: [
          GoRoute(
            path: AppRouteNames.searchCharacterPage,
            pageBuilder: (context, state) => customEachTransitionAnimation(context, state, SearchCharacterPage()),
          )
        ],
      ),
    ],
  );
}
