// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
      $createGuardRoute,
      $editGuardRoute,
      $guardDetailRoute,
      $guardListRoute,
      $homeRoute,
      $insertFieldPageRoute,
      $insertSegmentPageRoute,
      $migrationRoute,
      $passwordGeneratorPageRoute,
    ];

RouteBase get $createGuardRoute => GoRouteData.$route(
      path: '/guard/create',
      factory: $CreateGuardRouteExtension._fromState,
    );

extension $CreateGuardRouteExtension on CreateGuardRoute {
  static CreateGuardRoute _fromState(GoRouterState state) => CreateGuardRoute(
        template: state.uri.queryParameters['template'] ?? "默认",
      );

  String get location => GoRouteData.$location(
        '/guard/create',
        queryParams: {
          if (template != "默认") 'template': template,
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editGuardRoute => GoRouteData.$route(
      path: '/guard/:id/edit',
      factory: $EditGuardRouteExtension._fromState,
    );

extension $EditGuardRouteExtension on EditGuardRoute {
  static EditGuardRoute _fromState(GoRouterState state) => EditGuardRoute(
        int.parse(state.pathParameters['id']!),
      );

  String get location => GoRouteData.$location(
        '/guard/${Uri.encodeComponent(id.toString())}/edit',
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

RouteBase get $passwordGeneratorPageRoute => GoRouteData.$route(
      path: '/password-generator',
      factory: $PasswordGeneratorPageRouteExtension._fromState,
    );

extension $PasswordGeneratorPageRouteExtension on PasswordGeneratorPageRoute {
  static PasswordGeneratorPageRoute _fromState(GoRouterState state) =>
      PasswordGeneratorPageRoute(
        plain: _$convertMapValue(
                'plain', state.uri.queryParameters, _$boolConverter) ??
            true,
      );

  String get location => GoRouteData.$location(
        '/password-generator',
        queryParams: {
          if (plain != true) 'plain': plain.toString(),
        },
      );

  void go(BuildContext context) => context.go(location);

  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

bool _$boolConverter(String value) {
  switch (value) {
    case 'true':
      return true;
    case 'false':
      return false;
    default:
      throw UnsupportedError('Cannot convert "$value" into a bool.');
  }
}
