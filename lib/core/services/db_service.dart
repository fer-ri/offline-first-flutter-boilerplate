import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration/sqflite_migration.dart';

class DbService {
  static Database _instance;

  Future<Database> get instance async {
    _instance ??= await _open();

    return _instance;
  }

  List<String> get _init => [
    '''
      CREATE TABLE queues (
        uuid PRIMARY KEY,
        docUuid TEXT,
        docTable TEXT,
        operation TEXT,
        data TEXT,
        deviceUuid STRING,
        deviceModel STRING,
        createdAt TEXT,
        syncedAt TEXT
      )
    ''',
    '''
      CREATE TABLE posts (
        uuid PRIMARY KEY,
        title TEXT,
        publishedAt TEXT
      )
    ''',
  ];

  List<String> get _migrations => [];

  Future<Database> _open() async {
    final String path = await DbService.path;

    return await openDatabaseWithMigration(
      path,
      MigrationConfig(
        initializationScript: _init,
        migrationScripts: _migrations,
      ),
    );
  }

  static Future<String> get path async {
    final databasesPath = await getDatabasesPath();

    final path = join(databasesPath, 'offline_first.db');

    return path;
  }

  static Future<void> delete() async {
    await deleteDatabase(await DbService.path);
    await DbService().instance;
  }
}
