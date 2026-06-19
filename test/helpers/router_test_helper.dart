import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Builds a [GoRouter] for widget tests.
///
/// Use [initialLocation] to start a test on a specific route and pass
/// additional [routes] for navigation targets.
GoRouter createTestRouter({
  required Widget home,
  String initialLocation = '/',
  List<RouteBase> routes = const <RouteBase>[],
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(path: '/', builder: (context, state) => home),
      ...routes,
    ],
  );
}

/// Creates a router-aware [MaterialApp.router] for widget tests.
///
/// Pass a fully custom [routerConfig] when needed, or rely on [home] + [routes]
/// for lightweight setup.
Widget buildRouterTestApp({
  required Widget home,
  String initialLocation = '/',
  List<RouteBase> routes = const <RouteBase>[],
  GoRouter? routerConfig,
}) {
  final router =
      routerConfig ??
      createTestRouter(
        home: home,
        initialLocation: initialLocation,
        routes: routes,
      );

  return MaterialApp.router(routerConfig: router);
}
