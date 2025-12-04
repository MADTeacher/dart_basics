import 'dart:io';
import 'src/database/interfaces/i_database_provider.dart';
import 'src/utils/excel_parser.dart';
import 'src/ui/menu.dart';
import 'src/utils/console_helpers.dart';

export 'src/database/database.dart';
export 'src/utils/console_helpers.dart';
export 'src/utils/dotenv.dart';

class CliApp {
  final IDatabaseProvider db;
  final String tempReportDir;
  final String configDataPath;
  final bool isFirstRun;

  CliApp({
    required this.db,
    required this.tempReportDir,
    required this.configDataPath,
    required this.isFirstRun,
  });

  // Запускаем CLI приложение
  Future<void> start() async {
    ConsoleHelpers.clearScreen();
    ConsoleHelpers.printHeader('Система учета посещаемости студентов');

    print('\nИнициализация...');

    // Создать директорию для отчетов если не существует
    final dir = Directory(tempReportDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    // Если это первый запуск - импортировать начальные данные
    if (isFirstRun) {
      ConsoleHelpers.printInfo('Обнаружен первый запуск системы');
      await _importInitialData();
    }

    ConsoleHelpers.printSuccess('Приложение готово к работе');

    // Выводим главное меню
    final menu = MainMenu(db: db, tempReportDir: tempReportDir);
    await menu.show();
  }

  // Импортируем начальные данные из конфигурационного файла
  Future<void> _importInitialData() async {
    print('');
    print('Проверка конфигурационного файла: $configDataPath');

    final configFile = File(configDataPath);
    if (!configFile.existsSync()) {
      ConsoleHelpers.printError('Файл с начальными данными не найден: $configDataPath');
      ConsoleHelpers.printInfo('Запуск с пустой базой данных...');
      return;
    }

    ConsoleHelpers.printSuccess('Файл найден, начинается импорт данных...');

    try {
      await _importFromExcel(filePath: configDataPath, interactive: false);
      print('');
    } catch (e) {
      ConsoleHelpers.printError('Ошибка при импорте начальных данных: $e');
      ConsoleHelpers.printInfo('Запуск с пустой базой данных...');
    }
  }

  // Закрываем приложение
  Future<void> close() async {
    await db.close();
  }

  // Импортируем данные из Excel-файла
  Future<void> _importFromExcel({
    required String filePath,
    bool interactive = true,
  }) async {
    if (interactive) {
      ConsoleHelpers.clearScreen();
      ConsoleHelpers.printSubHeader('Импорт данных из Excel');
    }

    try {
      print('Чтение файла: $filePath...\n');

      // Парсим Excel-файл
      final parser = ExcelParser(filePath);
      final data = parser.parse();

      if (data.isEmpty) {
        ConsoleHelpers.printError('Файл не содержит данных для импорта');
        return;
      }

      ConsoleHelpers.printSuccess('Файл успешно прочитан');
      ConsoleHelpers.printInfo('Найдено:');
      ConsoleHelpers.printInfo('  • Дисциплин: ${data.keys.length}');

      int totalGroups = 0;
      int totalStudents = 0;
      for (var disciplineData in data.values) {
        totalGroups += disciplineData.keys.length;
        for (var students in disciplineData.values) {
          totalStudents += students.length;
        }
      }
      ConsoleHelpers.printInfo('  • Групп: $totalGroups');
      ConsoleHelpers.printInfo('  • Студентов: $totalStudents\n');

      ConsoleHelpers.printInfo('${interactive ? "\n" : ""}Импорт данных...\n');

      int importedDisciplines = 0;
      int importedGroups = 0;
      int importedStudents = 0;
      int assignedLinks = 0;

      // Импорт данных: дисциплина -> группа -> студенты
      for (var disciplineEntry in data.entries) {
        final disciplineName = disciplineEntry.key;
        final groupsData = disciplineEntry.value;

        // Добавляем дисциплину если ее нет
        int disciplineId;
        if (!await db.disciplineDao.exists(disciplineName)) {
          disciplineId = await db.disciplineDao.add(disciplineName);
          importedDisciplines++;
          ConsoleHelpers.printSuccess('Добавлена дисциплина: $disciplineName');
        } else {
          final discipline = (await db.disciplineDao.getAll()).firstWhere(
            (d) => d.name == disciplineName,
          );
          disciplineId = discipline.id;
          ConsoleHelpers.printInfo('  Дисциплина уже существует: $disciplineName');
        }

        // Импортируем группы и студентов для этой дисциплины
        for (var groupEntry in groupsData.entries) {
          final groupName = groupEntry.key;
          final studentNames = groupEntry.value;

          // Добавляем группу если ее нет
          int groupId;
          if (!await db.groupDao.exists(groupName)) {
            groupId = await db.groupDao.add(groupName);
            importedGroups++;
            ConsoleHelpers.printSuccess('Добавлена группа: $groupName');
          } else {
            final group = (await db.groupDao.getAll()).firstWhere(
              (g) => g.name == groupName,
            );
            groupId = group.id;
            ConsoleHelpers.printInfo('    Группа уже существует: $groupName');
          }

          // Привязываем дисциплину к группе
          try {
            final assignedDisciplines = await db.groupDao
                .getAssignedDisciplines(groupId);

            if (!assignedDisciplines.any((d) => d.id == disciplineId)) {
              await db.groupDao.assignDiscipline(groupId, disciplineId);
              assignedLinks++;
              ConsoleHelpers.printSuccess(
                'Привязана дисциплина "$disciplineName" к группе "$groupName"',
              );
            }
          } catch (e) {
            ConsoleHelpers.printError('Не удалось привязать дисциплину: $e');
          }

          // Добавляем студентов
          for (var studentName in studentNames) {
            if (studentName.isEmpty) continue;

            // Проверяем, нет ли уже такого студента в группе
            final existingStudents = await db.studentDao.getByGroupId(groupId);
            if (!existingStudents.any((s) => s.fullName == studentName)) {
              await db.studentDao.add(groupId, studentName);
              importedStudents++;
            }
          }

          if (studentNames.isNotEmpty) {
            ConsoleHelpers.printSuccess('Добавлено студентов: ${studentNames.length}');
          }
        }

        print('');
      }

      // Итоги импорта
      ConsoleHelpers.printSuccess('Импорт завершен успешно!');
      print('\nИмпортировано:');
      print('  • Дисциплин: $importedDisciplines');
      print('  • Групп: $importedGroups');
      print('  • Студентов: $importedStudents');
      print('  • Связей группа-дисциплина: $assignedLinks');
      ConsoleHelpers.pause();
    } catch (e) {
      ConsoleHelpers.printError('Ошибка при импорте: $e');
      ConsoleHelpers.pause();
    }
  }
}
