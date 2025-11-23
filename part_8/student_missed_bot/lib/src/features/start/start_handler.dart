import 'package:televerse/televerse.dart';
import 'package:televerse/telegram.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/keyboard_builder.dart';

/// Обработчик команды /start
class StartHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;

  StartHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
  });

  /// Зарегистрировать handlers
  void register() {
    bot.command('start', _handleStart);
  }

  Future<void> _handleStart(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);

    if (isAdmin) {
      await _handleAdminStart(ctx);
    } else {
      await _handleNonAdminStart(ctx);
    }
  }

  Future<void> _handleAdminStart(Context ctx) async {
    final userId = ctx.from!.id;

    // Устанавливаем команды бота для администратора
    await ctx.api.setMyCommands([
      BotCommand(command: 'addstudent', description: 'Добавить студента'),
      BotCommand(command: 'adddiscipline', description: 'Добавить дисциплину'),
      BotCommand(
        command: 'discipline2group',
        description: 'Назначить дисциплину группе',
      ),
      BotCommand(command: 'addgroup', description: 'Добавить группу'),
      BotCommand(command: 'fullreport', description: 'Полный отчет'),
      BotCommand(command: 'shortreport', description: 'Краткий отчет'),
      BotCommand(command: 'interreport', description: 'Интерактивный отчет'),
      BotCommand(command: 'presencecheck', description: 'Проверка присутствия'),
      BotCommand(command: 'delstudent', description: 'Удалить студента'),
    ], scope: BotCommandScopeChat(chatId: ChatID(userId)));

    // Отправляем приветственное сообщение с меню
    await ctx.reply(
      BotMessages.startMessage,
      parseMode: ParseMode.html,
      replyMarkup: KeyboardBuilder.createMainMenuKeyboard(),
    );
  }

  Future<void> _handleNonAdminStart(Context ctx) async {
    await ctx.reply(BotMessages.unauthorizedAccess);
  }
}
