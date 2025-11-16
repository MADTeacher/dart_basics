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
  
  // Добавляем группу в таблицу БД
  // insert() возвращает ID последней вставленной записи
  int groupId = await db.insert('student_group', {'name': 'Group 2'});
  print('Группа создана с ID: $groupId');

  int studentId = await db.insert('student', {
    'full_name': 'Мартынов Сергей Иванович',
    'group_id': groupId,
  });
  print('Студент создан с ID: $studentId');
  studentId = await db.insert('student', {
    'full_name': 'Петрова Анна Валерьевна',
    'group_id': groupId,
  });
  print('Студент создан с ID: $studentId');

  await db.close();
}
