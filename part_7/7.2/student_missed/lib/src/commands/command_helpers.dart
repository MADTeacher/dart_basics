import '../database/interfaces/i_database_provider.dart';
import '../database/models/discipline.dart';
import '../database/models/group.dart';
import '../database/models/student.dart';
import '../utils/console_helpers.dart';

// Класс вспомогательных функций для команд
class CommandHelpers {
  final IDatabaseProvider db;

  CommandHelpers({required this.db});

  // Выбираем группу из списка
  Future<GroupModel?> selectGroup({
    String? emptyMessage,
    String? title,
  }) async {
    final groups = await db.groupDao.getAll();

    if (groups.isEmpty) {
      ConsoleHelpers.printInfo(emptyMessage ?? 'Группы отсутствуют');
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      groups,
      (g) => g.name,
      title: title ?? 'Выберите группу:',
    );

    if (index == null) return null;
    return groups[index];
  }

  // Выбираем дисциплину из списка
  Future<DisciplineModel?> selectDiscipline({
    String? emptyMessage,
    String? title,
  }) async {
    final disciplines = await db.disciplineDao.getAll();

    if (disciplines.isEmpty) {
      ConsoleHelpers.printInfo(emptyMessage ?? 'Дисциплины отсутствуют');
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      disciplines,
      (d) => d.name,
      title: title ?? 'Выберите дисциплину:',
    );

    if (index == null) return null;
    return disciplines[index];
  }

  // Выбираем студента из группы
  Future<StudentModel?> selectStudentFromGroup(
    int groupId, {
    String? emptyMessage,
    String? title,
  }) async {
    final students = await db.studentDao.getByGroupId(groupId);

    if (students.isEmpty) {
      ConsoleHelpers.printInfo(
        emptyMessage ?? 'В группе нет студентов',
      );
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      students,
      (s) => s.fullName,
      title: title ?? 'Выберите студента:',
    );

    if (index == null) return null;
    return students[index];
  }

  // Выбираем группу с дисциплиной
  Future<GroupModel?> selectGroupWithDiscipline(
    int disciplineId, {
    String? emptyMessage,
    String? title,
  }) async {
    final groups = await db.disciplineDao.getAssignedGroups(disciplineId);

    if (groups.isEmpty) {
      ConsoleHelpers.printInfo(
        emptyMessage ?? 'Нет групп с этой дисциплиной',
      );
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      groups,
      (g) => g.name,
      title: title ?? 'Выберите группу:',
    );

    if (index == null) return null;
    return groups[index];
  }

  // Выбираем дисциплину группы
  Future<DisciplineModel?> selectDisciplineFromGroup(
    int groupId, {
    String? emptyMessage,
    String? title,
  }) async {
    final disciplines = await db.groupDao.getAssignedDisciplines(groupId);

    if (disciplines.isEmpty) {
      ConsoleHelpers.printInfo(
        emptyMessage ?? 'У группы нет привязанных дисциплин',
      );
      return null;
    }

    final index = ConsoleHelpers.showSelectionList(
      disciplines,
      (d) => d.name,
      title: title ?? 'Выберите дисциплину:',
    );

    if (index == null) return null;
    return disciplines[index];
  }
}

