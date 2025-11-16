import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Открываем базу данных с заданной версией схемы
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
          email TEXT,
          phone TEXT,
          FOREIGN KEY (group_id) REFERENCES student_group(id) 
                                 ON DELETE CASCADE
          )""",
        );

        int groupId = await db.insert('student_group', {'name': '4315'});

        await db.insert('student', {
          'full_name': 'Мартынов Сергей Иванович',
          'group_id': groupId,
          'email': 'martynov@si.com',
          'phone': '+7(916)123-45-67',
        });
        await db.insert('student', {
          'full_name': 'Петрова Анна Валерьевна',
          'group_id': groupId,
          'email': 'petrova@av.com',
          'phone': '+7(916)123-45-68',
        });
      },
    ),
  );
}

void printDatabase(Database db) async {
  print('Студенты:');
  final students = await db.query('student');
  print(students);
  print('\nГруппы:');
  final groups = await db.query('student_group');
  print(groups);
  print('--------------------------------');
}

void main() async {
  sqfliteFfiInit();
  final db = await openDatabase('myDb2.db');
  await db.close();
}
