import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/page/detail.dart';
import 'package:password_generator/page/form.dart';
import 'package:password_generator/page/form/component/insert_field.dart';
import 'package:password_generator/page/form/component/insert_segment.dart';
import 'package:password_generator/page/list.dart';
import 'package:password_generator/page/migration.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return const GuardListRoute().location;
  }
}

@TypedGoRoute<GuardListRoute>(path: '/guard')
class GuardListRoute extends GoRouteData {
  const GuardListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PasswordList();
  }
}

@TypedGoRoute<GuardDetailRoute>(path: '/guard/:id')
class GuardDetailRoute extends GoRouteData {
  const GuardDetailRoute(this.id);

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordDetail(id: id);
  }
}

@TypedGoRoute<CreateGuardRoute>(path: '/guard/create')
class CreateGuardRoute extends GoRouteData {
  const CreateGuardRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PasswordForm();
  }
}

@TypedGoRoute<EditGuardRoute>(path: '/guard/:id/edit')
class EditGuardRoute extends GoRouteData {
  const EditGuardRoute(this.id);

  final int id;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordForm(id: id);
  }
}

@TypedGoRoute<InsertFieldPageRoute>(path: '/insert-field')
class InsertFieldPageRoute extends GoRouteData {
  const InsertFieldPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InsertFieldPage();
  }
}

@TypedGoRoute<InsertSegmentPageRoute>(path: '/insert-segment')
class InsertSegmentPageRoute extends GoRouteData {
  const InsertSegmentPageRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InsertSegmentPage();
  }
}

@TypedGoRoute<MigrationRoute>(path: '/migration')
class MigrationRoute extends GoRouteData {
  const MigrationRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MigrationPage();
  }
}
