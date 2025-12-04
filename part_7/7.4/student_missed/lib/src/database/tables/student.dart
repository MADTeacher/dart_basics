import 'package:drift/drift.dart';
import 'group.dart';

// Таблица студентов
class Students extends Table {
  IntColumn get id => integer()();
  TextColumn get fullName => text().withLength(min: 1, max: 50)();
  // Связываем студента с группой
  IntColumn get groupId => integer().references(Groups, #id)();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}
