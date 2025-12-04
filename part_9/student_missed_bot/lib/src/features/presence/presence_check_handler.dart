import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки проверки присутствия
class PresenceCheckHandler {
  final Bot bot;
  final SqliteDatabase db;

  static const int pageSize = 5;

  // Хранилище отсутствующих студентов (chatId -> список ID студентов)
  final Map<int, List<int>> _missedStudents = {};

  PresenceCheckHandler({required this.bot, required this.db});

  // Регистрируем handlers
  void register() {
    // Два варианта запуска обработчика команды проверки присутствия
    // 1. Через команду /presencecheck
    // 2. Через текстовое сообщение "Проверка присутствия"
    bot.command('presencecheck', _handlePresenceCheckCommand);
    bot.hears(BotMessages.presenceCheck, _handlePresenceCheckCommand);
    // Регистрируем обработчики, отвечающие за разные шаги
    // проверки присутствия:
    // 1. Выбор дисциплины
    // 2. Выбор группы
    // 3. Выбор студента
    // 4. Отметить всех студентов как присутствующих
    // 5. Отметить всех студентов как отсутствующих
    // 6. Применить результаты проверки присутствия
    bot.callbackQuery(RegExp(r'^presenceDis_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^presenceGroup_'), _handleGroupSelection);
    bot.callbackQuery(RegExp(r'^studClick_'), _handleStudentClick);
    bot.callbackQuery(RegExp(r'^allPresent_'), _handleAllPresent);
    bot.callbackQuery(RegExp(r'^allMissed_'), _handleAllMissed);
    bot.callbackQuery(RegExp(r'^apply_'), _handleApply);
  }

  // Обработчик команды проверки присутствия
  Future<void> _handlePresenceCheckCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final disciplines = await db.disciplineDao.getAll();
    // Создаем клавиатуру для выбора дисциплины
    final keyboard = InlineKeyboardBuilder.createDisciplineButtons(
      disciplines,
      'presenceDis',
    );

    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectDiscipline, replyMarkup: keyboard);
  }

  // Обработчик выбора дисциплины
  Future<void> _handleDisciplineSelection(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final disciplineId = int.tryParse(parts[1]);
    if (disciplineId == null) return;

    final groups = await db.disciplineDao.getAssignedGroups(disciplineId);

    var keyboard = InlineKeyboard();
    for (final group in groups) {
      keyboard = keyboard
          .text(group.name, 'presenceGroup_0_${disciplineId}_${group.id}')
          .row();
    }

    _missedStudents[ctx.from!.id] = [];

    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы
  Future<void> _handleGroupSelection(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 4) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final disciplineId = int.tryParse(parts[2]);
    final groupId = int.tryParse(parts[3]);

    if (disciplineId == null || groupId == null) return;

    await _showStudentList(ctx, ctx.from!.id, paginator, disciplineId, groupId);
  }

  // Обработчик выбора студента
  Future<void> _handleStudentClick(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 5) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final disciplineId = int.tryParse(parts[2]);
    final groupId = int.tryParse(parts[3]);
    final studentId = int.tryParse(parts[4]);

    if (disciplineId == null || groupId == null || studentId == null) return;

    final userId = ctx.from!.id;
    final missedList = _missedStudents[userId] ?? [];
    if (missedList.contains(studentId)) {
      missedList.remove(studentId);
    } else {
      missedList.add(studentId);
    }
    _missedStudents[userId] = missedList;

    await _showStudentList(ctx, userId, paginator, disciplineId, groupId);
  }

  // Обработчик вывода списка студентов
  Future<void> _showStudentList(
    Context ctx,
    int userId,
    int paginator,
    int disciplineId,
    int groupId,
  ) async {
    // Получаем список студентов группы
    final students = await db.studentDao.getByGroupId(groupId);
    // Вычисляем начало списка студентов для текущей страницы
    final startIndex = paginator * pageSize;
    // Вычисляем конец списка студентов для текущей страницы
    final endIndex = (paginator + 1) * pageSize;
    // Получаем список студентов для текущей страницы
    final page = students.sublist(
      startIndex,
      endIndex > students.length ? students.length : endIndex,
    );

    // Получаем список отсутствующих студентов для текущего пользователя
    final missedList = _missedStudents[userId] ?? [];
    // Создаем клавиатуру для выбора студента
    var keyboard = InlineKeyboard();
    for (final student in page) {
      final isMissed = missedList.contains(student.id);
      final prefix = isMissed ? '❌' : '✔️';
      keyboard = keyboard
          .text(
            '$prefix ${student.fullName}',
            'studClick_${paginator}_${disciplineId}_${groupId}_${student.id}',
          )
          .row();
    }

    // Проверяем, есть ли следующая и предыдущая страницы
    final hasNext = students.length > (paginator + 1) * pageSize;
    final hasPrev = paginator > 0;

    // Добавляем кнопки навигации, если они нужны
    if (hasPrev || hasNext) {
      if (hasPrev) {
        keyboard = keyboard.text(
          '⬅',
          'presenceGroup_${paginator - 1}_${disciplineId}_$groupId',
        );
      }
      if (hasNext) {
        keyboard = keyboard.text(
          '➡',
          'presenceGroup_${paginator + 1}_${disciplineId}_$groupId',
        );
      }
      keyboard = keyboard.row();
    }

    // Добавляем специальные кнопки для отметки всех студентов 
    // как присутствующих или отсутствующих
    keyboard = keyboard
        .text('🚀', 'allPresent_${disciplineId}_$groupId')
        .text('⚔️', 'allMissed_${disciplineId}_$groupId')
        .row()
        .text('Принять', 'apply_${disciplineId}_$groupId');

    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(
      BotMessages.selectAbsentStudent,
      replyMarkup: keyboard,
    );
  }

  // Обработчик команды, чтобы отметить всех
  // студентов группы как присутствующих
  Future<void> _handleAllPresent(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    _missedStudents[ctx.from!.id] = [];

    await db.missedClassDao.addAllRecords(groupId, disciplineId, false);

    // Редактируем сообщение о том, что все студенты присутствуют
    await ctx.editMessageText(BotMessages.allPresent);
  }

  // Обработчик команды, чтобы отметить всех
  // студентов группы как отсутствующих
  Future<void> _handleAllMissed(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    _missedStudents[ctx.from!.id] = [];

    await db.missedClassDao.addAllRecords(groupId, disciplineId, true);

    // Редактируем сообщение о том, что все студенты отсутствуют
    await ctx.editMessageText(BotMessages.allAbsent);
  }

  // Обработчик команды, чтобы применить пропуски
  Future<void> _handleApply(Context ctx) async {
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    final userId = ctx.from!.id;
    final missedList = _missedStudents[userId] ?? [];

    await db.missedClassDao.addMissedRecords(missedList, groupId, disciplineId);

    _missedStudents.remove(userId);

    await ctx.editMessageText(BotMessages.attendanceRecorded);
  }
}
