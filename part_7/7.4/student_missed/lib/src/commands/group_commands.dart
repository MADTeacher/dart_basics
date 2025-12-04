import '../database/models/group.dart';
import 'base_commands.dart';

// Команды для управления группами
class GroupCommands extends BaseCommands<GroupModel> {
  GroupCommands({required super.db});

  // Получаем все группы
  @override
  Future<List<GroupModel>> getAllItems() => db.groupDao.getAll();

  // Получаем имя группы
  @override
  String getItemName(GroupModel item) => item.name;

  // Получаем ID группы
  @override
  int getItemId(GroupModel item) => item.id;

  // Проверяем существование группы
  @override
  Future<bool> itemExists(String name) => db.groupDao.exists(name);

  // Добавляем группу
  @override
  Future<void> addItem(String name) => db.groupDao.add(name);

  // Удаляем группу
  @override
  Future<void> deleteItem(int id) => db.groupDao.deleteGroup(id);

  // Получаем название сущности в единственном числе
  @override
  String getEntityNameSingle() => 'группу';

  // Получаем название сущности во множественном числе
  @override
  String getEntityNamePlural() => 'группы';

  // Получаем форму глагола "добавлен/добавлена"
  @override
  String getAddedForm() => 'добавлена';

  // Получаем форму глагола "удален/удалена"
  @override
  String getDeletedForm() => 'удалена';

  // Выводим список всех групп
  Future<void> listGroups() => listItems();

  // Добавляем новую группу
  Future<void> addGroup() => addItemCommand();

  // Удаляем группу
  Future<void> deleteGroup() => deleteItemCommand();
}
