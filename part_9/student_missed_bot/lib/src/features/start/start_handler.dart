import 'package:televerse/televerse.dart';
import 'package:televerse/telegram.dart';

import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/reply_keyboard_helper.dart';

// Класс для обработки команды /start
class StartHandler {
  final Bot bot;
  final AdminFilter adminFilter;

  StartHandler({required this.bot, required this.adminFilter});

  // Регистрируем handlers
  void register() {
    bot.command('start', _handleStart);
  }

  // Обработчик команды /start
  Future<void> _handleStart(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Проверяем, является ли пользователь администратором
    if (adminFilter.isAdmin(userId)) {
      await _handleAdminStart(ctx);
    } else {
      await _handleNonAdminStart(ctx);
    }
  }

  // Обработчик команды /start для администратора
  Future<void> _handleAdminStart(Context ctx) async {
    final userId = ctx.from!.id;

    // Устанавливаем команды, которые будут доступны боту
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

    // Отправляем приветственное сообщение с меню в виде reply-клавиатуры
    await ctx.reply(
      BotMessages.startMessage,
      parseMode: ParseMode.html,
      replyMarkup: ReplyKeyboardBuilder.createMainMenuKeyboard(),
    );
  }

  // Обработчик команды /start для не администратора
  Future<void> _handleNonAdminStart(Context ctx) async {
    await ctx.reply(BotMessages.unauthorizedAccess);
  }
}
