import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_group_dao.dart';
import '../../core/database/interfaces/i_student_dao.dart';
import '../../core/middleware/admin_filter.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки удаления студента
class DeleteStudentHandler {
  final Bot bot;
  final IGroupDao groupDao;
  final IStudentDao studentDao;
  final AdminFilter adminFilter;

  static const int pageSize = 7;

  DeleteStudentHandler({
    required this.bot,
    required this.groupDao,
    required this.studentDao,
    required this.adminFilter,
  });

  // Регистрируем handlers
  void register() {
    bot.command('delstudent', _handleDeleteStudentCommand);
    bot.callbackQuery(RegExp(r'^groupForDelClick_'), _handleGroupSelection);
    bot.callbackQuery(RegExp(r'^studDelClick_'), _handleStudentDeletion);
  }

  // Обработчик команды удаления студента
  Future<void> _handleDeleteStudentCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    final isAdmin = adminFilter.isAdmin(userId);
    if (!isAdmin) {
      await ctx.reply(BotMessages.unauthorizedAccess);
      return;
    }

    final groups = await groupDao.getAll();
    var keyboard = InlineKeyboard();
    for (final group in groups) {
      keyboard = keyboard
          .text(group.name, 'groupForDelClick_0_${group.id}')
          .row();
    }

    await ctx.reply(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы для удаления студента
  Future<void> _handleGroupSelection(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 3) return;

    final paginator = int.tryParse(parts[1]) ?? 0;
    final groupId = int.tryParse(parts[2]);
    if (groupId == null) return;

    final students = await studentDao.getByGroupId(groupId);

    final keyboard = InlineKeyboardBuilder.createPaginatedList(
      allItems: students,
      paginator: paginator,
      pageSize: pageSize,
      textBuilder: (s) => s.fullName,
      dataBuilder: (s) => 'studDelClick_${s.id}',
      prevPageCallback: 'groupForDelClick_${paginator - 1}_$groupId',
      nextPageCallback: 'groupForDelClick_${paginator + 1}_$groupId',
    );

    await ctx.editMessageText(
      BotMessages.selectStudentToDelete,
      replyMarkup: keyboard,
    );
  }

  // Обработчик удаления студента
  Future<void> _handleStudentDeletion(Context ctx) async {
    final userId = ctx.from?.id;
    final callbackData = ctx.callbackQuery?.data;

    if (userId == null || callbackData == null) return;

    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final studentId = int.tryParse(parts[1]);
    if (studentId == null) return;

    await studentDao.deleteStudent(studentId);

    await ctx.editMessageText(BotMessages.studentDeleted);
  }
}
