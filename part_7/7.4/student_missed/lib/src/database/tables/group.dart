import 'package:drift/drift.dart';

// Таблица групп студентов
class Groups extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text().withLength(min: 1, max: 15)();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}
