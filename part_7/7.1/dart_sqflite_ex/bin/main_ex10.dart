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

  var query =
      'SELECT student_group.name, COUNT(student.id) as student_count FROM student_group ';
  query += 'LEFT JOIN student ON student_group.id = student.group_id ';
  query += 'GROUP BY student_group.id';
  final rawQuery = await db.rawQuery(query);
  print('Чистый SQL-запрос:');
  print(rawQuery);
  print('--------------------------------');

  // Аналогичный запрос средствами метода query sqflite
  final students = await db.query(
    'student_group',
    columns: [
      'name',
      // Используем подзапрос для подсчета студентов в каждой группе
      '(SELECT COUNT(*) FROM student WHERE student.group_id = student_group.id) as student_count',
    ],
    groupBy: 'id',
  );
  print('Запрос средствами sqflite:');
  print(students);
  print('--------------------------------');
  await db.close();
}
