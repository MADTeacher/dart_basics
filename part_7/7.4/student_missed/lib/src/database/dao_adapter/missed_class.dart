import '../dao/missed_class.dart';
import '../interfaces/i_missed_class_dao.dart';
import '../models/academic_performance.dart';
import '../models/missed_info.dart';
import '../models/full_academic_performance.dart';

class MissedClassDaoAdapter implements IMissedClassDao {
  final MissedClassDao _dao;

  MissedClassDaoAdapter(this._dao);

  // Добавляем пропуски по студентам
  @override
  Future<void> addMissedRecords(
    List<int> missedStudentIds,
    int groupId,
    int disciplineId,
  ) async {
    await _dao.addMissedRecords(
      missedStudentIds,
      groupId,
      disciplineId,
    );
  }

  // Добавляем пропуски для всех студентов группы
  @override
  Future<void> addAllRecords(
    int groupId,
    int disciplineId,
    bool isMissed,
  ) async {
    await _dao.addAllRecords(groupId, disciplineId, isMissed);
  }

  // Запрашиваем успеваемость студента по дисциплине
  @override
  Future<({String fullName, int missedCount, int totalCount})>
      getAcademicPerformance(int studentId, int disciplineId) =>
          _dao.getAcademicPerformance(studentId, disciplineId);

  // Подсчитываем пропуски для группы по дисциплине
  @override
  Future<({int totalClasses, List<AcademicPerformanceModel> performances})>
      countMissedClasses(int groupId, int disciplineId) async {
    final result = await _dao.countMissedClasses(groupId, disciplineId);

    final performances = result.performances
        .map(
          (p) => AcademicPerformanceModel(
            studentName: p.studentName,
            numberOfPasses: p.numberOfPasses,
          ),
        )
        .toList();

    return (totalClasses: result.totalClasses, performances: performances);
  }

  // Запрашиваем полную информацию о пропусках с днями
  @override
  Future<List<FullAcademicPerformanceModel>> getMissedClassesWithDays(
    int groupId,
    int disciplineId,
  ) async {
    final result = await _dao.getMissedClassesWithDays(
      groupId,
      disciplineId,
    );

    return result
        .map(
          (p) => FullAcademicPerformanceModel(
            studentName: p.studentName,
            missedData: p.missedData
                .map(
                  (m) => MissedInfoModel(
                    isMissed: m.isMissed,
                    day: m.day,
                  ),
                )
                .toList(),
          ),
        )
        .toList();
  }
}
