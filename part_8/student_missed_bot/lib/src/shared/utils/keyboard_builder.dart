import 'package:televerse/televerse.dart';
import '../../core/database/models/group.dart';
import '../../core/database/models/discipline.dart';

/// Утилиты для создания inline клавиатур
class KeyboardBuilder {
  /// Создать inline клавиатуру с группами
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

  /// Создать inline клавиатуру с дисциплинами
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

  /// Создать ReplyKeyboard для главного меню
  static Keyboard createMainMenuKeyboard() {
    return Keyboard()
        .text('Проверка присутствия')
        .row()
        .text('Краткий отчет')
        .text('Полный отчет')
        .row()
        .text('Интерактивный отчет')
        .resized();
  }
}
