import '../dao/student.dart';
import '../interfaces/i_student_dao.dart';
import '../models/student.dart';

class StudentDaoAdapter implements IStudentDao {
  final StudentDao _dao;

  StudentDaoAdapter(this._dao);

  // Запрашиваем студентов группы
  @override
  Future<List<StudentModel>> getByGroupId(int groupId) async {
    final students = await _dao.getByGroupId(groupId);
    return students
        .map(
          (s) => StudentModel(
            id: s.id,
            fullName: s.fullName,
            groupId: s.groupId,
          ),
        )
        .toList();
  }

  // Добавляем студента
  @override
  Future<int> add(int groupId, String fullName) async {
    return await _dao.add(groupId, fullName);
  }

  // Удаляем студента
  @override
  Future<void> deleteStudent(int id) => _dao.deleteStudent(id);

  // Запрашиваем студента по ID
  @override
  Future<StudentModel?> getById(int id) async {
    final student = await _dao.getById(id);
    return student != null
        ? StudentModel(
            id: student.id,
            fullName: student.fullName,
            groupId: student.groupId,
          )
        : null;
  }
}
