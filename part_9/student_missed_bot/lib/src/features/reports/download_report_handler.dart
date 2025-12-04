import 'dart:io';
import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';
import '../../core/utils/report_builders.dart';

// Тип отчета
enum ReportType { short, full }

// Класс для обработки загрузки отчетов
class DownloadReportHandler {
  final Bot bot;
  final SqliteDatabase db;
  final String tempReportDir;

  DownloadReportHandler({
    required this.bot,
    required this.db,
    required this.tempReportDir,
  });

  // Регистрируем handlers
  void register() {
    // Обработчики для полного отчета (full)
    bot.command(
      'fullreport',
      (ctx) => _handleReportCommand(ctx, ReportType.full),
    );
    bot.hears(
      BotMessages.fullReport,
      (ctx) => _handleReportCommand(ctx, ReportType.full),
    );
    bot.callbackQuery(
      RegExp(r'^fullReport_'),
      (ctx) => _handleGroupSelection(ctx, ReportType.full),
    );
    bot.callbackQuery(
      RegExp(r'^fullGrReport_'),
      (ctx) => _handleDisciplineSelection(ctx, ReportType.full),
    );

    // Обработчики для короткого отчета (short)
    bot.command(
      'shortreport',
      (ctx) => _handleReportCommand(ctx, ReportType.short),
    );
    bot.hears(
      BotMessages.shortReport,
      (ctx) => _handleReportCommand(ctx, ReportType.short),
    );
    bot.callbackQuery(
      RegExp(r'^shortReport_'),
      (ctx) => _handleGroupSelection(ctx, ReportType.short),
    );
    bot.callbackQuery(
      RegExp(r'^shortGrReport_'),
      (ctx) => _handleDisciplineSelection(ctx, ReportType.short),
    );
  }

  // Обработчик команды выбора группы для отчета
  Future<void> _handleReportCommand(Context ctx, ReportType reportType) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Получаем список групп
    final groups = await db.groupDao.getAll();
    // Определяем префикс для callback data
    // в зависимости от типа отчета
    final prefix = reportType == ReportType.full ? 'fullReport' : 'shortReport';
    // Создаем клавиатуру для выбора группы
    final keyboard = InlineKeyboardBuilder.createGroupButtons(groups, prefix);

    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы
  Future<void> _handleGroupSelection(Context ctx, ReportType reportType) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;

    // Разбираем callback data на части
    // Проверяем, что callback data содержит 2 части
    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final groupId = int.tryParse(parts[1]);
    if (groupId == null) return;
    // Получаем список дисциплин, назначенных группе
    final disciplines = await db.groupDao.getAssignedDisciplines(groupId);
    // Проверяем, что группа имеет назначенные дисциплины
    if (disciplines.isEmpty) {
      await ctx.editMessageText(BotMessages.noAssignedDisciplines);
      return;
    }

    // Если группа имеет только одну дисциплину,
    // то сразусоздаем отчет
    if (disciplines.length == 1) {
      await _createReport(
        ctx,
        ctx.from!.id,
        groupId,
        disciplines.first.id,
        reportType,
      );
      return;
    }

    // Создаем клавиатуру для выбора дисциплины,
    // в зависимости от типа отчета
    final prefix = reportType == ReportType.full
        ? 'fullGrReport'
        : 'shortGrReport';
    // Создаем клавиатуру для выбора дисциплины
    var keyboard = InlineKeyboard();
    // Добавляем кнопки для каждой дисциплины
    for (final discipline in disciplines) {
      keyboard = keyboard
          .text(discipline.name, '${prefix}_${groupId}_${discipline.id}')
          .row();
    }

    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(
      BotMessages.selectDiscipline,
      replyMarkup: keyboard,
    );
  }

  // Обработчик выбора дисциплины для отчета
  Future<void> _handleDisciplineSelection(
    Context ctx,
    ReportType reportType,
  ) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    // Проверяем, что callback data содержит 3 части
    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final groupId = int.tryParse(parts[1]);
    final disciplineId = int.tryParse(parts[2]);

    if (groupId == null || disciplineId == null) return;
    // Создаем отчет
    await _createReport(ctx, ctx.from!.id, groupId, disciplineId, reportType);
  }

  // Обработчик создания отчета
  Future<void> _createReport(
    Context ctx,
    int userId,
    int groupId,
    int disciplineId,
    ReportType reportType,
  ) async {
    // Редактируем сообщение с текстом о начале создания отчета
    await ctx.editMessageText(BotMessages.startingReport);

    try {
      // Создаем builder в зависимости от типа отчета
      late final BaseReportBuilder builder;

      if (reportType == ReportType.full) {
        builder = FullReportBuilder(
          db: db,
          groupId: groupId,
          disciplineId: disciplineId,
          tempReportDir: tempReportDir,
        );
      } else {
        builder = ShortReportBuilder(
          db: db,
          groupId: groupId,
          disciplineId: disciplineId,
          tempReportDir: tempReportDir,
        );
      }

      // Строим и сохраняем отчет
      await builder.buildReport();
      await builder.saveReport();
      // Редактируем сообщение с текстом о готовности отчета
      await ctx.editMessageText(BotMessages.reportReady);
      
      // Получаем путь к отчету
      final file = File(builder.getReportPath());
      // Отправляем файл
      await ctx.replyWithDocument(InputFile.fromFile(file));
    } catch (e) {
      // Редактируем сообщение с текстом о ошибке при создании отчета
      await ctx.editMessageText('Ошибка при создании отчета: $e');
    }
  }
}
