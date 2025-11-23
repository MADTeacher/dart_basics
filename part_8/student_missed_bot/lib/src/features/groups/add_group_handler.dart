import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../core/state/conversation_state.dart';
import '../../shared/constants/messages.dart';

/// Обработчик добавления группы
class AddGroupHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;
  final ConversationStateManager stateManager;

  AddGroupHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
    required this.stateManager,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('addgroup', _handleAddGroupCommand);
    bot.filter(_isWaitingGroupName, _handleGroupName);
  }

  bool _isWaitingGroupName(Context ctx) {
    final userId = ctx.from?.id;
    if (userId == null) return false;
    return stateManager.getState(userId) == BotState.waitingGroupName;
  }

  Future<void> _handleAddGroupCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    stateManager.setState(userId, BotState.waitingGroupName);
    await ctx.reply(BotMessages.enterGroupName);
  }

  Future<void> _handleGroupName(Context ctx) async {
    final userId = ctx.from?.id;
    final groupName = ctx.message?.text;

    if (userId == null || groupName == null) return;

    // Проверяем, существует ли группа
    final exists = await db.groupDao.exists(groupName);
    if (exists) {
      await ctx.reply(BotMessages.groupAlreadyExists);
      return;
    }

    // Добавляем группу
    await db.groupDao.add(groupName);
    stateManager.deleteState(userId);
    await ctx.reply(BotMessages.groupAdded);
  }
}
