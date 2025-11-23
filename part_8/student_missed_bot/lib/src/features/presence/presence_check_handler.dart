import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/keyboard_builder.dart';

/// Обработчик проверки присутствия
class PresenceCheckHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;

  static const int pageSize = 5;

  // Хранилище отсутствующих студентов (chatId -> список ID студентов)
  final Map<int, List<int>> _missedStudents = {};

  PresenceCheckHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('presencecheck', _handlePresenceCheckCommand);
    bot.hears(BotMessages.presenceCheck, _handlePresenceCheckCommand);
    bot.callbackQuery(RegExp(r'^presenceDis_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^presenceGroup_'), _handleGroupSelection);
    bot.callbackQuery(RegExp(r'^studClick_'), _handleStudentClick);
    bot.callbackQuery(RegExp(r'^allPresent_'), _handleAllPresent);
    bot.callbackQuery(RegExp(r'^allMissed_'), _handleAllMissed);
    bot.callbackQuery(RegExp(r'^apply_'), _handleApply);
  }

  Future<void> _handlePresenceCheckCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    final disciplines = await db.disciplineDao.getAll();
    final keyboard = KeyboardBuilder.createDisciplineButtons(
      disciplines,
      'presenceDis',
    );

    await ctx.reply(BotMessages.selectDiscipline, replyMarkup: keyboard);
  }

  Future<void> _handleDisciplineSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

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

    _missedStudents[userId] = [];

    await ctx.editMessageText(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  Future<void> _handleGroupSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 4) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final disciplineId = int.tryParse(parts[2]);
    final groupId = int.tryParse(parts[3]);

    if (disciplineId == null || groupId == null) return;

    await _showStudentList(ctx, userId, paginator, disciplineId, groupId);
  }

  Future<void> _handleStudentClick(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 5) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final disciplineId = int.tryParse(parts[2]);
    final groupId = int.tryParse(parts[3]);
    final studentId = int.tryParse(parts[4]);

    if (disciplineId == null || groupId == null || studentId == null) return;

    // Переключаем статус студента
    final missedList = _missedStudents[userId] ?? [];
    if (missedList.contains(studentId)) {
      missedList.remove(studentId);
    } else {
      missedList.add(studentId);
    }
    _missedStudents[userId] = missedList;

    await _showStudentList(ctx, userId, paginator, disciplineId, groupId);
  }

  Future<void> _showStudentList(
    Context ctx,
    int userId,
    int paginator,
    int disciplineId,
    int groupId,
  ) async {
    final students = await db.studentDao.getByGroupId(groupId);
    final startIndex = paginator * pageSize;
    final endIndex = (paginator + 1) * pageSize;
    final page = students.sublist(
      startIndex,
      endIndex > students.length ? students.length : endIndex,
    );

    final missedList = _missedStudents[userId] ?? [];

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

    // Кнопки навигации
    final hasNext = students.length > (paginator + 1) * pageSize;
    final hasPrev = paginator > 0;

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

    // Специальные кнопки
    keyboard = keyboard
        .text('🚀', 'allPresent_${disciplineId}_$groupId')
        .text('⚔️', 'allMissed_${disciplineId}_$groupId')
        .row()
        .text('Принять', 'apply_${disciplineId}_$groupId');

    await ctx.editMessageText(
      BotMessages.selectAbsentStudent,
      replyMarkup: keyboard,
    );
  }

  Future<void> _handleAllPresent(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    _missedStudents[userId] = [];

    await db.missedClassDao.addAllRecords(groupId, disciplineId, false);

    await ctx.editMessageText(BotMessages.allPresent);
  }

  Future<void> _handleAllMissed(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    _missedStudents[userId] = [];

    await db.missedClassDao.addAllRecords(groupId, disciplineId, true);

    await ctx.editMessageText(BotMessages.allAbsent);
  }

  Future<void> _handleApply(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    final missedList = _missedStudents[userId] ?? [];

    await db.missedClassDao.addMissedRecords(missedList, groupId, disciplineId);

    _missedStudents.remove(userId);

    await ctx.editMessageText(BotMessages.attendanceRecorded);
  }
}
