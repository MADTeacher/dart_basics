import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'drift_db.g.dart';

// Таблица групп студентов
class Groups extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()
      .withLength(
        min: 1,
        max: 15,
      )
      .unique()();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Таблица студентов
class Students extends Table {
  IntColumn get id => integer()();
  TextColumn get fullName => text().withLength(min: 1, max: 50)();
  IntColumn get groupId => integer().references(
        Groups,
        #id,
        onDelete: KeyAction.cascade,
      )();

  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

// @DriftDatabase - декоратор, указывающий на таблицы,
// которые будут использоваться в базе данных
@DriftDatabase(tables: [Groups, Students])
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

        int groupId = await into(groups).insert(
          GroupsCompanion.insert(name: '4315'),
        );
        await into(students).insert(StudentsCompanion.insert(
          fullName: 'Мартынов Сергей Иванович',
          groupId: groupId,
          email: Value('martynov@si.com'),
          phone: Value('+7(916)123-45-67'),
        ));
        await into(students).insert(StudentsCompanion.insert(
          fullName: 'Петрова Анна Валерьевна',
          groupId: groupId,
          email: Value('petrova@av.com'),
          phone: Value('+7(916)123-45-68'),
        ));
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

Future<void> printDatabase(AppDatabase db) async {
  print('Студенты:');
  final students = await db.select(db.students).get();
  print(students);
  print('\nГруппы:');
  final groups = await db.select(db.groups).get();
  print(groups);
  print('--------------------------------');
}

Future<void> main() async {
  final appDocumentsDir = Directory.current;
  final dbPath = path.join(appDocumentsDir.path, "trans_ex.db");
  final db = AppDatabase(dbPath);
  try {
    // стартуем транзакцию
    await db.transaction(() async {
      // вставляем новую группу
      int groupId = await db.into(db.groups).insert(
            GroupsCompanion.insert(name: '4325'),
          );
      // вставляем нового студента
      await db.into(db.students).insert(StudentsCompanion.insert(
          fullName: 'Кузнецов Сергей Сергеевич',
          groupId: groupId,
          email: Value('kuznetsov@ss.com')));
      // вставляем нового студента
      await db.into(db.students).insert(StudentsCompanion.insert(
          fullName: 'Сергеев Сергей Сергеевич',
          groupId: groupId,
          phone: Value('+7(916)123-45-68')));
      print('Состояние БД в ходе транзакции:');
      print('Студенты:');
      final students = await db.select(db.students).get();
      print(students);
      print('\nГруппы:');
      final groups = await db.select(db.groups).get();
      print(groups);
      // делаем rollback
      throw Exception('test');
    });
  } catch (e, st) {
    // сработал rollback
    print([e, st]);
  }
  print('Состояние БД после транзакции:');
  await printDatabase(db);
  await db.close();
}

void main2() async {
  final appDocumentsDir = Directory.current;
  final dbPath = path.join(appDocumentsDir.path, "trans_ex.db");

  final db = AppDatabase(dbPath);
  try {
    await db.transaction(() async {
      // вставляем новую группу
      int groupId = await db.into(db.groups).insert(
            GroupsCompanion.insert(name: '4316'),
          );
      // вставляем нового студента
      await db.into(db.students).insert(StudentsCompanion.insert(
          fullName: 'Иванов Иван Иванович',
          groupId: groupId,
          email: Value('ivanov@ii.com')));
      // вставляем нового студента
      await db.into(db.students).insert(StudentsCompanion.insert(
          fullName: 'Петрова Анна Валерьевна',
          groupId: groupId,
          phone: Value('+7(916)123-45-68')));
    });
  } catch (e) {
    print(e);
  }

  await printDatabase(db);
  await db.close();
}
