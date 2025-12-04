import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Проверяет, существует ли колонка в таблице
Future<bool> columnExists(
    Database db, String tableName, String columnName) async {
  final result = await db.rawQuery(
    "PRAGMA table_info($tableName)",
  );
  return result.any((row) => row['name'] == columnName);
}

// Открываем базу данных с заданной версией схемы
Future<Database> openDatabase(String dbName, [int version = 1]) async {
  var databaseFactory = databaseFactoryFfi;
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных
  String dbPath = p.join(appDocumentsDir.path, "bin", dbName);
  return await databaseFactory.openDatabase(
    dbPath,
    options: OpenDatabaseOptions(
      version: version,
      onConfigure: (db) async {
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
          FOREIGN KEY (group_id) REFERENCES student_group(id) 
                                 ON DELETE CASCADE
          )""",
        );
      },
      // Выполняется увеличение версии базы данных
      onUpgrade: (db, oldVersion, newVersion) async {
        // Добавляем email, если переходим через версию 2
        // и колонка email не существует
        if (oldVersion < 2 && newVersion >= 2) {
          if (!await columnExists(db, 'student', 'email')) {
            var query = 'ALTER TABLE student ADD COLUMN email TEXT';
            await db.execute(query);
          }
          await db.update(
            'student',
            {'email': 'ivanov@ii.com'},
            where: 'full_name = ?',
            whereArgs: ['Иванов Иван Иванович'],
          );
        }
        // Добавляем phone, если переходим через версию 3
        // и колонка phone не существует
        if (oldVersion < 3 && newVersion >= 3) {
          if (!await columnExists(db, 'student', 'phone')) {
            var query = 'ALTER TABLE student ADD COLUMN phone TEXT';
            await db.execute(query);
          }
          await db.update(
            'student',
            {'phone': '+7(916)123-45-67'},
            where: 'full_name = ?',
            whereArgs: ['Иванов Иван Иванович'],
          );
        }
      },
      // Выполняется уменьшение версии базы данных
      onDowngrade: (db, oldVersion, newVersion) async {
        // Удаляем phone, если откатываемся ниже версии 3
        // и колонка phone существует
        if (oldVersion >= 3 && newVersion < 3) {
          if (await columnExists(db, 'student', 'phone')) {
            var query = 'ALTER TABLE student DROP COLUMN phone';
            await db.execute(query);
          }
        }
        // Удаляем email, если откатываемся ниже версии 2
        // и колонка email существует
        if (oldVersion >= 2 && newVersion < 2) {
          if (await columnExists(db, 'student', 'email')) {
            var query = 'ALTER TABLE student DROP COLUMN email';
            await db.execute(query);
          }
        }
      },
    ),
  );
}

Future<void> openAndPrintDatabase(String dbName, int version) async {
  final db = await openDatabase(dbName, version);
  final students = await db.query('student');
  print(students);
  await db.close();
}

void main() async {
  sqfliteFfiInit();
  print('Миграция базы данных с версии 1 на версию 3');
  await openAndPrintDatabase('myDb.db', 3);
  print('--------------------------------');

  print('Миграция базы данных с версии 3 на версию 1');
  await openAndPrintDatabase('myDb.db', 1);
}
