import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:password_generator/page/detail.dart';
import 'package:password_generator/page/form/component/insert_field.dart';
import 'package:password_generator/page/form/component/insert_segment.dart';
import 'package:password_generator/page/form/form.dart';
import 'package:password_generator/page/list.dart';
import 'package:password_generator/page/migration.dart';
import 'package:password_generator/page/password_generator.dart';

part 'router.g.dart';

final router = GoRouter(routes: $appRoutes);

@TypedGoRoute<CreateGuardRoute>(path: '/guard/create')
class CreateGuardRoute extends GoRouteData {
  final String template;

  const CreateGuardRoute({this.template = "默认"});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordForm(template: template);
  }
}

@TypedGoRoute<EditGuardRoute>(path: '/guard/:id/edit')
class EditGuardRoute extends GoRouteData {
  final int id;

  const EditGuardRoute(this.id);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordForm(id: id);
  }
}

@TypedGoRoute<GuardDetailRoute>(path: '/guard/:id')
class GuardDetailRoute extends GoRouteData {
  final int id;

  const GuardDetailRoute(this.id);

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordDetail(id: id);
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

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    return const GuardListRoute().location;
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

@TypedGoRoute<PasswordGeneratorPageRoute>(path: '/password-generator')
class PasswordGeneratorPageRoute extends GoRouteData {
  final bool plain;

  const PasswordGeneratorPageRoute({this.plain = true});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PasswordGeneratorPage(plain: plain);
  }
}
