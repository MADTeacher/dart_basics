import '../models/student.dart';

// DAO-интерфейс для работы со студентами
abstract interface  class IStudentDao {
  // Запрашиваем студентов по ID группы
  Future<List<StudentModel>> getByGroupId(int groupId);

  // Добавляем студента
  Future<int> add(int groupId, String fullName);

  // Удаляем студента
  Future<void> deleteStudent(int id);

  // Запрашиваем студента по ID
  Future<StudentModel?> getById(int id);
}
