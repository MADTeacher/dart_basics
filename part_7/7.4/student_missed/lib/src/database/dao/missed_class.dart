import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/missed_class.dart';
import '../tables/student.dart';

import '../models/academic_performance.dart';
import '../models/missed_info.dart';
import '../models/full_academic_performance.dart';

part 'missed_class.g.dart';

@DriftAccessor(tables: [MissedClasses, Students])
class MissedClassDao extends DatabaseAccessor<AppDatabase>
    with _$MissedClassDaoMixin {
  MissedClassDao(super.db);

  // Добавляем пропуски по студентам
  Future<void> addMissedRecords(
    List<int> missedStudentIds,
    int groupId,
    int disciplineId,
  ) async {
    final currentDate = DateTime.now();
    // Запрашиваем всех студентов группы
    final allStudents = await db.studentDao.getByGroupId(groupId);

    // Отмечаем отсутствующих и присутствующих студентов
    await batch((batch) {
      for (final student in allStudents) {
        final isMissed = missedStudentIds.contains(student.id);
        batch.insert(
          missedClasses,
          MissedClassesCompanion.insert(
            studentId: student.id,
            disciplineId: disciplineId,
            day: currentDate,
            isMissed: isMissed,
          ),
        );
      }
    });
  }

  // Добавляем пропуски для всех студентов группы
  Future<void> addAllRecords(
    int groupId,
    int disciplineId,
    bool isMissed,
  ) async {
    final currentDate = DateTime.now();
    final allStudents = await db.studentDao.getByGroupId(groupId);

    await batch((batch) {
      for (final student in allStudents) {
        batch.insert(
          missedClasses,
          MissedClassesCompanion.insert(
            studentId: student.id,
            disciplineId: disciplineId,
            day: currentDate,
            isMissed: isMissed,
          ),
        );
      }
    });
  }

  // Запрашиваем успеваемость студента по конкретной дисциплине
  Future<({String fullName, int missedCount, int totalCount})>
      getAcademicPerformance(int studentId, int disciplineId) async {
    // Запрашиваем студента по ID
    final student = await db.studentDao.getById(studentId);
    if (student == null) {
      return (fullName: '', missedCount: 0, totalCount: 0);
    }

    // Выражения для подсчета пропусков и общего количества занятий
    final missedCountExpr = missedClasses.isMissed.cast<int>().sum();
    final totalCountExpr = missedClasses.id.count();

    // Запрашиваем пропуски для студента по дисциплине
    final query = selectOnly(missedClasses)
      ..addColumns([missedCountExpr, totalCountExpr])
      ..where(
        missedClasses.studentId.equals(studentId) &
            missedClasses.disciplineId.equals(disciplineId),
      );

    // Получаем результат запроса
    final result = await query.getSingleOrNull();
    // Если студент не имеет пропусков, возвращаем 0
    if (result == null) {
      return (fullName: student.fullName, missedCount: 0, totalCount: 0);
    }

    // Получаем количество пропусков и общего количества занятий
    final missedCount = result.read(missedCountExpr) ?? 0;
    final totalCount = result.read(totalCountExpr) ?? 0;

    // Возвращаем результат
    return (
      fullName: student.fullName,
      missedCount: missedCount,
      totalCount: totalCount,
    );
  }

  // Подсчитываем пропуски для группы по дисциплине
  Future<({int totalClasses, List<AcademicPerformanceModel> performances})>
      countMissedClasses(int groupId, int disciplineId) async {
    // Выражения для подсчета пропусков и общего количества занятий
    final missedCountExpr = missedClasses.isMissed.cast<int>().sum();
    final totalCountExpr = missedClasses.id.count();

    // Запрашиваем студентов группы с пропусками и общего количества занятий
    final query = select(students).join([
      innerJoin(
        missedClasses,
        missedClasses.studentId.equalsExp(students.id),
      ),
    ])
      ..where(
        students.groupId.equals(groupId) &
            missedClasses.disciplineId.equals(disciplineId),
      )
      ..groupBy([students.fullName])
      ..orderBy([OrderingTerm.asc(students.fullName)])
      ..addColumns([missedCountExpr, totalCountExpr]);

    // Получаем результат запроса
    final results = await query.get();
    // Если студентов нет, возвращаем 0
    if (results.isEmpty) {
      return (totalClasses: 0, performances: <AcademicPerformanceModel>[]);
    }

    // Получаем успеваемость студентов
    final performances = results.map<AcademicPerformanceModel>((row) {
      final studentName = row.readTable(students).fullName;
      final missedCount = row.read(missedCountExpr) ?? 0;
      return AcademicPerformanceModel(
        studentName: studentName,
        numberOfPasses: missedCount,
      );
    }).toList();

    // Получаем общее количество занятий
    final totalClasses = results.first.read(totalCountExpr) ?? 0;

    // Возвращаем результат
    return (totalClasses: totalClasses, performances: performances);
  }

  // Запрашиваем полную информацию о пропусках с днями
  Future<List<FullAcademicPerformanceModel>> getMissedClassesWithDays(
    int groupId,
    int disciplineId,
  ) async {
    // Запрашиваем студентов группы с пропусками
    final query = select(students).join([
      innerJoin(
        missedClasses,
        missedClasses.studentId.equalsExp(students.id),
      ),
    ])
      ..where(
        students.groupId.equals(groupId) &
            missedClasses.disciplineId.equals(disciplineId),
      )
      ..orderBy([
        OrderingTerm.asc(students.fullName),
        OrderingTerm.asc(missedClasses.day),
      ]);

    // Получаем результат запроса
    final results = await query.get();
    // Если студентов нет, возвращаем пустой список
    if (results.isEmpty) {
      return <FullAcademicPerformanceModel>[];
    }

    // Группируем по студентам и собираем информацию о пропусках
    final Map<String, List<MissedInfoModel>> studentData = {};

    for (final row in results) {
      // Получаем имя студента и информацию о пропусках
      final studentName = row.readTable(students).fullName;
      final missedClass = row.readTable(missedClasses);
      // Если студент не встречался, добавляем его в список
      if (!studentData.containsKey(studentName)) {
        studentData[studentName] = [];
      }
      // Добавляем информацию о пропусках
      studentData[studentName]!.add(
        MissedInfoModel(
          isMissed: missedClass.isMissed,
          day: missedClass.day,
        ),
      );
    }

    // Возвращаем результат
    return studentData.entries
        .map(
          (entry) => FullAcademicPerformanceModel(
            studentName: entry.key,
            missedData: entry.value,
          ),
        )
        .toList();
  }
}
