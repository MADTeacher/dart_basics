import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

/// Обработчик привязки дисциплины к группе
class AssignDisciplineHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;

  AssignDisciplineHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('discipline2group', _handleAssignDisciplineCommand);
    bot.callbackQuery(RegExp(r'^dis2group_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^applygroup_'), _handleGroupAssignment);
  }

  Future<void> _handleAssignDisciplineCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    final disciplines = await db.disciplineDao.getAll();
    final keyboard = InlineKeyboardHelper.createSimpleList(
      items: disciplines,
      textBuilder: (d) => d.name,
      dataBuilder: (d) => 'dis2group_${d.id}',
    );

    await ctx.reply(BotMessages.selectDiscipline, replyMarkup: keyboard);
  }

  Future<void> _handleDisciplineSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;
    final messageId = ctx.callbackQuery?.message?.messageId;

    if (userId == null || callbackData == null || messageId == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final disciplineId = int.tryParse(parts[1]);
    if (disciplineId == null) return;

    final groups = await db.groupDao.getGroupsWithoutDiscipline(disciplineId);

    if (groups.isEmpty) {
      await ctx.editMessageText(BotMessages.noGroupsToAssign);
      return;
    }

    final keyboard = InlineKeyboardHelper.createSimpleList(
      items: groups,
      textBuilder: (g) => g.name,
      dataBuilder: (g) => 'applygroup_${disciplineId}_${g.id}',
    );

    await ctx.editMessageText(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  Future<void> _handleGroupAssignment(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;
    final messageId = ctx.callbackQuery?.message?.messageId;

    if (userId == null || callbackData == null || messageId == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);

    if (disciplineId == null || groupId == null) return;

    await db.groupDao.assignDiscipline(groupId, disciplineId);

    await ctx.editMessageText(BotMessages.disciplineAssigned);
  }
}
