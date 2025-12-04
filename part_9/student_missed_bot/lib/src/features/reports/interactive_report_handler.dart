import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки интерактивного отчета
class InteractiveReportHandler {
  final Bot bot;
  final SqliteDatabase db;

  static const int pageSize = 7;

  InteractiveReportHandler({required this.bot, required this.db});

  // Регистрируем handlers
  void register() {
    // Команда на вывод интерактивного отчета имеет два варианта запуска:
    // 1. Через команду /interreport
    // 2. Через текстовое сообщение "Интерактивный отчет"
    bot.command('interreport', _handleInteractiveReportCommand);
    bot.hears(BotMessages.interactiveReport, _handleInteractiveReportCommand);
    // Регистрируем обработчики, отвечающие за разные шаги
    // интерактивного отчета:
    // 1. Выбор дисциплины
    // 2. Выбор группы
    // 3. Выбор студента
    bot.callbackQuery(RegExp(r'^disReport_'), _handleDisciplineSelection);
    bot.callbackQuery(RegExp(r'^groupReport_'), _handleGroupSelection);
    bot.callbackQuery(RegExp(r'^studRepClick_'), _handleStudentSelection);
  }

  // Обработчик команды выбора дисциплины для интерактивного отчета
  Future<void> _handleInteractiveReportCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Получаем список дисциплин
    final disciplines = await db.disciplineDao.getAll();
    final keyboard = InlineKeyboardBuilder.createDisciplineButtons(
      disciplines,
      'disReport',
    );

    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectDiscipline, replyMarkup: keyboard);
  }

  // Обработчик выбора дисциплины для интерактивного отчета
  Future<void> _handleDisciplineSelection(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    // Проверяем, что callback data содержит 2 части
    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final disciplineId = int.tryParse(parts[1]);
    if (disciplineId == null) return;
    // Получаем список групп, назначенных дисциплине
    final groups = await db.disciplineDao.getAssignedGroups(disciplineId);
    // Создаем клавиатуру для выбора группы
    var keyboard = InlineKeyboard();
    for (final group in groups) {
      keyboard = keyboard
          .text(group.name, 'groupReport_0_${group.id}_$disciplineId')
          .row();
    }
    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(BotMessages.selectStudent, replyMarkup: keyboard);
  }

  // Обработчик выбора группы для интерактивного отчета
  Future<void> _handleGroupSelection(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    // Проверяем, что callback data содержит 4 части
    final parts = callbackData.split('_');
    if (parts.length != 4) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final groupId = int.tryParse(parts[2]);
    final disciplineId = int.tryParse(parts[3]);

    if (groupId == null || disciplineId == null) return;

    final students = await db.studentDao.getByGroupId(groupId);
    // Создаем клавиатуру для выбора студента
    final keyboard = InlineKeyboardBuilder.createPaginatedList(
      allItems: students,
      paginator: paginator,
      pageSize: pageSize,
      textBuilder: (s) => s.fullName,
      dataBuilder: (s) => 'studRepClick_${s.id}_$disciplineId',
      prevPageCallback:
          'groupReport_${paginator - 1}_$groupId'
          '_$disciplineId',
      nextPageCallback:
          'groupReport_${paginator + 1}_$groupId'
          '_$disciplineId',
    );
    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(BotMessages.selectStudent, replyMarkup: keyboard);
  }

  // Обработчик выбора студента для интерактивного отчета
  Future<void> _handleStudentSelection(Context ctx) async {
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final studentId = int.tryParse(parts[1]);
    final disciplineId = int.tryParse(parts[2]);

    if (studentId == null || disciplineId == null) return;
    // Получаем результаты академической успеваемости студента
    final result = await db.missedClassDao.getAcademicPerformance(
      studentId,
      disciplineId,
    );
    // Создаем текст с результатами академической успеваемости студента
    final text =
        'Студент: ${result.fullName}\n'
        'Пропущено занятий: ${result.missedCount}\n'
        'Всего занятий: ${result.totalCount}\n';
    // Редактируем сообщение, отправляя результаты
    // академической успеваемости студента
    await ctx.editMessageText(text);
  }
}
