import 'dart:io';
import 'src/core/config/bot_config.dart';
import 'src/core/database/init_database.dart';
import 'src/bot.dart';

Future<void> runBot() async {
  print('=== Telegram Bot для учета посещаемости ===\n');

  // Загружаем конфигурацию
  print('Загрузка конфигурации...');
  final config = BotConfig.load();

  if (config.botToken.isEmpty) {
    print('ОШИБКА: BOT_TOKEN не указан в .env файле');
    exit(1);
  }

  // Создаем директорию для отчетов
  config.ensureTempReportDirExists();
  print('Директория для отчетов: ${config.tempReportDir}');

  // Инициализируем базу данных
  print('Инициализация базы данных...');
  final db = await SqliteDatabase.create(config.dbPath);

  final initializer = DatabaseInitializer(
    db: db,
    tempReportDir: config.tempReportDir,
    configDataPath: config.pathToConfigData,
    isFirstRun: _isFirstRun(config.dbPath),
  );
  await initializer.start();

  // Создаем и запускаем бота
  print('\nСоздание бота...');
  final bot = AttendanceBot(config: config, db: db);

  bot.registerHandlers();

  print('\nБот готов к работе!');
  print('Нажмите Ctrl+C для остановки\n');

  try {
    await bot.start();
  } catch (e) {
    print('ОШИБКА при запуске бота: $e');
    exit(1);
  } finally {
    await db.close();
  }
}

// Проверяем, первый ли это запуск бота или нет
bool _isFirstRun(String dbPath) {
  final dbFile = File(dbPath);
  return !dbFile.existsSync();
}
