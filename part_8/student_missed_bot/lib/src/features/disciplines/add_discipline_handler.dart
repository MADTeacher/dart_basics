import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../core/state/conversation_state.dart';
import '../../shared/constants/messages.dart';

/// Обработчик добавления дисциплины
class AddDisciplineHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;
  final ConversationStateManager stateManager;

  AddDisciplineHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
    required this.stateManager,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('adddiscipline', _handleAddDisciplineCommand);
    bot.filter(_isWaitingDisciplineName, _handleDisciplineName);
  }

  bool _isWaitingDisciplineName(Context ctx) {
    final userId = ctx.from?.id;
    if (userId == null) return false;
    return stateManager.getState(userId) == BotState.waitingDisciplineName;
  }

  Future<void> _handleAddDisciplineCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    stateManager.setState(userId, BotState.waitingDisciplineName);
    await ctx.reply(BotMessages.enterDisciplineName);
  }

  Future<void> _handleDisciplineName(Context ctx) async {
    final userId = ctx.from?.id;
    final disciplineName = ctx.message?.text;

    if (userId == null || disciplineName == null) return;

    // Проверяем, существует ли дисциплина
    final exists = await db.disciplineDao.exists(disciplineName);
    if (exists) {
      await ctx.reply(BotMessages.disciplineAlreadyExists);
      return;
    }

    // Добавляем дисциплину
    await db.disciplineDao.add(disciplineName);
    stateManager.deleteState(userId);
    await ctx.reply(BotMessages.disciplineAdded);
  }
}
