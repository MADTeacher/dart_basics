import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/discipline.dart';
import '../tables/group_discipline.dart';
import '../tables/group.dart';

part 'discipline.g.dart';

@DriftAccessor(tables: [Disciplines, GroupDisciplines, Groups])
class DisciplineDao extends DatabaseAccessor<AppDatabase>
    with _$DisciplineDaoMixin {
  DisciplineDao(super.db);

  // Запрашиваем все дисциплины
  Future<List<Discipline>> getAll() async {
    return await select(disciplines).get();
  }

  // Запрашиваем дисциплину по ID
  Future<Discipline?> getById(int id) async {
    final query = select(disciplines)
      ..where(
        (tbl) => tbl.id.equals(id),
      );
    return await query.getSingleOrNull();
  }

  // Добавляем дисциплину
  Future<int> add(String name) async {
    return await into(
      disciplines,
    ).insert(DisciplinesCompanion.insert(name: name));
  }

  // Проверяем существование дисциплины с заданным именем
  Future<bool> exists(String name) async {
    final query = select(disciplines)
      ..where(
        (tbl) => tbl.name.equals(name),
      );
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // Удаляем дисциплину
  Future<void> deleteDiscipline(int id) async {
    await (delete(disciplines)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .go();
  }

  // Запрашиваем группы, у которых есть эта дисциплина
  Future<List<Group>> getAssignedGroups(int disciplineId) async {
    final query = select(groups).join([
      innerJoin(
        groupDisciplines,
        groupDisciplines.groupId.equalsExp(groups.id),
      ),
    ])
      ..where(
        groupDisciplines.disciplineId.equals(disciplineId),
      );

    final result = await query.get();
    return result.map((row) => row.readTable(groups)).toList();
  }
}
