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

  db.delete('student_group', where: 'name = "4319"');

  print('Список студентов:');
  // Выводим ФИО и имя группы
  var query = 'SELECT student.full_name, student_group.name as group_name FROM student ';
  query += 'INNER JOIN student_group ON student.group_id = student_group.id ';
  query += 'ORDER BY student_group.name';  
  final students = await db.rawQuery(query);
  
  print(students);
  await db.close();
}
