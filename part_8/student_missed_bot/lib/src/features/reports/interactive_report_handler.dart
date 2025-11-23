import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/keyboard_builder.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

/// Обработчик интерактивного отчета
class InteractiveReportHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;

  static const int pageSize = 7;

  InteractiveReportHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('interreport', _handleInteractiveReportCommand);
    bot.hears(BotMessages.interactiveReport, _handleInteractiveReportCommand);
    bot.callbackQuery(RegExp(r'^disReport_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^groupReport_'), _handleGroupSelection);
    bot.callbackQuery(RegExp(r'^studRepClick_'), _handleStudentSelection);
  }

  Future<void> _handleInteractiveReportCommand(Context ctx) async {
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
      'disReport',
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
          .text(group.name, 'groupReport_0_${group.id}_$disciplineId')
          .row();
    }

    await ctx.editMessageText(BotMessages.selectStudent, replyMarkup: keyboard);
  }

  Future<void> _handleGroupSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 4) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final groupId = int.tryParse(parts[2]);
    final disciplineId = int.tryParse(parts[3]);

    if (groupId == null || disciplineId == null) return;

    final students = await db.studentDao.getByGroupId(groupId);

    final keyboard = InlineKeyboardHelper.createPaginatedList(
      allItems: students,
      paginator: paginator,
      pageSize: pageSize,
      textBuilder: (s) => s.fullName,
      dataBuilder: (s) => 'studRepClick_${s.id}_$disciplineId',
      prevPageCallback: 'groupReport_${paginator - 1}_${groupId}_$disciplineId',
      nextPageCallback: 'groupReport_${paginator + 1}_${groupId}_$disciplineId',
    );

    await ctx.editMessageText(BotMessages.selectStudent, replyMarkup: keyboard);
  }

  Future<void> _handleStudentSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final studentId = int.tryParse(parts[1]);
    final disciplineId = int.tryParse(parts[2]);

    if (studentId == null || disciplineId == null) return;

    final result = await db.missedClassDao.getAcademicPerformance(
      studentId,
      disciplineId,
    );

    final text =
        'Студент: ${result.fullName}\n'
        'Пропущено занятий: ${result.missedCount}\n'
        'Всего занятий: ${result.totalCount}\n';

    await ctx.editMessageText(text);
  }
}
