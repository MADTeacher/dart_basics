import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_group_dao.dart';
import '../../core/state/conversation_state.dart';
import '../../shared/constants/messages.dart';

// Класс для обработки добавления группы
class AddGroupHandler {
  final Bot bot;
  final IGroupDao groupDao;
  final ConversationStateManager stateManager;

  AddGroupHandler({
    required this.bot,
    required this.groupDao,
    required this.stateManager,
  });

  // Регистрируем handlers
  void register() {
    bot.command('addgroup', _handleAddGroupCommand);
    bot.filter(_isWaitingGroupName, _handleGroupName);
  }

  // Проверяем, находится ли пользователь в состоянии 
  // ожидания ввода названия группы
  bool _isWaitingGroupName(Context ctx) {
    final userId = ctx.from?.id;
    if (userId == null) return false;
    return stateManager.getState(userId) == BotState.waitingGroupName;
  }

  // Обработчик команды добавления группы
  Future<void> _handleAddGroupCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Проверка прав администратора выполняется в middleware плагине
    stateManager.setState(userId, BotState.waitingGroupName);
    await ctx.reply(BotMessages.enterGroupName);
  }

  // Обработчик ввода названия группы и ее
  // добавления в базу данных
  Future<void> _handleGroupName(Context ctx) async {
    final userId = ctx.from?.id;
    final groupName = ctx.message?.text;

    if (userId == null || groupName == null) return;

    // Проверяем, существует ли группа
    final exists = await groupDao.exists(groupName);
    if (exists) {
      await ctx.reply(BotMessages.groupAlreadyExists);
      return;
    }

    // Добавляем группу
    await groupDao.add(groupName);
    stateManager.deleteState(userId);
    await ctx.reply(BotMessages.groupAdded);
  }
}
