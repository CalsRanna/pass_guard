// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $homeRoute,
      $guardListRoute,
      $guardDetailRoute,
      $insertFieldPageRoute,
      $insertSegmentPageRoute,
      $migrationRoute,
    ];

RouteBase get $homeRoute => GoRouteData.$route(
      path: '/',
      factory: $HomeRouteExtension._fromState,
    );

extension $HomeRouteExtension on HomeRoute {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $guardListRoute => GoRouteData.$route(
      path: '/guard',
      factory: $GuardListRouteExtension._fromState,
    );

extension $GuardListRouteExtension on GuardListRoute {
  static GuardListRoute _fromState(GoRouterState state) =>
      const GuardListRoute();

  String get location => GoRouteData.$location(
        '/guard',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $guardDetailRoute => GoRouteData.$route(
      path: '/guard/:id',
      factory: $GuardDetailRouteExtension._fromState,
    );

extension $GuardDetailRouteExtension on GuardDetailRoute {
  static GuardDetailRoute _fromState(GoRouterState state) => GuardDetailRoute(
        int.parse(state.pathParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/guard/${Uri.encodeComponent(id.toString())}',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $insertFieldPageRoute => GoRouteData.$route(
      path: '/insert-field',
      factory: $InsertFieldPageRouteExtension._fromState,
    );

extension $InsertFieldPageRouteExtension on InsertFieldPageRoute {
  static InsertFieldPageRoute _fromState(GoRouterState state) =>
      const InsertFieldPageRoute();

  String get location => GoRouteData.$location(
        '/insert-field',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $insertSegmentPageRoute => GoRouteData.$route(
      path: '/insert-segment',
      factory: $InsertSegmentPageRouteExtension._fromState,
    );

extension $InsertSegmentPageRouteExtension on InsertSegmentPageRoute {
  static InsertSegmentPageRoute _fromState(GoRouterState state) =>
      const InsertSegmentPageRoute();

  String get location => GoRouteData.$location(
        '/insert-segment',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $migrationRoute => GoRouteData.$route(
      path: '/migration',
      factory: $MigrationRouteExtension._fromState,
    );

extension $MigrationRouteExtension on MigrationRoute {
  static MigrationRoute _fromState(GoRouterState state) =>
      const MigrationRoute();

  String get location => GoRouteData.$location(
        '/migration',
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}
