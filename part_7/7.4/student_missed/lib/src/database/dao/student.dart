import 'package:drift/drift.dart';
import '../drift_database.dart';
import '../tables/student.dart';

part 'student.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(super.db);

  // Запрашиваем студентов группы
  Future<List<Student>> getByGroupId(int groupId) async {
    final query = select(students)
      ..where((tbl) => tbl.groupId.equals(groupId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.fullName)]);
    return await query.get();
  }

  // Добавляем студента
  Future<int> add(int groupId, String fullName) async {
    return await into(
      students,
    ).insert(StudentsCompanion.insert(
      fullName: fullName,
      groupId: groupId,
    ));
  }

  // Удаляем студента
  Future<void> deleteStudent(int id) async {
    await (delete(students)
          ..where(
            (tbl) => tbl.id.equals(id),
          ))
        .go();
  }

  // Запрашиваем студента по ID
  Future<Student?> getById(int id) async {
    final query = select(students)
      ..where(
        (tbl) => tbl.id.equals(id),
      );
    return await query.getSingleOrNull();
  }
}
