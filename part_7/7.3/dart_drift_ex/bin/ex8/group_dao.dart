import 'package:drift/drift.dart';

import 'drift_db.dart';
import 'tables.dart';

part 'group_dao.g.dart';

@DriftAccessor(tables: [Groups]) // указываем зависимости от таблиц
class GroupDao extends DatabaseAccessor<AppDatabase> with _$GroupDaoMixin {
  GroupDao(super.db);
  // Получаем список групп
  Future<List<Group>> getGroups() async {
    return await select(groups).get();
  }

  // Создаем новую группу
  Future<int> addGroup(String name) async {
    return await into(groups).insert(
      GroupsCompanion.insert(name: name),
    );
  }
}
