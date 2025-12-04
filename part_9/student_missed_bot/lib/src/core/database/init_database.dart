import 'dart:io';
import 'interfaces/i_database_provider.dart';
import '../utils/excel_parser.dart';
export 'database.dart';

// Класс для инициализации базы данных
class DatabaseInitializer {
  final IDatabaseProvider db;
  final String tempReportDir;
  final String configDataPath;
  final bool isFirstRun;

  DatabaseInitializer({
    required this.db,
    required this.tempReportDir,
    required this.configDataPath,
    required this.isFirstRun,
  });

  // Запускаем инициализацию базы данных
  Future<void> start() async {
    // Если это первый запуск - импортируем начальные данные
    if (isFirstRun) {
      await _importInitialData();
    }
  }

  // Импортируем начальные данные из конфигурационного файла
  Future<void> _importInitialData() async {
    print('');
    print('Проверка конфигурационного файла: $configDataPath');

    final configFile = File(configDataPath);
    if (!configFile.existsSync()) {
      return;
    }

    try {
      await _importFromExcel(filePath: configDataPath, interactive: false);
      print('');
    } catch (e) {
      print('Ошибка при импорте начальных данных: $e');
      print('Запуск с пустой базой данных...');
    }
  }

  // Импортируем данные из Excel-файла
  Future<void> _importFromExcel({
    required String filePath,
    bool interactive = true,
  }) async {
    if (interactive) {
      print('Импорт данных из Excel');
    }

    try {
      print('Чтение файла: $filePath...\n');

      // Парсим Excel-файл
      final parser = ExcelParser(filePath);
      final data = parser.parse();

      if (data.isEmpty) {
        print('Файл не содержит данных для импорта');
        return;
      }

      print('Файл успешно прочитан');
      print('Найдено:');
      print('  • Дисциплин: ${data.keys.length}');

      int totalGroups = 0;
      int totalStudents = 0;
      for (var disciplineData in data.values) {
        totalGroups += disciplineData.keys.length;
        for (var students in disciplineData.values) {
          totalStudents += students.length;
        }
      }
      print('  • Групп: $totalGroups');
      print('  • Студентов: $totalStudents\n');

      print('${interactive ? "\n" : ""}Импорт данных...\n');

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
          print('Добавлена дисциплина: $disciplineName');
        } else {
          final discipline = (await db.disciplineDao.getAll()).firstWhere(
            (d) => d.name == disciplineName,
          );
          disciplineId = discipline.id;
          print('  Дисциплина уже существует: $disciplineName');
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
            print('Добавлена группа: $groupName');
          } else {
            final group = (await db.groupDao.getAll()).firstWhere(
              (g) => g.name == groupName,
            );
            groupId = group.id;
            print('    Группа уже существует: $groupName');
          }

          // Привязываем дисциплину к группе
          try {
            final assignedDisciplines = await db.groupDao
                .getAssignedDisciplines(groupId);

            if (!assignedDisciplines.any((d) => d.id == disciplineId)) {
              await db.groupDao.assignDiscipline(groupId, disciplineId);
              assignedLinks++;
              print(
                'Привязана дисциплина "$disciplineName" к группе "$groupName"',
              );
            }
          } catch (e) {
            print('Не удалось привязать дисциплину: $e');
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
            print('Добавлено студентов: ${studentNames.length}');
          }
        }

        print('');
      }

      // Итоги импорта
      print('Импорт завершен успешно!');
      print('\nИмпортировано:');
      print('  • Дисциплин: $importedDisciplines');
      print('  • Групп: $importedGroups');
      print('  • Студентов: $importedStudents');
      print('  • Связей группа-дисциплина: $assignedLinks');
    } catch (e) {
      print('Ошибка при импорте: $e');
    }
  }
}
