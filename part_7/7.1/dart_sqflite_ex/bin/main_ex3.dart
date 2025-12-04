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
  await db.execute(
    'INSERT INTO student_group (name) VALUES (?)', 
    ['Group 1'],
  );
  
  // Получаем id группы, где last_insert_rowid() 
  // возвращает ID последней вставленной записи
  final groupIdResult = await db.rawQuery('SELECT last_insert_rowid() as id');
  final groupId = groupIdResult.first['id'] as int;
  print('Группа создана с ID: $groupId');
  
  // Вставляем пару студентов в эту группу
  await db.execute(
    'INSERT INTO student (full_name, group_id) VALUES (?, ?)',
    ['Иванов Иван Иванович', groupId],
  );
  
  await db.execute(
    'INSERT INTO student (full_name, group_id) VALUES (?, ?)',
    ['Петрова Мария Сергеевна', groupId],
  );
  
  print('Добавлено 2 студента в группу с ID: $groupId');
  
  await db.close();
}
