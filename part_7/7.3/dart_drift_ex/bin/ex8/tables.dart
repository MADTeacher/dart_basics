import 'package:drift/drift.dart';

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

  @override
  Set<Column<Object>> get primaryKey => {id};
}