import 'package:televerse/televerse.dart';

/// Вспомогательный класс для создания inline клавиатур
class InlineKeyboardHelper {
  /// Создать простую inline клавиатуру из списка элементов
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

  /// Создать inline клавиатуру с пагинацией
  static InlineKeyboard createPaginatedList<T>({
    required List<T> allItems,
    required int paginator,
    required int pageSize,
    required String Function(T) textBuilder,
    required String Function(T) dataBuilder,
    required String prevPageCallback,
    required String nextPageCallback,
  }) {
    final startIndex = paginator * pageSize;
    final endIndex = (paginator + 1) * pageSize;
    final pageItems = allItems.sublist(
      startIndex,
      endIndex > allItems.length ? allItems.length : endIndex,
    );

    var keyboard = InlineKeyboard();

    // Добавляем элементы страницы
    for (final item in pageItems) {
      keyboard = keyboard.text(textBuilder(item), dataBuilder(item)).row();
    }

    // Добавляем навигационные кнопки
    final hasNext = allItems.length > (paginator + 1) * pageSize;
    final hasPrev = paginator > 0;

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
