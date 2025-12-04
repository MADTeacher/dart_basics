import '../models/academic_performance.dart';
import '../models/full_academic_performance.dart';

// DAO-интерфейс для работы с пропусками
abstract interface class IMissedClassDao {
  // Добавляем записи о пропусках для выбранных студентов
  Future<void> addMissedRecords(
    List<int> missedStudentIds,
    int groupId,
    int disciplineId,
  );

  // Добавляем записи для всех студентов группы
  Future<void> addAllRecords(int groupId, int disciplineId, bool isMissed);

  // Запрашиваем успеваемость студента по дисциплине
  Future<({String fullName, int missedCount, int totalCount})>
  getAcademicPerformance(int studentId, int disciplineId);

  // Подсчитываем пропуски для группы по дисциплине
  Future<({int totalClasses, List<AcademicPerformanceModel> performances})>
  countMissedClasses(int groupId, int disciplineId);

  // Запрашиваем полную информацию о пропусках с днями
  Future<List<FullAcademicPerformanceModel>> getMissedClassesWithDays(
    int groupId,
    int disciplineId,
  );
}
