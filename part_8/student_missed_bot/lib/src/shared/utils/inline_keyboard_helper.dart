import 'package:televerse/televerse.dart';

import '../../core/database/models/discipline.dart';
import '../../core/database/models/group.dart';

// Вспомогательный класс для создания inline-клавиатур
class InlineKeyboardBuilder {
  /// Метод для создания inline-клавиатуры для выбора группы из списка.
  ///
  /// Каждая группа отображается как отдельная кнопка в отдельной строке.
  /// При нажатии на кнопку отправляется callback с префиксом и ID группы.
  ///
  /// **Параметры:**
  /// - [groups] - Список групп, для которых нужно создать кнопки
  /// - [callbackPrefix] - Префикс для callback данных. К нему будет добавлен
  ///   символ подчеркивания и ID группы (например: "select_group_1")
  ///
  /// **Возвращает:**
  /// Объект [InlineKeyboard] с кнопками для каждой группы
  static InlineKeyboard createGroupButtons(
    List<GroupModel> groups,
    String callbackPrefix,
  ) {
    var keyboard = InlineKeyboard();
    for (final group in groups) {
      keyboard = keyboard
          .text(group.name, '${callbackPrefix}_${group.id}')
          .row();
    }
    return keyboard;
  }

  /// Метод для создания inline-клавиатуры для выбора дисциплины из списка.
  ///
  /// Каждая дисциплина отображается как отдельная кнопка в отдельной строке.
  /// При нажатии на кнопку отправляется callback с префиксом и ID дисциплины.
  ///
  /// **Параметры:**
  /// - [disciplines] - Список дисциплин, для которых нужно создать кнопки
  /// - [callbackPrefix] - Префикс для callback данных. К нему будет добавлен
  ///   символ подчеркивания и ID дисциплины (например: "select_discipline_5")
  ///
  /// **Возвращает:**
  /// Объект [InlineKeyboard] с кнопками для каждой дисциплины
  static InlineKeyboard createDisciplineButtons(
    List<DisciplineModel> disciplines,
    String callbackPrefix,
  ) {
    var keyboard = InlineKeyboard();
    for (final discipline in disciplines) {
      keyboard = keyboard
          .text(discipline.name, '${callbackPrefix}_${discipline.id}')
          .row();
    }
    return keyboard;
  }

  /// Метод для создания простой inline-клавиатуры из списка элементов любого типа.
  ///
  /// Универсальный метод, который позволяет создать клавиатуру для любого
  /// типа данных. Каждый элемент списка преобразуется в кнопку с помощью
  /// функций-билдеров для текста и callback данных.
  ///
  /// **Параметры:**
  /// - [items] - Список элементов любого типа [T], для которых создаются кнопки
  /// - [textBuilder] - Функция, которая принимает элемент типа [T] и возвращает
  ///   текст, который будет отображаться на кнопке
  /// - [dataBuilder] - Функция, которая принимает элемент типа [T] и возвращает
  ///   строку, которая будет отправлена как callback данные при нажатии на кнопку
  ///
  /// **Возвращает:**
  /// Объект [InlineKeyboard] с кнопками для каждого элемента списка
  static InlineKeyboard createSimpleList<T>({
    required List<T> items,
    required String Function(T) textBuilder,
    required String Function(T) dataBuilder,
  }) {
    var keyboard = InlineKeyboard();
    for (final item in items) {
      keyboard = keyboard.text(textBuilder(item), dataBuilder(item)).row();
    }
    return keyboard;
  }

  /// Метод для создания inline-клавиатуры с пагинацией для больших списков.
  ///
  /// Этот метод разбивает большой список элементов на страницы и добавляет
  /// навигационные кнопки (⬅ и ➡) для перехода между страницами.
  /// Полезно, когда список элементов слишком большой, чтобы показать все
  /// кнопки сразу (Telegram ограничивает количество кнопок в клавиатуре).
  ///
  /// **Параметры:**
  /// - [allItems] - Полный список всех элементов, которые нужно отобразить
  /// - [paginator] - Номер текущей страницы (начинается с 0). Например:
  ///   - 0 для первой страницы
  ///   - 1 для второй страницы
  ///   - и т.д.
  /// - [pageSize] - Количество элементов на одной странице
  /// - [textBuilder] - Функция для получения текста кнопки из элемента
  /// - [dataBuilder] - Функция для получения callback данных из элемента
  /// - [prevPageCallback] - Callback данные для кнопки "Назад" (⬅).
  ///   Должны содержать информацию о предыдущей странице
  /// - [nextPageCallback] - Callback данные для кнопки "Вперед" (➡).
  ///   Должны содержать информацию о следующей странице
  ///
  /// **Возвращает:**
  /// Объект [InlineKeyboard] с элементами текущей страницы и навигационными
  /// кнопками (если есть предыдущая или следующая страница)
  /// 
  /// **Примечание:**
  /// Навигационные кнопки отображаются только если есть предыдущая или
  /// следующая страница. Если есть обе, они размещаются в одной строке.
  static InlineKeyboard createPaginatedList<T>({
    required List<T> allItems,
    required int paginator,
    required int pageSize,
    required String Function(T) textBuilder,
    required String Function(T) dataBuilder,
    required String prevPageCallback,
    required String nextPageCallback,
  }) {
    // Вычисляем индексы для текущей страницы
    final startIndex = paginator * pageSize;
    final endIndex = (paginator + 1) * pageSize;
    
    // Получаем элементы только для текущей страницы
    final pageItems = allItems.sublist(
      startIndex,
      endIndex > allItems.length ? allItems.length : endIndex,
    );

    var keyboard = InlineKeyboard();

    // Добавляем элементы текущей страницы
    for (final item in pageItems) {
      keyboard = keyboard.text(textBuilder(item), dataBuilder(item)).row();
    }

    // Проверяем наличие предыдущей и следующей страниц
    final hasNext = allItems.length > (paginator + 1) * pageSize;
    final hasPrev = paginator > 0;

    // Добавляем навигационные кнопки, если они нужны
    if (hasPrev || hasNext) {
      if (hasPrev) {
        keyboard = keyboard.text('⬅', prevPageCallback);
      }
      if (hasNext) {
        keyboard = keyboard.text('➡', nextPageCallback);
      }
      keyboard = keyboard.row();
    }

    return keyboard;
  }
}
