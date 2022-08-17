import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_migration_service/sqflite_migration_service.dart';

import '../app/app.locator.dart';
import '../app/app.logger.dart';

const String dbName = 'likeplay_database.sqlite';

class DatabaseService {
  final log = getLogger('DatabaseService');
  final _migrationService = locator<DatabaseMigrationService>();
  Database? _database;
  Database? get database => _database;

  Future initialise() async {
    log.i('database initialize');

    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);

    _database = await openDatabase(path, version: 1);

    // Apply migration on every start
    await _migrationService.runMigration(
      _database,
      migrationFiles: [
        '1_create_schema.sql',
      ],
      verbose: true,
    );
  }
}
