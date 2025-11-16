import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/group.dart';
import 'tables/student.dart';
import 'tables/discipline.dart';
import 'tables/missed_class.dart';
import 'tables/group_discipline.dart';
import 'dao/group.dart';
import 'dao/student.dart';
import 'dao/discipline.dart';
import 'dao/missed_class.dart';

part 'drift_database.g.dart';

/// Drift база данных для CLI приложения
@DriftDatabase(
  tables: [Groups, Students, Disciplines, MissedClasses, GroupDisciplines],
  daos: [DisciplineDao, GroupDao, MissedClassDao, StudentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbPath) : super(_openConnection(dbPath));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      // Включаем поддержку внешних ключей при открытии существующей базы
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  static QueryExecutor _openConnection(String dbPath) {
    return NativeDatabase.createInBackground(File(dbPath));
  }
}
