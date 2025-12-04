import 'package:drift/drift.dart';
import 'student.dart';
import 'discipline.dart';

// Таблица записей о посещаемости
class MissedClasses extends Table {
  IntColumn get id => integer()();
  // Связываем запись о пропуске с студентом  
  IntColumn get studentId => integer().references(Students, #id)();
  // Связываем запись о пропуске с дисциплиной
  IntColumn get disciplineId => integer().references(Disciplines, #id)();
  // Дата пропуска
  DateTimeColumn get day => dateTime()();
  // Флаг пропуска
  BoolColumn get isMissed => boolean()();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}
