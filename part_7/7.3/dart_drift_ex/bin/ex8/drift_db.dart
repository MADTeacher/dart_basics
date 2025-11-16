import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'group_dao.dart';
import 'student_dao.dart';
import 'tables.dart';

part 'drift_db.g.dart';

// @DriftDatabase - декоратор, указывающий на таблицы,
// которые будут использоваться в базе данных
@DriftDatabase(tables: [Groups, Students], daos: [StudentDao, GroupDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbPath) : super(_openConnection(dbPath));

  // Определяем версию схемы базы данных
  @override
  int get schemaVersion => 1;

  // Определяем стратегию миграции
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Статический метод для открытия подключения к базе данных
  static QueryExecutor _openConnection(String dbPath) {
    return NativeDatabase.createInBackground(File(dbPath));
  }
}

Future<void> main() async {
  final appDocumentsDir = Directory.current;
  final dbPath = path.join(appDocumentsDir.path, "dao.db");
  final db = AppDatabase(dbPath);

  // создаем группу и добавляем в нее студентов
  // через dao-объекты, доступ к которым появляется
  // через одноименные поля экземпляра класса AppDatabase
  final groupId = await db.groupDao.addGroup('4319');
  await db.studentDao.addStudent(
    'Иванов Иван Иванович',
    groupId,
  );
  await db.studentDao.addStudent(
    'Ветров Иван Алексеевич',
    groupId,
  );

  // Выводим список групп и студентов
  print(await db.groupDao.getGroups());
  print(await db.studentDao.getStudents());
  await db.close();
}
