import '../database/models/discipline.dart';
import '../utils/console_helpers.dart';
import 'base_commands.dart';

// Класс для команд управления дисциплинами
class DisciplineCommands extends BaseCommands<DisciplineModel> {
  DisciplineCommands({required super.db});

  // Получаем все дисциплины
  @override
  Future<List<DisciplineModel>> getAllItems() => db.disciplineDao.getAll();

  // Получаем имя дисциплины
  @override
  String getItemName(DisciplineModel item) => item.name;

  // Получаем ID дисциплины
  @override
  int getItemId(DisciplineModel item) => item.id;

  // Проверяем существование дисциплины
  @override
  Future<bool> itemExists(String name) => db.disciplineDao.exists(name);

  // Добавляем дисциплину
  @override
  Future<void> addItem(String name) => db.disciplineDao.add(name);

  // Удаляем дисциплину
  @override
  Future<void> deleteItem(int id) => db.disciplineDao.deleteDiscipline(id);

  // Получаем название сущности в единственном числе
  @override
  String getEntityNameSingle() => 'дисциплину';

  // Получаем название сущности во множественном числе
  @override
  String getEntityNamePlural() => 'дисциплины';

  // Получаем форму глагола "добавлен/добавлена"
  @override
  String getAddedForm() => 'добавлена';

  // Получаем форму глагола "удален/удалена"
  @override
  String getDeletedForm() => 'удалена';
  
  // Выводим список всех дисциплин
  Future<void> listDisciplines() => listItems();

  // Добавляем новую дисциплину
  Future<void> addDiscipline() => addItemCommand();

  // Удаляем дисциплину
  Future<void> deleteDiscipline() => deleteItemCommand();

  // Привязываем дисциплину к группе
  Future<void> assignToGroup() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Привязка дисциплины к группе');

    // Предлагаем выбрать дисциплину
    final discipline = await selectItem(
      emptyMessage: 'Дисциплины отсутствуют',
      title: 'Выберите дисциплину:',
    );

    if (discipline == null) return;

    // Запрашиваем группы без этой дисциплины
    final groups = await db.groupDao.getGroupsWithoutDiscipline(discipline.id);

    if (groups.isEmpty) {
      ConsoleHelpers.printInfo(
        'Все группы уже имеют дисциплину "${discipline.name}"',
      );
      return;
    }

    // Предлагаем выбрать группу
    final groupIndex = ConsoleHelpers.showSelectionList(
      groups,
      (g) => g.name,
      title: 'Выберите группу:',
    );

    if (groupIndex == null) return;
    final group = groups[groupIndex];

    // Привязываем дисциплину к группе
    try {
      await db.groupDao.assignDiscipline(group.id, discipline.id);
      ConsoleHelpers.printSuccess(
        'Дисциплина "${discipline.name}" привязана к группе "${group.name}"',
      );
    } catch (e) {
      ConsoleHelpers.printError('Не удалось привязать дисциплину: $e');
    }
  }
}
