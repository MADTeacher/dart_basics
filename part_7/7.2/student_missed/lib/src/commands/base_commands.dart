import '../database/interfaces/i_database_provider.dart';
import '../utils/console_helpers.dart';

// Базовый класс для команд с общими CRUD операциями
abstract class BaseCommands<T> {
  final IDatabaseProvider db;

  BaseCommands({required this.db});

  // Получаем список всех сущностей типа T
  Future<List<T>> getAllItems();

  // Получаем имя сущности для отображения
  String getItemName(T item);

  // Получаем ID сущности
  int getItemId(T item);

  // Проверяем существование сущности по имени
  Future<bool> itemExists(String name);

  // Добавляем новую сущность
  Future<void> addItem(String name);

  // Удаляем сущность по ID
  Future<void> deleteItem(int id);

  // Получаем название сущности в единственном числе (для сообщений)
  String getEntityNameSingle();

  // Получаем название сущности во множественном числе (для сообщений)
  String getEntityNamePlural();

  // Получаем форму глагола "добавлен/добавлена" (по умолчанию "добавлен")
  String getAddedForm() => 'добавлен';

  // Получаем форму глагола "удален/удалена" (по умолчанию "удален")
  String getDeletedForm() => 'удален';

  // Выводим список всех сущностей
  Future<void> listItems() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Список ${getEntityNamePlural()}');

    final items = await getAllItems();

    if (items.isEmpty) {
      ConsoleHelpers.printInfo('${getEntityNamePlural()} отсутствуют');
      return;
    }

    for (var i = 0; i < items.length; i++) {
      print('${i + 1}. ${getItemName(items[i])}');
    }
  }

  // Добавляем новую сущность
  Future<void> addItemCommand() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Добавление ${getEntityNameSingle()}');

    final name = ConsoleHelpers.readLine(
      'Введите название ${getEntityNameSingle()}: ',
    );

    if (name == null || name.trim().isEmpty) {
      ConsoleHelpers.printError('Название не может быть пустым');
      return;
    }

    // Проверяем существование
    final exists = await itemExists(name.trim());
    if (exists) {
      ConsoleHelpers.printError(
        '${getEntityNameSingle()} "$name" уже существует',
      );
      return;
    }

    try {
      await addItem(name.trim());
      ConsoleHelpers.printSuccess(
        '${getEntityNameSingle()} "$name" успешно ${getAddedForm()}',
      );
    } catch (e) {
      ConsoleHelpers.printError(
        'Не удалось добавить ${getEntityNameSingle()}: $e',
      );
    }
  }

  // Удаляем сущность
  Future<void> deleteItemCommand() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Удаление ${getEntityNameSingle()}');

    final items = await getAllItems();

    if (items.isEmpty) {
      ConsoleHelpers.printInfo('${getEntityNamePlural()} отсутствуют');
      return;
    }

    final index = ConsoleHelpers.showSelectionList(
      items,
      getItemName,
      title: 'Выберите ${getEntityNameSingle()} для удаления:',
    );

    if (index == null) return;

    final item = items[index];

    if (!ConsoleHelpers.confirm(
      'Удалить ${getEntityNameSingle()} "${getItemName(item)}"?',
    )) {
      return;
    }

    try {
      await deleteItem(getItemId(item));
      ConsoleHelpers.printSuccess(
        '${getEntityNameSingle()} "${getItemName(item)}" ${getDeletedForm()}',
      );
    } catch (e) {
      ConsoleHelpers.printError(
        'Не удалось удалить ${getEntityNameSingle()}: $e',
      );
    }
  }

  // Выбираем элемент из списка с проверками
  Future<T?> selectItem({
    String? emptyMessage,
    String? title,
  }) async {
    final items = await getAllItems();

    if (items.isEmpty) {
      if (emptyMessage != null) {
        ConsoleHelpers.printInfo(emptyMessage);
      } else {
        ConsoleHelpers.printInfo('${getEntityNamePlural()} отсутствуют');
      }
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      items,
      getItemName,
      title: title ?? 'Выберите ${getEntityNameSingle()}:',
    );

    if (index == null) return null;
    return items[index];
  }
}

