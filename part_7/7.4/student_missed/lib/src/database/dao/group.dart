import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/group.dart';
import '../tables/group_discipline.dart';
import '../tables/discipline.dart';

part 'group.g.dart';

@DriftAccessor(tables: [Groups, GroupDisciplines, Disciplines])
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);

  // Запрашиваем все группы
  Future<List<Group>> getAll() async {
    return await select(groups).get();
  }

  // Запрашиваем группу по ID
  Future<Group?> getById(int id) async {
    final query = select(groups)..where((tbl) => tbl.id.equals(id));
    return await query.getSingleOrNull();
  }

  // Добавляем группу
  Future<int> add(String name) async {
    return await into(groups).insert(GroupsCompanion.insert(name: name));
  }

  // Проверяем существование группы с заданным именем
  Future<bool> exists(String name) async {
    final query = select(groups)..where((tbl) => tbl.name.equals(name));
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // Удаляем группу
  Future<void> deleteGroup(int id) async {
    await (delete(groups)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Запрашиваем группы, у которых нет указанной дисциплины
  Future<List<Group>> getGroupsWithoutDiscipline(int disciplineId) async {
    final query = select(groups).join([
      leftOuterJoin(
        groupDisciplines,
        groupDisciplines.groupId.equalsExp(groups.id) &
            groupDisciplines.disciplineId.equals(disciplineId),
      ),
    ])..where(groupDisciplines.disciplineId.isNull());

    final result = await query.get();
    return result.map((row) => row.readTable(groups)).toList();
  }

  // Запрашиваем дисциплины, назначенные группе
  Future<List<Discipline>> getAssignedDisciplines(int groupId) async {
    final query = select(disciplines).join([
      innerJoin(
        groupDisciplines,
        groupDisciplines.disciplineId.equalsExp(disciplines.id),
      ),
    ])..where(groupDisciplines.groupId.equals(groupId));

    final result = await query.get();
    return result.map((row) => row.readTable(disciplines)).toList();
  }

  // Назначаем дисциплину группе
  Future<void> assignDiscipline(int groupId, int disciplineId) async {
    await into(groupDisciplines).insert(
      GroupDisciplinesCompanion.insert(
        groupId: groupId,
        disciplineId: disciplineId,
      ),
    );
  }
}
