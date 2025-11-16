import 'package:drift/drift.dart';

// Таблица дисциплин
class Disciplines extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(min: 1, max: 150)();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}
