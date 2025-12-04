import 'package:drift/drift.dart';

import 'drift_db.dart';
import 'tables.dart';

part 'student_dao.g.dart';

@DriftAccessor(tables: [Students])
class StudentDao extends DatabaseAccessor<AppDatabase> with _$StudentDaoMixin {
  StudentDao(super.db);

  // Получаем список всех студентов
  Future<List<Student>> getStudents() async {
    return await select(students).get();
  }

  // Создаем нового студента и добавляем его в группу
  // с идентификатором groupId
  Future<int> addStudent(String fullName, int groupId) async {
    return await into(students).insert(
      StudentsCompanion.insert(
        fullName: fullName,
        groupId: groupId,
      ),
    );
  }
}
