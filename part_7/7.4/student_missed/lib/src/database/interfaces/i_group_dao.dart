import '../models/group.dart';
import '../models/discipline.dart';

// DAO-интерфейс для работы с группами
abstract interface  class IGroupDao {
  // Запрашиваем все группы
  Future<List<GroupModel>> getAll();

  // Запрашиваем группу по ID
  Future<GroupModel?> getById(int id);

  // Добавляем группу
  Future<int> add(String name);

  // Проверяем существование группы
  Future<bool> exists(String name);

  // Удаляем группу
  Future<void> deleteGroup(int id);

  // Назначаем дисциплину группе
  Future<void> assignDiscipline(int groupId, int disciplineId);

  // Запрашиваем группы без указанной дисциплины
  Future<List<GroupModel>> getGroupsWithoutDiscipline(int disciplineId);

  // Запрашиваем дисциплины, назначенные группе
  Future<List<DisciplineModel>> getAssignedDisciplines(int groupId);
}
