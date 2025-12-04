import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_discipline_dao.dart';
import '../../core/database/interfaces/i_group_dao.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки привязки дисциплины к группе
class AssignDisciplineHandler {
  final Bot bot;
  final IGroupDao groupDao;
  final IDisciplineDao disciplineDao;

  AssignDisciplineHandler({
    required this.bot,
    required this.groupDao,
    required this.disciplineDao,
  });

  // Регистрируем handlers
  void register() {
    bot.command('discipline2group', _handleAssignDisciplineCommand);
    bot.callbackQuery(RegExp(r'^dis2group_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^applygroup_'), _handleGroupAssignment);
  }

  // Обработчик команды назначения дисциплины группе
  Future<void> _handleAssignDisciplineCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Получаем список дисциплин
    final disciplines = await disciplineDao.getAll();
    // Создаем клавиатуру для выбора дисциплины
    final keyboard = InlineKeyboardBuilder.createSimpleList(
      items: disciplines,
      textBuilder: (d) => d.name,
      dataBuilder: (d) => 'dis2group_${d.id}',
    );

    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectDiscipline, replyMarkup: keyboard);
  }

  // Обработчик выбора дисциплины
  Future<void> _handleDisciplineSelection(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    // Разбираем callback data на части
    final parts = callbackData.split('_');
    // Проверяем, что callback data содержит 2 части
    if (parts.length != 2) return;

    final disciplineId = int.tryParse(parts[1]);
    if (disciplineId == null) return;
    // Получаем список групп без назначенной дисциплины
    final groups = await groupDao.getGroupsWithoutDiscipline(disciplineId);

    if (groups.isEmpty) {
      // Отправляем сообщение о том, что нет групп для назначения
      await ctx.editMessageText(BotMessages.noGroupsToAssign);
      return;
    }

    // Создаем клавиатуру для выбора группы
    final keyboard = InlineKeyboardBuilder.createSimpleList(
      items: groups,
      textBuilder: (g) => g.name,
      dataBuilder: (g) => 'applygroup_${disciplineId}_${g.id}',
    );

    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик назначения группы дисциплине
  Future<void> _handleGroupAssignment(Context ctx) async {
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    // Проверяем, что callback data содержит 3 части
    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final disciplineId = int.tryParse(parts[1]);
    final groupId = int.tryParse(parts[2]);
    // Проверяем, что ID дисциплины и ID группы не равны null
    if (disciplineId == null || groupId == null) return;

    // Назначаем дисциплину группе
    await groupDao.assignDiscipline(groupId, disciplineId);
    // Редактируем сообщение
    await ctx.editMessageText(BotMessages.disciplineAssigned);
  }
}
