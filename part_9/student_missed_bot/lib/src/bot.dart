import 'package:televerse/televerse.dart';
import 'core/config/bot_config.dart';
import 'core/database/database.dart';
import 'core/middleware/admin_filter.dart';
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
    // Start handler
    // Команда на запуск бота
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
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addGroupHandler.register();

    // Discipline handlers
    // Команда на добавление дисциплины
    final addDisciplineHandler = AddDisciplineHandler(
      bot: bot,
      disciplineDao: db.disciplineDao,
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addDisciplineHandler.register();

    // Команда на назначение дисциплины группе
    final assignDisciplineHandler = AssignDisciplineHandler(
      bot: bot,
      groupDao: db.groupDao,
      disciplineDao: db.disciplineDao,
      adminFilter: adminFilter,
    );
    assignDisciplineHandler.register();

    // Student handlers
    // Команда на добавление студента
    final addStudentHandler = AddStudentHandler(
      bot: bot,
      groupDao: db.groupDao,
      studentDao: db.studentDao,
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addStudentHandler.register();

    // Команда на удаление студента
    final deleteStudentHandler = DeleteStudentHandler(
      bot: bot,
      groupDao: db.groupDao,
      studentDao: db.studentDao,
      adminFilter: adminFilter,
    );
    deleteStudentHandler.register();

    // Presence check handler
    // Команда на проверку присутствия
    final presenceCheckHandler = PresenceCheckHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    presenceCheckHandler.register();

    // Report handlers
    // Команда на скачивание отчета
    final downloadReportHandler = DownloadReportHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
      tempReportDir: config.tempReportDir,
    );
    downloadReportHandler.register();

    // Interactive report handler
    // Команда на вывод интерактивного отчета
    final interactiveReportHandler = InteractiveReportHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
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
