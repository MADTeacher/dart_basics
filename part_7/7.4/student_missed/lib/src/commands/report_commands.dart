import 'dart:io';
import '../database/interfaces/i_database_provider.dart';
import '../utils/console_helpers.dart';
import '../utils/report_builders.dart';
import 'command_helpers.dart';

// Команды для работы с отчетами
class ReportCommands {
  final IDatabaseProvider db;
  final String tempReportDir;
  final CommandHelpers _helpers;

  ReportCommands({required this.db, required this.tempReportDir})
      : _helpers = CommandHelpers(db: db);

  // Генерируем краткий отчет
  Future<void> generateShortReport() async {
    await _generateReport(isShort: true);
  }

  // Генерируем полный отчет
  Future<void> generateFullReport() async {
    await _generateReport(isShort: false);
  }

  // Общая логика генерации отчета
  Future<void> _generateReport({required bool isShort}) async {
    ConsoleHelpers.clearScreen();
    final reportType = isShort ? 'Краткий' : 'Полный';
    ConsoleHelpers.printSubHeader('$reportType отчет');

    // Выбираем группу
    final group = await _helpers.selectGroup();
    if (group == null) return;

    // Выбираем дисциплину группы
    final discipline = await _helpers.selectDisciplineFromGroup(
      group.id,
      emptyMessage: 'У группы "${group.name}" нет привязанных дисциплин',
    );
    if (discipline == null) return;

    try {
      ConsoleHelpers.printInfo('Генерация отчета...');

      final builder = isShort
          ? ShortReportBuilder(
              db: db,
              groupId: group.id,
              disciplineId: discipline.id,
              tempReportDir: tempReportDir,
            )
          : FullReportBuilder(
              db: db,
              groupId: group.id,
              disciplineId: discipline.id,
              tempReportDir: tempReportDir,
            );

      await builder.buildReport();
      await builder.saveReport();

      final filePath = builder.getReportPath();
      ConsoleHelpers.printSuccess('Отчет сохранен: $filePath');

      // Пытаемся открыть файл
      if (ConsoleHelpers.confirm('Открыть файл?')) {
        await _openFile(filePath);
      }
    } catch (e) {
      ConsoleHelpers.printError('Не удалось создать отчет: $e');
    }
  }

  // Интерактивный отчет
  Future<void> interactiveReport() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printSubHeader('Интерактивный отчет');

    // Выбираем дисциплину
    final discipline = await _helpers.selectDiscipline();
    if (discipline == null) return;

    // Выбираем группу с этой дисциплиной
    final group = await _helpers.selectGroupWithDiscipline(
      discipline.id,
      emptyMessage: 'Нет групп с дисциплиной "${discipline.name}"',
    );
    if (group == null) return;

    // Выбираем студента
    final student = await _helpers.selectStudentFromGroup(
      group.id,
      emptyMessage: 'В группе "${group.name}" нет студентов',
    );
    if (student == null) return;

    // Получаем статистику
    try {
      final result = await db.missedClassDao.getAcademicPerformance(
        student.id,
        discipline.id,
      );

      print('\n═══════════════════════════════════════');
      print('Студент: ${result.fullName}');
      print('Группа: ${group.name}');
      print('Дисциплина: ${discipline.name}');
      print('───────────────────────────────────────');
      print('Пропущено занятий: ${result.missedCount}');
      print('Всего занятий: ${result.totalCount}');

      if (result.totalCount > 0) {
        final percentage = (result.missedCount / result.totalCount * 100)
            .toStringAsFixed(1);
        print('Процент пропусков: $percentage%');
      }
      print('═══════════════════════════════════════\n');
    } catch (e) {
      ConsoleHelpers.printError('Не удалось получить статистику: $e');
    }
  }

  // Открываем файл в системном приложении
  Future<void> _openFile(String filePath) async {
    try {
      if (Platform.isWindows) {
        await Process.run('cmd', ['/c', 'start', '', filePath]);
      } else if (Platform.isMacOS) {
        await Process.run('open', [filePath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [filePath]);
      }
    } catch (e) {
      ConsoleHelpers.printError('Не удалось открыть файл: $e');
    }
  }
}
