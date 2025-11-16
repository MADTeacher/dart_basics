import 'package:drift/drift.dart';
import 'group.dart';
import 'discipline.dart';

// Таблица связи групп и дисциплин (many-to-many)
class GroupDisciplines extends Table {
  IntColumn get groupId => integer().references(Groups, #id)();
  IntColumn get disciplineId => integer().references(Disciplines, #id)();

  @override
  Set<Column> get primaryKey => {groupId, disciplineId};
}
