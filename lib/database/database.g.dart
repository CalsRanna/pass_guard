// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorPasswordDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PasswordDatabaseBuilder databaseBuilder(String name) =>
      _$PasswordDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PasswordDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$PasswordDatabaseBuilder(null);
}

class _$PasswordDatabaseBuilder {
  _$PasswordDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$PasswordDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$PasswordDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<PasswordDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$PasswordDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$PasswordDatabase extends PasswordDatabase {
  _$PasswordDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  GuardTagDao? _guardTagDaoInstance;

  PasswordDao? _passwordDaoInstance;

  TagDao? _tagDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `guard_tags` (`guard_id` INTEGER NOT NULL, `tag_id` INTEGER NOT NULL, PRIMARY KEY (`guard_id`, `tag_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `passwords` (`comment` TEXT, `id` INTEGER, `name` TEXT NOT NULL, `password` TEXT NOT NULL, `username` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `tags` (`id` INTEGER, `name` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE UNIQUE INDEX `index_tags_name` ON `tags` (`name`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  GuardTagDao get guardTagDao {
    return _guardTagDaoInstance ??= _$GuardTagDao(database, changeListener);
  }

  @override
  PasswordDao get passwordDao {
    return _passwordDaoInstance ??= _$PasswordDao(database, changeListener);
  }

  @override
  TagDao get tagDao {
    return _tagDaoInstance ??= _$TagDao(database, changeListener);
  }
}

class _$GuardTagDao extends GuardTagDao {
  _$GuardTagDao(
    this.database,
    this.changeListener,
  ) : _queryAdapter = QueryAdapter(database);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  @override
  Future<List<GuardTag>> getAllGuardTags() async {
    return _queryAdapter.queryList('select * from guard_tags',
        mapper: (Map<String, Object?> row) => GuardTag(
            guardId: row['guard_id'] as int, tagId: row['tag_id'] as int));
  }
}

class _$PasswordDao extends PasswordDao {
  _$PasswordDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _passwordInsertionAdapter = InsertionAdapter(
            database,
            'passwords',
            (Password item) => <String, Object?>{
                  'comment': item.comment,
                  'id': item.id,
                  'name': item.name,
                  'password': item.password,
                  'username': item.username
                }),
        _passwordUpdateAdapter = UpdateAdapter(
            database,
            'passwords',
            ['id'],
            (Password item) => <String, Object?>{
                  'comment': item.comment,
                  'id': item.id,
                  'name': item.name,
                  'password': item.password,
                  'username': item.username
                }),
        _passwordDeletionAdapter = DeletionAdapter(
            database,
            'passwords',
            ['id'],
            (Password item) => <String, Object?>{
                  'comment': item.comment,
                  'id': item.id,
                  'name': item.name,
                  'password': item.password,
                  'username': item.username
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Password> _passwordInsertionAdapter;

  final UpdateAdapter<Password> _passwordUpdateAdapter;

  final DeletionAdapter<Password> _passwordDeletionAdapter;

  @override
  Future<void> deleteAllPasswords() async {
    await _queryAdapter.queryNoReturn('delete from passwords');
  }

  @override
  Future<Password?> findPasswordById(int id) async {
    return _queryAdapter.query('select * from passwords where id = ?1',
        mapper: (Map<String, Object?> row) => Password(
            comment: row['comment'] as String?,
            id: row['id'] as int?,
            name: row['name'] as String,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [id]);
  }

  @override
  Future<List<Password>> getAllPasswords() async {
    return _queryAdapter.queryList('select * from passwords order by name',
        mapper: (Map<String, Object?> row) => Password(
            comment: row['comment'] as String?,
            id: row['id'] as int?,
            name: row['name'] as String,
            username: row['username'] as String,
            password: row['password'] as String));
  }

  @override
  Future<List<Password>> getPasswordsLikeName(String text) async {
    return _queryAdapter.queryList(
        'select * from passwords where name like ?1 order by name',
        mapper: (Map<String, Object?> row) => Password(
            comment: row['comment'] as String?,
            id: row['id'] as int?,
            name: row['name'] as String,
            username: row['username'] as String,
            password: row['password'] as String),
        arguments: [text]);
  }

  @override
  Future<void> insertPassword(Password password) async {
    await _passwordInsertionAdapter.insert(password, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePassword(Password password) async {
    await _passwordUpdateAdapter.update(password, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePassword(Password password) async {
    await _passwordDeletionAdapter.delete(password);
  }
}

class _$TagDao extends TagDao {
  _$TagDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _tagInsertionAdapter = InsertionAdapter(database, 'tags',
            (Tag item) => <String, Object?>{'id': item.id, 'name': item.name}),
        _tagDeletionAdapter = DeletionAdapter(database, 'tags', ['id'],
            (Tag item) => <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tag> _tagInsertionAdapter;

  final DeletionAdapter<Tag> _tagDeletionAdapter;

  @override
  Future<List<Tag>> getAllTags() async {
    return _queryAdapter.queryList('select * from tags',
        mapper: (Map<String, Object?> row) =>
            Tag(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<void> insertTag(Tag tag) async {
    await _tagInsertionAdapter.insert(tag, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTag(Tag tag) async {
    await _tagDeletionAdapter.delete(tag);
  }
}
