import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../interfaces/i_student_dao.dart';
import '../models/student.dart';

class StudentDao implements IStudentDao {
  final Database _db;

  StudentDao(this._db);

  // Запрашиваем студентов по ID группы
  @override
  Future<List<StudentModel>> getByGroupId(int groupId) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'students',
      where: 'group_id = ?',
      whereArgs: [groupId],
    );

    return List.generate(maps.length, (i) {
      return StudentModel(
        id: maps[i]['id'] as int,
        fullName: maps[i]['full_name'] as String,
        groupId: maps[i]['group_id'] as int,
      );
    });
  }

  // Добавляем студента в группу
  @override
  Future<int> add(int groupId, String fullName) async {
    return await _db.insert('students', {
      'group_id': groupId,
      'full_name': fullName,
    });
  }

  // Удаляем студента по ID
  @override
  Future<void> deleteStudent(int id) async {
    await _db.delete('students', where: 'id = ?', whereArgs: [id]);
  }

  // Запрашиваем студента по ID
  @override
  Future<StudentModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'students',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return StudentModel(
      id: maps[0]['id'] as int,
      fullName: maps[0]['full_name'] as String,
      groupId: maps[0]['group_id'] as int,
    );
  }
}
