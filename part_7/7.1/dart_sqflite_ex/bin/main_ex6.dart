import 'package:path/path.dart' as p;
import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

final class Group {
  final int id;
  final String name;

  Group({required this.id, required this.name});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  // Метод для преобразования в формат БД (без id для вставки)
  Map<String, dynamic> toDbMap() {
    return {'name': name};
  }

  @override
  String toString() {
    return 'Group(id: $id, name: $name)';
  }
}

final class Student {
  final int id;
  final String fullName;
  final int groupId;

  Student({required this.id, required this.fullName, required this.groupId});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      fullName: json['full_name'],
      groupId: json['group_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'fullName': fullName, 'groupId': groupId};
  }

  Map<String, dynamic> toDbMap() {
    return {'full_name': fullName, 'group_id': groupId};
  }

  @override
  String toString() {
    return 'Student(id: $id, fullName: $fullName, groupId: $groupId)';
  }
}

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
  
  // Извлекаем всех студентов из таблицы student
  // посредством sql-запроса
  final rawQuery = await db.rawQuery('SELECT * FROM student');
  print('Чистый SQL-запрос:');
  print(rawQuery);
  print('--------------------------------');

  // Извлекаем все группы из таблицы student_group
  // средствами sqflite
  print('Запрос средствами sqflite:');
  final students = await db.query('student');
  print(students);
  print('--------------------------------');
  
  // мэппим результаты запроса в список объектов Student
  final studentsList = students.map((e) => Student.fromJson(e)).toList();
  print(studentsList);
  print('--------------------------------');

  await db.close();
}
