import '../dao/discipline.dart';
import '../interfaces/i_discipline_dao.dart';
import '../models/discipline.dart';
import '../models/group.dart';

class DisciplineDaoAdapter implements IDisciplineDao {
  final DisciplineDao _dao;

  DisciplineDaoAdapter(this._dao);

  // Запрашиваем все дисциплины
  @override
  Future<List<DisciplineModel>> getAll() async {
    final disciplines = await _dao.getAll();
    return disciplines
        .map((d) => DisciplineModel(id: d.id, name: d.name))
        .toList();
  }

  // Запрашиваем дисциплину по ID
  @override
  Future<DisciplineModel?> getById(int id) async {
    final discipline = await _dao.getById(id);
    return discipline != null
        ? DisciplineModel(id: discipline.id, name: discipline.name)
        : null;
  }

  // Добавляем дисциплину
  @override
  Future<int> add(String name) => _dao.add(name);

  // Проверяем существование дисциплины
  @override
  Future<bool> exists(String name) => _dao.exists(name);

  // Удаляем дисциплину
  @override
  Future<void> deleteDiscipline(int id) => _dao.deleteDiscipline(id);

  // Запрашиваем группы, назначенные дисциплине
  @override
  Future<List<GroupModel>> getAssignedGroups(int disciplineId) async {
    final groups = await _dao.getAssignedGroups(disciplineId);
    return groups.map((g) => GroupModel(id: g.id, name: g.name)).toList();
  }
}
