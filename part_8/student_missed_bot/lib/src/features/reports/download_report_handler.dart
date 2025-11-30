import 'dart:io';
import 'package:televerse/televerse.dart';
import '../../core/database/database.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';
import '../../core/utils/report_builders.dart';

// Тип отчета
enum ReportType { short, full }

// Класс для обработки загрузки отчетов
class DownloadReportHandler {
  final Bot bot;
  final SqliteDatabase db;
  final AdminFilter adminFilter;
  final String tempReportDir;

  DownloadReportHandler({
    required this.bot,
    required this.db,
    required this.adminFilter,
    required this.tempReportDir,
  });

  // Регистрируем handlers
  void register() {
    bot.command(
      'fullreport',
      (ctx) => _handleReportCommand(ctx, ReportType.full),
    );
    bot.command(
      'shortreport',
      (ctx) => _handleReportCommand(ctx, ReportType.short),
    );
    bot.hears(
      BotMessages.fullReport,
      (ctx) => _handleReportCommand(ctx, ReportType.full),
    );
    bot.hears(
      BotMessages.shortReport,
      (ctx) => _handleReportCommand(ctx, ReportType.short),
    );

    bot.callbackQuery(
      RegExp(r'^fullReport_'),
      (ctx) => _handleGroupSelection(ctx, ReportType.full),
    );
    bot.callbackQuery(
      RegExp(r'^shortReport_'),
      (ctx) => _handleGroupSelection(ctx, ReportType.short),
    );
    bot.callbackQuery(
      RegExp(r'^fullGrReport_'),
      (ctx) => _handleDisciplineSelection(ctx, ReportType.full),
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

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    final groups = await db.groupDao.getAll();
    final prefix = reportType == ReportType.full ? 'fullReport' : 'shortReport';
    final keyboard = InlineKeyboardBuilder.createGroupButtons(groups, prefix);

    await ctx.reply(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы
  Future<void> _handleGroupSelection(Context ctx, ReportType reportType) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final groupId = int.tryParse(parts[1]);
    if (groupId == null) return;

    final disciplines = await db.groupDao.getAssignedDisciplines(groupId);

    if (disciplines.isEmpty) {
      await ctx.editMessageText(BotMessages.noAssignedDisciplines);
      return;
    }

    if (disciplines.length == 1) {
      // Если только одна дисциплина, сразу создаем отчет
      await _createReport(
        ctx,
        userId,
        groupId,
        disciplines.first.id,
        reportType,
      );
      return;
    }

    // Показываем список дисциплин
    final prefix = reportType == ReportType.full
        ? 'fullGrReport'
        : 'shortGrReport';
    var keyboard = InlineKeyboard();

    for (final discipline in disciplines) {
      keyboard = keyboard
          .text(discipline.name, '${prefix}_${groupId}_${discipline.id}')
          .row();
    }

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
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final groupId = int.tryParse(parts[1]);
    final disciplineId = int.tryParse(parts[2]);

    if (groupId == null || disciplineId == null) return;

    await _createReport(ctx, userId, groupId, disciplineId, reportType);
  }

  // Обработчик создания отчета
  Future<void> _createReport(
    Context ctx,
    int userId,
    int groupId,
    int disciplineId,
    ReportType reportType,
  ) async {
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

      await ctx.editMessageText(BotMessages.reportReady);

      // Отправляем файл
      final file = File(builder.getReportPath());
      await ctx.replyWithDocument(InputFile.fromFile(file));
    } catch (e) {
      await ctx.editMessageText('Ошибка при создании отчета: $e');
    }
  }
}
