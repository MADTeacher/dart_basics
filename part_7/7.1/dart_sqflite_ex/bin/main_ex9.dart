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
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Выполняется только при создании новой базы данных
      onCreate: (db, version) async {
        // Чтение SQL-скрипта из файла tables.sql, который содержит
        // определения таблиц и их связей для базы данных
        final tablesSqlFile = File(
          p.join(appDocumentsDir.path, 'bin', 'tables.sql'),
        );
        final sqlScript = await tablesSqlFile.readAsString();

        // Разбиваем скрипт на отдельные выражения и выполняем их
        final statements = sqlScript
            .split(';')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty);
        for (final statement in statements) {
          await db.execute(statement);
        }
      },
    ),
  );
}

void main() async {
  sqfliteFfiInit();

  final db = await openDatabase('myDb.db');

  var query = 'SELECT student.id, student.full_name, student_group.name FROM student ';
  query += 'INNER JOIN student_group ON student.group_id = student_group.id ';
  query += 'WHERE student_group.name LIKE ?';
  final rawQuery = await db.rawQuery(query, ['4319']);
  print('Чистый SQL-запрос:');
  print(rawQuery);
  print('--------------------------------');

  // Аналогичный запрос средствами метода query sqflite
  print('Запрос средствами sqflite:');
  final students = await db.query(
    'student',
    columns: [
      'id',
      'full_name',
      // Используем подзапрос для получения поля name из таблицы grstudent_group
      '(SELECT name FROM student_group WHERE id = student.group_id) as name',
    ],
    where: 'group_id IN (SELECT id FROM student_group WHERE name LIKE ?)',
    whereArgs: ['4319'],
  );
  print(students);
  print('--------------------------------');

  await db.close();
}
