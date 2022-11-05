import 'dart:async';
import 'package:floor/floor.dart';
import 'package:password_generator/dao/guard_tag.dart';
import 'package:password_generator/dao/password.dart';
import 'package:password_generator/dao/tag.dart';
import 'package:password_generator/entity/guard_tag.dart';
import 'package:password_generator/entity/password.dart';
import 'package:password_generator/entity/tag.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 3, entities: [GuardTag, Password, Tag])
abstract class PasswordDatabase extends FloorDatabase {
  GuardTagDao get guardTagDao;
  PasswordDao get passwordDao;
  TagDao get tagDao;
}
