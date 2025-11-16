import 'dart:io';
import '../database/interfaces/i_database_provider.dart';
import '../utils/console_helpers.dart';
import '../commands/group_commands.dart';
import '../commands/discipline_commands.dart';
import '../commands/student_commands.dart';
import '../commands/presence_commands.dart';
import '../commands/report_commands.dart';

// Класс для главного меню приложения
class MainMenu {
  final IDatabaseProvider db;
  final String tempReportDir;

  MainMenu({required this.db, required this.tempReportDir});

  // Выводим главное меню
  Future<void> show() async {
    while (true) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printHeader('Главное меню');

      print('1. Управление группами');
      print('2. Управление дисциплинами');
      print('3. Управление студентами');
      print('4. Привязка дисциплин к группам');
      print('5. Проверка присутствия');
      print('6. Отчеты');
      print('0. Выход');

      final choice = ConsoleHelpers.readInt('\nВыбор: ');

      switch (choice) {
        case 1:
          await _showGroupMenu();
        case 2:
          await _showDisciplineMenu();
        case 3:
          await _showStudentMenu();
        case 4:
          await _assignDisciplineToGroup();
        case 5:
          await _checkPresence();
        case 6:
          await _showReportMenu();
        case 0:
          if (ConsoleHelpers.confirm('Вы уверены, что хотите выйти?')) {
            print('\nДо свидания!');
            exit(0);
          }
          break;
        default:
          ConsoleHelpers.printError('Неверный выбор');
          ConsoleHelpers.pause();
      }
    }
  }

  // Выводим меню управления группами
  Future<void> _showGroupMenu() async {
    final commands = GroupCommands(db: db);

    while (true) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printSubHeader('Управление группами');

      print('1. Показать все группы');
      print('2. Добавить группу');
      print('3. Удалить группу');
      print('0. Назад');

      final choice = ConsoleHelpers.readInt('\nВыбор: ');

      switch (choice) {
        case 1:
          await commands.listGroups();
          ConsoleHelpers.pause();
          break;
        case 2:
          await commands.addGroup();
          ConsoleHelpers.pause();
          break;
        case 3:
          await commands.deleteGroup();
          ConsoleHelpers.pause();
          break;
        case 0:
          return;
        default:
          ConsoleHelpers.printError('Неверный выбор');
          ConsoleHelpers.pause();
      }
    }
  }

  // Выводим меню управления дисциплинами
  Future<void> _showDisciplineMenu() async {
    final commands = DisciplineCommands(db: db);

    while (true) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printSubHeader('Управление дисциплинами');

      print('1. Показать все дисциплины');
      print('2. Добавить дисциплину');
      print('3. Удалить дисциплину');
      print('0. Назад');

      final choice = ConsoleHelpers.readInt('\nВыбор: ');

      switch (choice) {
        case 1:
          await commands.listDisciplines();
          ConsoleHelpers.pause();
          break;
        case 2:
          await commands.addDiscipline();
          ConsoleHelpers.pause();
          break;
        case 3:
          await commands.deleteDiscipline();
          ConsoleHelpers.pause();
          break;
        case 0:
          return;
        default:
          ConsoleHelpers.printError('Неверный выбор');
          ConsoleHelpers.pause();
      }
    }
  }

  // Выводим меню управления студентами
  Future<void> _showStudentMenu() async {
    final commands = StudentCommands(db: db);

    while (true) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printSubHeader('Управление студентами');

      print('1. Показать студентов группы');
      print('2. Добавить студента');
      print('3. Удалить студента');
      print('0. Назад');

      final choice = ConsoleHelpers.readInt('\nВыбор: ');

      switch (choice) {
        case 1:
          await commands.listStudents();
          ConsoleHelpers.pause();
          break;
        case 2:
          await commands.addStudent();
          ConsoleHelpers.pause();
          break;
        case 3:
          await commands.deleteStudent();
          ConsoleHelpers.pause();
          break;
        case 0:
          return;
        default:
          ConsoleHelpers.printError('Неверный выбор');
          ConsoleHelpers.pause();
      }
    }
  }

  // Привязываем дисциплину к группе
  Future<void> _assignDisciplineToGroup() async {
    final commands = DisciplineCommands(db: db);
    await commands.assignToGroup();
    ConsoleHelpers.pause();
  }

  // Проверяем присутствие студентов
  Future<void> _checkPresence() async {
    final commands = PresenceCommands(db: db);
    await commands.checkPresence();
    ConsoleHelpers.pause();
  }

  // Выводим меню для генерации отчетов
  Future<void> _showReportMenu() async {
    final commands = ReportCommands(db: db, tempReportDir: tempReportDir);

    while (true) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printSubHeader('Отчеты');

      print('1. Краткий отчет');
      print('2. Полный отчет');
      print('3. Интерактивный отчет');
      print('0. Назад');

      final choice = ConsoleHelpers.readInt('\nВыбор: ');

      switch (choice) {
        case 1:
          await commands.generateShortReport();
          ConsoleHelpers.pause();
          break;
        case 2:
          await commands.generateFullReport();
          ConsoleHelpers.pause();
          break;
        case 3:
          await commands.interactiveReport();
          ConsoleHelpers.pause();
          break;
        case 0:
          return;
        default:
          ConsoleHelpers.printError('Неверный выбор');
          ConsoleHelpers.pause();
      }
    }
  }
}
