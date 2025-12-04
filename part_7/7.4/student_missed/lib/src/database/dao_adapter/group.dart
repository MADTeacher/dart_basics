import '../dao/group.dart';
import '../interfaces/i_group_dao.dart';
import '../models/discipline.dart';
import '../models/group.dart';

class GroupDaoAdapter implements IGroupDao {
  final GroupDao _dao;

  GroupDaoAdapter(this._dao);

  // Запрашиваем все группы
  @override
  Future<List<GroupModel>> getAll() async {
    final groups = await _dao.getAll();
    return groups
        .map(
          (g) => GroupModel(id: g.id, name: g.name),
        )
        .toList();
  }

  // Запрашиваем группу по ID
  @override
  Future<GroupModel?> getById(int id) async {
    final group = await _dao.getById(id);
    return group != null
        ? GroupModel(
            id: group.id,
            name: group.name,
          )
        : null;
  }

  // Добавляем группу
  @override
  Future<int> add(String name) => _dao.add(name);

  // Проверяем существование группы
  @override
  Future<bool> exists(String name) => _dao.exists(name);

  // Удаляем группу
  @override
  Future<void> deleteGroup(int id) => _dao.deleteGroup(id);

  // Назначаем дисциплину группе
  @override
  Future<void> assignDiscipline(int groupId, int disciplineId) =>
      _dao.assignDiscipline(groupId, disciplineId);

  // Запрашиваем группы без указанной дисциплины
  @override
  Future<List<GroupModel>> getGroupsWithoutDiscipline(int disciplineId) async {
    final groups = await _dao.getGroupsWithoutDiscipline(disciplineId);
    return groups.map(
          (g) => GroupModel(id: g.id, name: g.name),
        )
        .toList();
  }

  // Запрашиваем дисциплины, назначенные группе
  @override
  Future<List<DisciplineModel>> getAssignedDisciplines(int groupId) async {
    final disciplines = await _dao.getAssignedDisciplines(groupId);
    return disciplines
        .map((d) => DisciplineModel(id: d.id, name: d.name))
        .toList();
  }
}
