import 'package:televerse/televerse.dart';

// Класс для создания reply клавиатур
class ReplyKeyboardBuilder {
  // Создаем reply клавиатуру для главного меню
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
