import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../interfaces/i_group_dao.dart';
import '../models/group.dart';
import '../models/discipline.dart';

class GroupDao implements IGroupDao {
  final Database _db;

  GroupDao(this._db);

  // Запрашиваем все группы
  @override
  Future<List<GroupModel>> getAll() async {
    final List<Map<String, dynamic>> maps = await _db.query('groups');
    return List.generate(maps.length, (i) {
      return GroupModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }

  // Запрашиваем группу по ID
  @override
  Future<GroupModel?> getById(int id) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'groups',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return GroupModel(
      id: maps[0]['id'] as int,
      name: maps[0]['name'] as String,
    );
  }

  // Добавляем группу
  @override
  Future<int> add(String name) async {
    return await _db.insert('groups', {'name': name});
  }

  // Проверяем существование группы
  @override
  Future<bool> exists(String name) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'groups',
      where: 'name = ?',
      whereArgs: [name],
    );
    return maps.isNotEmpty;
  }

  // Удаляем группу по ID
  @override
  Future<void> deleteGroup(int id) async {
    await _db.delete('groups', where: 'id = ?', whereArgs: [id]);
  }

  // Назначаем дисциплину группе
  @override
  Future<void> assignDiscipline(int groupId, int disciplineId) async {
    await _db.insert('group_disciplines', {
      'group_id': groupId,
      'discipline_id': disciplineId,
    });
  }

  // Запрашиваем группы без указанной дисциплины
  @override
  Future<List<GroupModel>> getGroupsWithoutDiscipline(int disciplineId) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery(
      '''
      SELECT g.id, g.name
      FROM groups g
      LEFT JOIN group_disciplines gd ON g.id = gd.group_id 
                                     AND gd.discipline_id = ?
      WHERE gd.discipline_id IS NULL
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

  // Запрашиваем дисциплины, назначенные группе
  @override
  Future<List<DisciplineModel>> getAssignedDisciplines(int groupId) async {
    final List<Map<String, dynamic>> maps = await _db.rawQuery(
      '''
      SELECT d.id, d.name
      FROM disciplines d
      INNER JOIN group_disciplines gd ON d.id = gd.discipline_id
      WHERE gd.group_id = ?
    ''',
      [groupId],
    );

    return List.generate(maps.length, (i) {
      return DisciplineModel(
        id: maps[i]['id'] as int,
        name: maps[i]['name'] as String,
      );
    });
  }
}
