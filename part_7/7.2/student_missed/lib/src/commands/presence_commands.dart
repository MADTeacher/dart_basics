import '../database/interfaces/i_database_provider.dart';
import '../utils/console_helpers.dart';
import 'command_helpers.dart';

// Команды для проверки присутствия
class PresenceCommands {
  final IDatabaseProvider db;
  final CommandHelpers _helpers;

  PresenceCommands({required this.db}) : _helpers = CommandHelpers(db: db);

  // Проверяем присутствие студентов
  Future<void> checkPresence() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Проверка присутствия');

    // Выбираем дисциплину
    final discipline = await _helpers.selectDiscipline();
    if (discipline == null) return;

    // Выбираем группу с этой дисциплиной
    final group = await _helpers.selectGroupWithDiscipline(
      discipline.id,
      emptyMessage: 'Нет групп с дисциплиной "${discipline.name}"',
    );
    if (group == null) return;

    // Получаем студентов
    final students = await db.studentDao.getByGroupId(group.id);

    if (students.isEmpty) {
      ConsoleHelpers.printInfo('В группе "${group.name}" нет студентов');
      return;
    }

    // Выводим информацию о группе, дисциплине и студентах
    print('\nГруппа: ${group.name}');
    print('Дисциплина: ${discipline.name}');
    print('Студентов в группе: ${students.length}');

    // Сначала выбираем способ отметки присутствия
    print('\nВыберите способ отметки присутствия:');
    print('1. Все присутствуют');
    print('2. Все отсутствуют');
    print('3. Провести перекличку (отметить вручную)');
    print('0. Отмена');

    final choice = ConsoleHelpers.readInt('\nВыбор: ');

    try {
      switch (choice) {
        case 1:
          // Все присутствуют
          await db.missedClassDao.addAllRecords(
            group.id,
            discipline.id,
            false,
          );
          ConsoleHelpers.printSuccess(
            'Все студенты отмечены как присутствующие',
          );
          break;

        case 2:
          // Все отсутствуют
          await db.missedClassDao.addAllRecords(
            group.id,
            discipline.id,
            true,
          );
          ConsoleHelpers.printSuccess(
            'Все студенты отмечены как отсутствующие',
          );
          break;

        case 3:
          // Перекличка
          print('\nОтметьте отсутствующих студентов:');
          final missedStudentIds = <int>[];

          for (var i = 0; i < students.length; i++) {
            final student = students[i];
            final response = ConsoleHelpers.readLine(
              '${i + 1}. ${student.fullName} (отсутствует? y/n): ',
            )?.toLowerCase();

            if (response == 'y' ||
                response == 'yes' ||
                response == 'д' ||
                response == 'да') {
              missedStudentIds.add(student.id);
            }
          }

          // Сохраняем результаты переклички
          await db.missedClassDao.addMissedRecords(
            missedStudentIds,
            group.id,
            discipline.id,
          );
          ConsoleHelpers.printSuccess(
            'Отмечено отсутствующих: ${missedStudentIds.length}, '
            'присутствующих: ${students.length - missedStudentIds.length}',
          );
          break;

        case 0:
          ConsoleHelpers.printInfo('Отменено');
          return;

        default:
          ConsoleHelpers.printError('Неверный выбор');
      }
    } catch (e) {
      ConsoleHelpers.printError('Не удалось сохранить данные: $e');
    }
  }
}
