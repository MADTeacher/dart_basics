import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Открываем базу данных
Future<Database> openDatabase(String dbName) async {
  var databaseFactory = databaseFactoryFfi;
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных
  String dbPath = p.join(appDocumentsDir.path, "bin", dbName);
  return await databaseFactory.openDatabase(
    dbPath,
    options: OpenDatabaseOptions(
      version: 1,
      // Конфигурация базы данных. Выполняется каждый
      // раз при открытии базы данных
      onConfigure: (db) async {
        // Включаем поддержку внешних ключей
        // Это позволяет SQLite проверять ссылки на внешние ключи при
        // вставке, обновлении или удалении данных
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Выполняется только при создании новой базы данных
      onCreate: (db, version) async {
        await db.execute(
          """CREATE TABLE IF NOT EXISTS student_group (
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL
          )""",
        );
        await db.execute(
          """CREATE TABLE IF NOT EXISTS student (
          id INTEGER PRIMARY KEY, 
          full_name TEXT NOT NULL, 
          group_id INTEGER NOT NULL,
          FOREIGN KEY (group_id) REFERENCES student_group(id) ON DELETE CASCADE
          )""",
        );
      },
    ),
  );
}

void main() async {
  sqfliteFfiInit();

  final db = await openDatabase('myDb.db');
  print(db);
  await db.close();
}
