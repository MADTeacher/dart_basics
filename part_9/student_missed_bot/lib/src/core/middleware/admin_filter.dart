import '../config/bot_config.dart';

// Фильтр для проверки прав администратора
class AdminFilter {
  final BotConfig config;

  AdminFilter(this.config);

  // Проверяем, является ли пользователь администратором
  bool isAdmin(int telegramId) {
    return telegramId == config.defaultAdminId;
  }
}

