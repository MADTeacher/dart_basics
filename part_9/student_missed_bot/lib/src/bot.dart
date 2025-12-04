import 'package:televerse/televerse.dart';
import 'core/config/bot_config.dart';
import 'core/database/database.dart';
import 'core/middleware/admin_filter.dart';
import 'core/middleware/admin_middleware_plugin.dart';
import 'core/state/conversation_state.dart';

import 'features/start/start_handler.dart';
import 'features/groups/add_group_handler.dart';
import 'features/disciplines/add_discipline_handler.dart';
import 'features/disciplines/assign_discipline_handler.dart';
import 'features/students/add_student_handler.dart';
import 'features/students/delete_student_handler.dart';
import 'features/presence/presence_check_handler.dart';
import 'features/reports/download_report_handler.dart';
import 'features/reports/interactive_report_handler.dart';

// Главный класс бота
class AttendanceBot {
  final BotConfig config;
  final SqliteDatabase db;
  late final Bot bot;
  // Фильтр для проверки прав администратора
  late final AdminFilter adminFilter;
  // Менеджер состояний диалогов
  late final ConversationStateManager stateManager;

  AttendanceBot({required this.config, required this.db}) {
    bot = Bot(config.botToken);
    adminFilter = AdminFilter(config);
    stateManager = ConversationStateManager();
  }

  // Метод для регистрации всех обработчиков команд и фильтров
  void registerHandlers() {
    // Первым устанавливаем middleware для проверки прав администратора
    // Обратите внимание, что он должен быть установлен 
    // ДО регистрации обработчиков команд
    bot.use(AdminMiddleware(
      adminFilter: adminFilter,
      adminCommands: [
        'addgroup',
        'adddiscipline',
        'discipline2group',
        'addstudent',
        'delstudent',
        'presencecheck',
        'fullreport',
        'shortreport',
        'interreport',
      ],
    ).handle);

    // Start handler
    // Команда на запуск бота
    // Примечание: /start не включена в плагин, так как имеет особую логику
    // для админа и не-админа (разные ответы)
    final startHandler = StartHandler(
      bot: bot,
      adminFilter: adminFilter,
    );
    startHandler.register();

    // Group handlers
    // Команда на добавление группы
    final addGroupHandler = AddGroupHandler(
      bot: bot,
      groupDao: db.groupDao,
      stateManager: stateManager,
    );
    addGroupHandler.register();

    // Discipline handlers
    // Команда на добавление дисциплины
    final addDisciplineHandler = AddDisciplineHandler(
      bot: bot,
      disciplineDao: db.disciplineDao,
      stateManager: stateManager,
    );
    addDisciplineHandler.register();

    // Команда на назначение дисциплины группе
    final assignDisciplineHandler = AssignDisciplineHandler(
      bot: bot,
      groupDao: db.groupDao,
      disciplineDao: db.disciplineDao,
    );
    assignDisciplineHandler.register();

    // Student handlers
    // Команда на добавление студента
    final addStudentHandler = AddStudentHandler(
      bot: bot,
      groupDao: db.groupDao,
      studentDao: db.studentDao,
      stateManager: stateManager,
    );
    addStudentHandler.register();

    // Команда на удаление студента
    final deleteStudentHandler = DeleteStudentHandler(
      bot: bot,
      groupDao: db.groupDao,
      studentDao: db.studentDao,
    );
    deleteStudentHandler.register();

    // Presence check handler
    // Команда на проверку присутствия
    final presenceCheckHandler = PresenceCheckHandler(
      bot: bot,
      db: db,
    );
    presenceCheckHandler.register();

    // Report handlers
    // Команда на скачивание отчета
    final downloadReportHandler = DownloadReportHandler(
      bot: bot,
      db: db,
      tempReportDir: config.tempReportDir,
    );
    downloadReportHandler.register();

    // Interactive report handler
    // Команда на вывод интерактивного отчета
    final interactiveReportHandler = InteractiveReportHandler(
      bot: bot,
      db: db,
    );
    interactiveReportHandler.register();

    print('Все handlers зарегистрированы');
  }

  // Метод для запуска бота
  Future<void> start() async {
    print('Запуск бота...');
    await bot.start();
  }
}
