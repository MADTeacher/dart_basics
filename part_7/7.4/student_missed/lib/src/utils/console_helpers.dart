import 'dart:convert';
import 'dart:io';

class ConsoleHelpers {
  // Инициализируем консоль для работы с UTF-8
  // Этот метод должен быть вызван самым первым в приложении
  static void initialize() {
    stdout.encoding = utf8;
  }

  // Очищаем экран консоли используя ANSI-коды
  static void clearScreen() {
    // ANSI escape codes для очистки экрана и перемещения курсора в начало
    // \x1B[2J - очистить экран
    // \x1B[3J - очистить буфер прокрутки (опционально)
    // \x1B[H - переместить курсор в позицию (0,0)
    stdout.write('\x1B[2J\x1B[H');
  }

  // Печатаем заголовок
  static void printHeader(String title) {
    final line = '═' * (title.length + 4);
    print('\n$line');
    print('  $title');
    print('$line\n');
  }

  // Печатаем подзаголовок
  static void printSubHeader(String title) {
    print('\n── $title ──\n');
  }

  // Печатаем сообщение об успехе
  static void printSuccess(String message) {
    print('[SUCCESS] $message');
  }

  // Печатаем сообщение об ошибке
  static void printError(String message) {
    print('[ERROR] $message');
  }

  // Печатаем информацию
  static void printInfo(String message) {
    print('[INFO] $message');
  }

  // Читаем строку из консоли
  static String? readLine(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync(encoding: utf8);
  }

  // Читаем число из консоли
  static int? readInt(String prompt) {
    final input = readLine(prompt);
    if (input == null || input.isEmpty) return null;
    return int.tryParse(input);
  }

  // Подтверждаем действие
  static bool confirm(String message) {
    final response = readLine('$message (y/n): ')?.toLowerCase();
    return response == 'y' ||
        response == 'yes' ||
        response == 'д' ||
        response == 'да';
  }

  // Выводим список с выбором
  static int? showSelectionList<T>(
    List<T> items,
    String Function(T) displayText, {
    String title = 'Выберите:',
    bool allowCancel = true,
  }) {
    if (items.isEmpty) {
      printInfo('Список пуст');
      return null;
    }

    print('\n$title');
    for (var i = 0; i < items.length; i++) {
      print('  ${i + 1}. ${displayText(items[i])}');
    }

    if (allowCancel) {
      print('  0. Отмена');
    }

    while (true) {
      final choice = readInt('\nВыбор: ');

      if (choice == null) {
        printError('Введите число');
        continue;
      }

      if (allowCancel && choice == 0) {
        return null;
      }

      if (choice < 1 || choice > items.length) {
        printError(
          'Неверный выбор. Введите число от ${allowCancel ? 0 : 1}'
          ' до ${items.length}',
        );
        continue;
      }

      return choice - 1;
    }
  }

  // Пауза перед продолжением
  static void pause([String message = '\nНажмите Enter для продолжения...']) {
    stdout.write(message);
    stdin.readLineSync();
  }
}
