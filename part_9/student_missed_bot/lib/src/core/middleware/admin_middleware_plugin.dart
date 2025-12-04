import 'package:televerse/televerse.dart';
import '../../shared/constants/messages.dart';
import 'admin_filter.dart';

// Middleware для проверки прав администратора
// 
// Автоматически проверяет права администратора для указанных команд
// и блокирует выполнение для неавторизованных пользователей.
class AdminMiddleware<CTX extends Context> {
  // Фильтр для проверки прав администратора
  final AdminFilter adminFilter;
  // Список команд, требующих прав администратора
  final List<String> adminCommands;
  // Сообщение для неавторизованных пользователей
  final String unauthorizedMessage;

  AdminMiddleware({
    required this.adminFilter,
    required this.adminCommands,
    this.unauthorizedMessage = BotMessages.unauthorizedAccess,
  });

  // Обработчик middleware
  Future<void> handle(CTX ctx, NextFunction next) async {
    // Проверяем, является ли это командой, требующей прав администратора
    if (!ctx.hasCommand) {
      // Если это не команда, пропускаем
      await next();
      return;
    }

    // Получаем команду
    final command = ctx.command;
    if (command == null) {
      await next();
      return;
    }

    // Проверяем, требует ли команда прав администратора
    if (!adminCommands.contains(command.toLowerCase())) {
      await next();
      return;
    }

    // Проверяем права администратора
    final userId = ctx.from?.id;
    if (userId == null) {
      await next();
      return;
    }

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(unauthorizedMessage);
      return; // Не вызываем next(), блокируем выполнение
    }

    // Пользователь является администратором, продолжаем выполнение
    await next();
  }
}

