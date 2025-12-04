import '../database/interfaces/i_database_provider.dart';
import '../utils/console_helpers.dart';
import 'command_helpers.dart';

// Команды для управления студентами
class StudentCommands {
  final IDatabaseProvider db;
  final CommandHelpers _helpers;

  StudentCommands({required this.db}) : _helpers = CommandHelpers(db: db);

  // Выводим список студентов группы
  Future<void> listStudents() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Студенты группы');

    final group = await _helpers.selectGroup();
    if (group == null) return;

    final students = await db.studentDao.getByGroupId(group.id);

    if (students.isEmpty) {
      ConsoleHelpers.printInfo('В группе "${group.name}" нет студентов');
      return;
    }

    print('\nСтуденты группы "${group.name}":');
    for (var i = 0; i < students.length; i++) {
      print('${i + 1}. ${students[i].fullName}');
    }
  }

  // Добавляем студента
  Future<void> addStudent() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Добавление студента');

    // Выбираем группу
    final group = await _helpers.selectGroup(
      emptyMessage: 'Сначала создайте группу',
    );
    if (group == null) return;

    // Вводим ФИО студента
    final fullName = ConsoleHelpers.readLine(
      'Введите ФИО студента (Фамилия Имя Отчество): ',
    );

    if (fullName == null || fullName.trim().isEmpty) {
      ConsoleHelpers.printError('ФИО не может быть пустым');
      return;
    }

    // Проверяем формат ФИО
    final regex = RegExp(r'^[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+$');
    if (!regex.hasMatch(fullName.trim())) {
      ConsoleHelpers.printError(
        'Неверный формат ФИО. Используйте: Фамилия Имя Отчество',
      );
      return;
    }

    try {
      await db.studentDao.add(group.id, fullName.trim());
      ConsoleHelpers.printSuccess(
        'Студент "${fullName.trim()}" добавлен в группу "${group.name}"',
      );
    } catch (e) {
      ConsoleHelpers.printError('Не удалось добавить студента: $e');
    }
  }

  // Удаляем студента
  Future<void> deleteStudent() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Удаление студента');

    // Выбираем группу
    final group = await _helpers.selectGroup();
    if (group == null) return;

    // Выбираем студента
    final student = await _helpers.selectStudentFromGroup(
      group.id,
      emptyMessage: 'В группе "${group.name}" нет студентов',
      title: 'Выберите студента для удаления:',
    );

    if (student == null) return;

    if (!ConsoleHelpers.confirm('Удалить студента "${student.fullName}"?')) {
      return;
    }

    try {
      await db.studentDao.deleteStudent(student.id);
      ConsoleHelpers.printSuccess('Студент "${student.fullName}" удален');
    } catch (e) {
      ConsoleHelpers.printError('Не удалось удалить студента: $e');
    }
  }
}
