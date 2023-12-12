import 'package:isar/isar.dart';
import 'package:password_generator/schema/guard.dart';
import 'package:password_generator/schema/guard_template.dart';
import 'package:password_generator/schema/migration.dart';
import 'package:path_provider/path_provider.dart';

/// A global instance of the Isar database.
///
/// This instance is used to interact with the Isar database throughout the app.
/// It is initialized and made accessible by the `IsarInitializer` class.
late Isar isar;

/// Initializes the Isar database and populates initial data.
///
/// This class provides a static method to ensure the Isar database is
/// initialized with the necessary schemas and pre-populated with default
/// data if required. It fetches the application document directory path
/// to store the database file and performs an initial seeding of data
/// for GuardTemplates if they do not already exist.
class IsarInitializer {
  /// Ensures that the Isar database is properly initialized.
  ///
  /// This method performs the following initialization steps:
  /// 1. Obtains the application documents directory.
  /// 2. Opens the Isar database with predefined schemas for Migration,
  ///    Guard, and GuardTemplate.
  /// 3. Seeds the GuardTemplate data if it does not already exist in the database.
  ///
  /// This method should be called at the start of the application to prepare
  /// the database for use.
  ///
  /// Throws an [Exception] if the database cannot be initialized.
  static Future<void> ensureInitialized() async {
    final directory = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [MigrationSchema, GuardSchema, GuardTemplateSchema],
      directory: directory.path,
    );
    _seedGuardTemplates();
  }

  /// Seeds the `GuardTemplate` collection with default data if it's not already present.
  ///
  /// This method checks for the presence of default `GuardTemplate` entries in the database
  /// and inserts them if they do not exist. The data is defined in a JSON-like list of maps
  /// and includes default fields for 'username', 'password', and 'comment'.
  ///
  /// This is an internal method and should not be called directly outside of `IsarInitializer`.
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
