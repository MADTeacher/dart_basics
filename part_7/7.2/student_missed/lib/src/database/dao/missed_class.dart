import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../interfaces/i_missed_class_dao.dart';
import '../models/academic_performance.dart';
import '../models/full_academic_performance.dart';
import '../models/missed_info.dart';

class MissedClassDao implements IMissedClassDao {
  final Database _db;

  MissedClassDao(this._db);

  // Добавляем пропуски по студентам
  @override
  Future<void> addMissedRecords(
    List<int> missedStudentIds,
    int groupId,
    int disciplineId,
  ) async {
    final now = DateTime.now();
    // Создаем batch для добавления пропусков
    final batch = _db.batch();

    // Запрашиваем всех студентов группы
    final List<Map<String, dynamic>> students = await _db.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );

    // Отмечаем отсутствующих и присутствующих студентов
    for (final student in students) {
      final studentId = student['id'] as int;
      final isMissed = missedStudentIds.contains(studentId);

      batch.insert('missed_classes', {
        'student_id': studentId,
        'discipline_id': disciplineId,
        // Сохраняем дату пропуска в формате ISO 8601
        // в виде строки
        'day': now.toIso8601String(),
        'is_missed': isMissed ? 1 : 0,
      });
    }
  
    // Выполняем batch
    await batch.commit(noResult: true);
  }

  // Добавляем пропуски для всех студентов группы
  @override
  Future<void> addAllRecords(
    int groupId,
    int disciplineId,
    bool isMissed,
  ) async {
    final now = DateTime.now();
    final batch = _db.batch();

    // Запрашиваем всех студентов группы
    final List<Map<String, dynamic>> students = await _db.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );

    for (final student in students) {
      final studentId = student['id'] as int;

      batch.insert('missed_classes', {
        'student_id': studentId,
        'discipline_id': disciplineId,
        'day': now.toIso8601String(),
        'is_missed': isMissed ? 1 : 0,
      });
    }

    await batch.commit(noResult: true);
  }

  // Запрашиваем успеваемость студента по конкретной дисциплине
  @override
  Future<({String fullName, int missedCount, int totalCount})>
      getAcademicPerformance(int studentId, int disciplineId) async {
    final List<Map<String, dynamic>> result = await _db.rawQuery(
      '''
      SELECT 
        s.full_name,
        SUM(CASE WHEN mc.is_missed = 1 THEN 1 ELSE 0 END) 
                                 as missed_count,
        COUNT(*) as total_count
      FROM students s
      LEFT JOIN missed_classes mc ON s.id = mc.student_id 
                                  AND mc.discipline_id = ?
      WHERE s.id = ?
      GROUP BY s.id
    ''',
      [disciplineId, studentId],
    );

    if (result.isEmpty) {
      throw Exception('Student not found');
    }

    final row = result[0];
    return (
      fullName: row['full_name'] as String,
      missedCount: row['missed_count'] as int? ?? 0,
      totalCount: row['total_count'] as int? ?? 0,
    );
  }

  // Подсчитываем пропуски для группы по дисциплине
  @override
  Future<({int totalClasses, List<AcademicPerformanceModel> performances})>
      countMissedClasses(int groupId, int disciplineId) async {
    // Запрашиваем общее количество занятий
    final List<Map<String, dynamic>> totalResult = await _db.rawQuery(
      '''
      SELECT COUNT(DISTINCT day) as total_classes
      FROM missed_classes mc
      JOIN students s ON mc.student_id = s.id
      WHERE s.group_id = ? AND mc.discipline_id = ?
    ''',
      [groupId, disciplineId],
    );
    final totalClasses = totalResult[0]['total_classes'] as int? ?? 0;

    // Запрашиваем пропуски по студентам
    final List<Map<String, dynamic>> performanceResult = await _db.rawQuery(
      '''
      SELECT 
        s.full_name as student_name,
        SUM(CASE WHEN mc.is_missed = 1 THEN 1 ELSE 0 END) 
            as number_of_passes
      FROM students s
      LEFT JOIN missed_classes mc ON s.id = mc.student_id 
                                  AND mc.discipline_id = ?
      WHERE s.group_id = ?
      GROUP BY s.id
      ORDER BY s.full_name
    ''',
      [disciplineId, groupId],
    );

    // Преобразуем результат в список моделей успеваемости
    final performances = performanceResult.map((row) {
      return AcademicPerformanceModel(
        studentName: row['student_name'] as String,
        numberOfPasses: row['number_of_passes'] as int? ?? 0,
      );
    }).toList();
    // Возвращаем результат: 
    // общее количество занятий и список моделей успеваемости
    return (totalClasses: totalClasses, performances: performances);
  }

  // Запрашиваем полную информацию о пропусках с днями
  @override
  Future<List<FullAcademicPerformanceModel>> getMissedClassesWithDays(
    int groupId,
    int disciplineId,
  ) async {
    // Запрашиваем полную информацию о пропусках с днями
    final List<Map<String, dynamic>> result = await _db.rawQuery(
      '''
      SELECT 
        s.id,
        s.full_name as student_name,
        mc.is_missed,
        mc.day
      FROM students s
      LEFT JOIN missed_classes mc ON s.id = mc.student_id 
                                  AND mc.discipline_id = ?
      WHERE s.group_id = ?
      ORDER BY s.full_name, mc.day
    ''',
      [disciplineId, groupId],
    );

    // Группируем результат по студентам
    final Map<int, FullAcademicPerformanceModel> studentMap = {};

    // Обрабатываем каждую строку результата
    for (final row in result) {
      // Получаем данные о студенте
      final studentId = row['id'] as int;
      final studentName = row['student_name'] as String;
      final isMissed =
          row['is_missed'] != null ? (row['is_missed'] as int) == 1 : false;
      final dayStr = row['day'] as String?;

      // Если студент еще не добавлен в Map, добавляем его
      if (!studentMap.containsKey(studentId)) {
        studentMap[studentId] = FullAcademicPerformanceModel(
          studentName: studentName,
          missedData: [],
        );
      }

      // Если дата пропуска не null, считаем этот день пропуском
      if (dayStr != null) {
        studentMap[studentId]!.missedData.add(
              MissedInfoModel(
                isMissed: isMissed,
                day: DateTime.parse(dayStr),
              ),
            );
      }
    }

    // Возвращаем список моделей полной успеваемости
    return studentMap.values.toList();
  }
}
