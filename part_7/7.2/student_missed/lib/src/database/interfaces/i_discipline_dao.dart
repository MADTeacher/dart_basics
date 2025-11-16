import '../models/discipline.dart';
import '../models/group.dart';

// DAO-интерфейс для работы с дисциплинами
abstract class IDisciplineDao {
  // Запрашиваем все дисциплины
  Future<List<DisciplineModel>> getAll();

  // Запрашиваем дисциплину по ID
  Future<DisciplineModel?> getById(int id);

  // Добавляем дисциплину
  Future<int> add(String name);

  // Проверяем существование дисциплины
  Future<bool> exists(String name);

  // Удаляем дисциплину
  Future<void> deleteDiscipline(int id);

  // Запрашиваем группы, назначенные дисциплине
  Future<List<GroupModel>> getAssignedGroups(int disciplineId);
}
