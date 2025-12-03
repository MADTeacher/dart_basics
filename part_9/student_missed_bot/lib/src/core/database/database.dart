import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'interfaces/i_database_provider.dart';
import 'interfaces/i_group_dao.dart';
import 'interfaces/i_student_dao.dart';
import 'interfaces/i_discipline_dao.dart';
import 'interfaces/i_missed_class_dao.dart';
import 'dao/group.dart';
import 'dao/student.dart';
import 'dao/discipline.dart';
import 'dao/missed_class.dart';

class SqliteDatabase implements IDatabaseProvider {
  final Database _db;
  late final GroupDao _groupDao;
  late final StudentDao _studentDao;
  late final DisciplineDao _disciplineDao;
  late final MissedClassDao _missedClassDao;

  // Приватный конструктор для создания экземпляра базы данных
  SqliteDatabase._(this._db) {
    _groupDao = GroupDao(_db);
    _studentDao = StudentDao(_db);
    _disciplineDao = DisciplineDao(_db);
    _missedClassDao = MissedClassDao(_db);
  }

  static Future<SqliteDatabase> create(String dbPath) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final db = await openDatabase(
      dbPath,
      version: 1,
      // Конфигурируем базу данных при открытии соединения
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // Создаем таблицы
        await db.execute('''
          CREATE TABLE groups (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY,
            full_name TEXT NOT NULL,
            group_id INTEGER NOT NULL,
            FOREIGN KEY (group_id) REFERENCES groups (id) 
                                   ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE disciplines (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL UNIQUE
          )
        ''');

        await db.execute('''
          CREATE TABLE missed_classes (
            id INTEGER PRIMARY KEY,
            student_id INTEGER NOT NULL,
            discipline_id INTEGER NOT NULL,
            day DATETIME NOT NULL,
            is_missed BOOLEAN NOT NULL,
            FOREIGN KEY (student_id) REFERENCES students (id) 
                                     ON DELETE CASCADE,
            FOREIGN KEY (discipline_id) REFERENCES disciplines (id) 
                                        ON DELETE CASCADE
          )
        ''');

        await db.execute('''
          CREATE TABLE group_disciplines (
            group_id INTEGER NOT NULL,
            discipline_id INTEGER NOT NULL,
            PRIMARY KEY (group_id, discipline_id),
            FOREIGN KEY (group_id) REFERENCES groups (id) 
                                   ON DELETE CASCADE,
            FOREIGN KEY (discipline_id) REFERENCES disciplines (id) 
                                        ON DELETE CASCADE
          )
        ''');
      },
    );

    // Возвращаем экземпляр базы данных
    return SqliteDatabase._(db);
  }

  // Возвращаем DAO для работы с группами
  @override
  IGroupDao get groupDao => _groupDao;

  // Возвращаем DAO для работы со студентами
  @override
  IStudentDao get studentDao => _studentDao;

  // Возвращаем DAO для работы с дисциплинами
  @override
  IDisciplineDao get disciplineDao => _disciplineDao;

  // Возвращаем DAO для работы с пропусками
  @override
  IMissedClassDao get missedClassDao => _missedClassDao;

  // Закрываем соединение с базой данных
  @override
  Future<void> close() async {
    await _db.close();
  }
}
