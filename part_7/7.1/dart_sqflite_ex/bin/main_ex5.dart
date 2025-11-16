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
  
  // Создаем экземпляр модели Group и добавляем его в таблицу БД
  final group = Group(id: 0, name: '4319');

  int groupId = await db.insert('student_group', group.toDbMap());
  print('Группа создана с ID: $groupId');

  // Создаем экземпляры моделей Student
  final student1 = Student(
    id: 0,
    fullName: 'Мурашев Сергей Сергеевич',
    groupId: groupId,
  );
  final student2 = Student(
    id: 0,
    fullName: 'Пимкина Анна Валерьевна',
    groupId: groupId,
  );

  // Добавляем студентов в таблицу БД используя метод toDbMap()
  int studentId = await db.insert('student', student1.toDbMap());
  print('Студент создан с ID: $studentId');
  
  studentId = await db.insert('student', student2.toDbMap());
  print('Студент создан с ID: $studentId');

  await db.close();
}
