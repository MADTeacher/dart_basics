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

/// Главный класс бота
class AttendanceBot {
  final BotConfig config;
  final SqliteDatabase db;
  late final Bot bot;
  late final AdminFilter adminFilter;
  late final ConversationStateManager stateManager;

  AttendanceBot({required this.config, required this.db}) {
    bot = Bot(config.botToken);
    adminFilter = AdminFilter(config);
    stateManager = ConversationStateManager();
  }

  /// Зарегистрировать все handlers
  void registerHandlers() {
    // Start handler
    final startHandler = StartHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    startHandler.register();

    // Group handlers
    final addGroupHandler = AddGroupHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addGroupHandler.register();

    // Discipline handlers
    final addDisciplineHandler = AddDisciplineHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addDisciplineHandler.register();

    final assignDisciplineHandler = AssignDisciplineHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    assignDisciplineHandler.register();

    // Student handlers
    final addStudentHandler = AddStudentHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
      stateManager: stateManager,
    );
    addStudentHandler.register();

    final deleteStudentHandler = DeleteStudentHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    deleteStudentHandler.register();

    // Presence check handler
    final presenceCheckHandler = PresenceCheckHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    presenceCheckHandler.register();

    // Report handlers
    final downloadReportHandler = DownloadReportHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
      tempReportDir: config.tempReportDir,
    );
    downloadReportHandler.register();

    final interactiveReportHandler = InteractiveReportHandler(
      bot: bot,
      db: db,
      adminFilter: adminFilter,
    );
    interactiveReportHandler.register();

    print('Все handlers зарегистрированы');
  }

  /// Запустить бота
  Future<void> start() async {
    print('Запуск бота...');
    await bot.start();
  }
}
