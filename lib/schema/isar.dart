import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/guard_template.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:path_provider/path_provider.dart';

late Isar isar;

class IsarInitializer {
  static Future<void> ensureInitialized() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MigrationSchema, GuardSchema, GuardTemplateSchema],
      directory: directory.path,
    );
    _seedGuardTemplates();
  }

  static Future<void> _seedGuardTemplates() async {
    final json = [
      {
        'name': '默认',
        'segments': [
          {
            'title': '',
            'fields': [
              {'key': 'username', 'value': '', 'type': 'text', 'label': '用户名'},
              {
                'key': 'password',
                'value': '',
                'type': 'password',
                'label': '密码'
              }
            ]
          },
          {
            'title': '备注',
            'fields': [
              {'key': 'comment', 'value': '', 'type': 'text', 'label': '备注'}
            ]
          }
        ]
      }
    ];
    for (var item in json) {
      final exist = await isar.guardTemplates
          .filter()
          .nameEqualTo('${item['name']}')
          .findFirst();
      if (exist != null) return;
      final template = GuardTemplate.fromJson(item);
      await isar.writeTxn(() async {
        await isar.guardTemplates.put(template);
      });
    }
  }
}
