import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../interfaces/i_discipline_dao.dart';
import '../models/discipline.dart';
import '../models/group.dart';

class DisciplineDao implements IDisciplineDao {
  final Database _db;

  DisciplineDao(this._db);

  // Запрашиваем все дисциплины
  @override
  Future<List<DisciplineModel>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('disciplines');
    return List.generate(maps.length, (i) {
      return DisciplineModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  // Запрашиваем дисциплину по ID
  @override
  Future<DisciplineModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'disciplines',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return DisciplineModel(
      id: maps[0]['id'] as int,
      name: maps[0]['name'] as String,
    );
  }

  // Добавляем дисциплину
  @override
  Future<int> add(String name) async {
    return await _db.insert('disciplines', {'name': name});
  }

  // Проверяем существование дисциплины
  @override
  Future<bool> exists(String name) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'disciplines',
      where: 'name = ?',
      whereArgs: [name],
    );
    return maps.isNotEmpty;
  }

  // Удаляем дисциплину по ID
  @override
  Future<void> deleteDiscipline(int id) async {
    await _db.delete('disciplines', where: 'id = ?', whereArgs: [id]);
  }

  // Запрашиваем группы, назначенные дисциплине
  @override
  Future<List<GroupModel>> getAssignedGroups(int disciplineId) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery(
      '''
      SELECT g.id, g.name
      FROM groups g
      INNER JOIN group_disciplines gd ON g.id = gd.group_id
      WHERE gd.discipline_id = ?
    ''',
      [disciplineId],
    );

    return List.generate(maps.length, (i) {
      return GroupModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }
}
