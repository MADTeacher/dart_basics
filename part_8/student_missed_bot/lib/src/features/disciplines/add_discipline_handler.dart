import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_discipline_dao.dart';
import '../../core/middleware/admin_filter.dart';
import '../../core/state/conversation_state.dart';
import '../../shared/constants/messages.dart';

// Класс для обработки добавления дисциплины
class AddDisciplineHandler {
  final Bot bot;
  final IDisciplineDao disciplineDao;
  final AdminFilter adminFilter;
  final ConversationStateManager stateManager;

  AddDisciplineHandler({
    required this.bot,
    required this.disciplineDao,
    required this.adminFilter,
    required this.stateManager,
  });

  // Регистрируем handlers
  void register() {
    bot.command('adddiscipline', _handleAddDisciplineCommand);
    bot.filter(_isWaitingDisciplineName, _handleDisciplineName);
  }

  // Проверяем, находится ли пользователь в состоянии 
  // ожидания ввода названия дисциплины
  bool _isWaitingDisciplineName(Context ctx) {
    final userId = ctx.from?.id;
    if (userId == null) return false;
    return stateManager.getState(userId) == BotState.waitingDisciplineName;
  }

  // Обработчик команды добавления дисциплины
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

  // Обработчик ввода названия дисциплины и ее
  // добавления в базу данных
  Future<void> _handleDisciplineName(Context ctx) async {
    final userId = ctx.from?.id;
    final disciplineName = ctx.message?.text;

    if (userId == null || disciplineName == null) return;

    // Проверяем, существует ли дисциплина
    final exists = await disciplineDao.exists(disciplineName);
    if (exists) {
      await ctx.reply(BotMessages.disciplineAlreadyExists);
      return;
    }

    // Добавляем дисциплину
    await disciplineDao.add(disciplineName);
    stateManager.deleteState(userId);
    await ctx.reply(BotMessages.disciplineAdded);
  }
}
