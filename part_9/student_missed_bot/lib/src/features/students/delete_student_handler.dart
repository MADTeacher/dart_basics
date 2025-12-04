import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_group_dao.dart';
import '../../core/database/interfaces/i_student_dao.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки удаления студента
class DeleteStudentHandler {
  final Bot bot;
  final IGroupDao groupDao;
  final IStudentDao studentDao;

  static const int pageSize = 7;

  DeleteStudentHandler({
    required this.bot,
    required this.groupDao,
    required this.studentDao,
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
    // Получаем список групп
    final groups = await groupDao.getAll();
    // Создаем клавиатуру для выбора группы
    var keyboard = InlineKeyboard();
    for (final group in groups) {
      keyboard = keyboard
          .text(group.name, 'groupForDelClick_0_${group.id}')
          .row();
    }
    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы для удаления студента
  Future<void> _handleGroupSelection(Context ctx) async {
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    final parts = callbackData.split('_');
    // Проверяем, что callback data содержит 3 части
    if (parts.length != 3) return;
    // Получаем номер страницы и ID группы
    final paginator = int.tryParse(parts[1]) ?? 0;
    final groupId = int.tryParse(parts[2]);
    // Проверяем, что ID группы не равны null
    if (groupId == null) return;

    // Получаем список студентов группы
    final students = await studentDao.getByGroupId(groupId);

    // Создаем клавиатуру для выбора студента
    final keyboard = InlineKeyboardBuilder.createPaginatedList(
      allItems: students,
      paginator: paginator,
      pageSize: pageSize,
      textBuilder: (s) => s.fullName,
      dataBuilder: (s) => 'studDelClick_${s.id}',
      prevPageCallback: 'groupForDelClick_${paginator - 1}_$groupId',
      nextPageCallback: 'groupForDelClick_${paginator + 1}_$groupId',
    );

    // Редактируем сообщение с клавиатурой
    await ctx.editMessageText(
      BotMessages.selectStudentToDelete,
      replyMarkup: keyboard,
    );
  }

  // Обработчик удаления студента
  Future<void> _handleStudentDeletion(Context ctx) async {
    // Получаем callback data
    final callbackData = ctx.callbackQuery!.data!;
    // Разбираем callback data на части
    // Проверяем, что callback data содержит 2 части
    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final studentId = int.tryParse(parts[1]);
    if (studentId == null) return;
    // Удаляем студента
    await studentDao.deleteStudent(studentId);
    // Редактируем сообщение 
    await ctx.editMessageText(BotMessages.studentDeleted);
  }
}
