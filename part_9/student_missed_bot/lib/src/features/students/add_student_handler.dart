import 'package:televerse/televerse.dart';
import '../../core/database/interfaces/i_group_dao.dart';
import '../../core/database/interfaces/i_student_dao.dart';
import '../../core/state/conversation_state.dart';
import '../../shared/constants/messages.dart';
import '../../shared/utils/inline_keyboard_helper.dart';

// Класс для обработки добавления студента
class AddStudentHandler {
  final Bot bot;
  final IGroupDao groupDao;
  final IStudentDao studentDao;
  final ConversationStateManager stateManager;

  // Regex для валидации ФИО (Фамилия Имя Отчество)
  static final _nameRegex = RegExp(
    r'^[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+\s[А-ЯЁ][а-яё]+$',
  );

  AddStudentHandler({
    required this.bot,
    required this.groupDao,
    required this.studentDao,
    required this.stateManager,
  });

  // Регистрируем handlers
  void register() {
    bot.command('addstudent', _handleAddStudentCommand);
    bot.callbackQuery(RegExp(r'^groupClick_'), _handleGroupSelection);
    bot.filter(_isWaitingStudentName, _handleStudentName);
  }

  // Проверяем, находится ли пользователь в состоянии 
  // ожидания ввода имени студента
  bool _isWaitingStudentName(Context ctx) {
    final userId = ctx.from?.id;
    if (userId == null) return false;
    return stateManager.getState(userId) == BotState.waitingStudentName;
  }

  // Обработчик команды добавления студента
  Future<void> _handleAddStudentCommand(Context ctx) async {
    final userId = ctx.from?.id;
    if (userId == null) return;

    // Получаем список групп
    final groups = await groupDao.getAll();
    // Создаем клавиатуру для выбора группы
    final keyboard = InlineKeyboardBuilder.createGroupButtons(
      groups,
      'groupClick',
    );

    // Отправляем сообщение с клавиатурой
    await ctx.reply(BotMessages.selectGroup, replyMarkup: keyboard);
  }

  // Обработчик выбора группы для добавления студента
  Future<void> _handleGroupSelection(Context ctx) async {
    final callbackData = ctx.callbackQuery!.data!;

    final parts = callbackData.split('_');
    if (parts.length != 2) return;

    final groupId = int.tryParse(parts[1]);
    if (groupId == null) return;

    // Устанавливаем состояние ожидания ввода имени студента
    stateManager.setState(
      ctx.from!.id,
      BotState.waitingStudentName,
      data: {'groupId': groupId},
    );

    // Редактируем сообщение с запросом имени студента
    await ctx.editMessageText(BotMessages.enterStudentName);
  }

  // Обработчик ввода имени студента и его добавления в базу данных
  Future<void> _handleStudentName(Context ctx) async {
    // Получаем ID пользователя и имя студента
    final userId = ctx.from?.id;
    final fullName = ctx.message?.text;

    // Проверяем, что пользователь и имя студента не равны null
    if (userId == null || fullName == null) return;

    // Валидация ФИО
    if (!_nameRegex.hasMatch(fullName)) {
      await ctx.reply(BotMessages.invalidNameFormat);
      return;
    }
    // Получаем данные состояния пользователя
    final data = stateManager.getData(userId);
    if (data == null) return;

    final groupId = data['groupId'] as int?;
    if (groupId == null) return;

    // Добавляем студента
    await studentDao.add(groupId, fullName);
    stateManager.deleteState(userId);
    // Отправляем сообщение о том, что студент добавлен
    await ctx.reply(BotMessages.studentAdded);
  }
}
