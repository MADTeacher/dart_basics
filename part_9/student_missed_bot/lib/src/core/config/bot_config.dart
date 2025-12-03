import 'dart:io';
import 'package:path/path.dart' as path;

import '../utils/dotenv.dart';

// Класс конфигурации бота, загружаемой из .env файла
class BotConfig {
  final String botToken;
  final String databaseName;
  final int defaultAdminId;
  final String pathToConfigData;
  final String tempReportDir;

  BotConfig._({
    required this.botToken,
    required this.databaseName,
    required this.defaultAdminId,
    required this.pathToConfigData,
    required this.tempReportDir,
  });

  // Загружаем конфигурацию из .env файла
  static BotConfig load() {
    final env = DotEnv()..load();

    final botToken = env.getValue<String>('BOT_TOKEN');
    final databaseName = env.getValue<String>('DATABASE_NAME');
    final defaultAdminId = env.getValue<int>('DEFAULT_ADMIN');
    final pathToConfigData = env.getValue<String>('PATH_TO_CONFIG_DATA');
    final tempReportDir = env.getValue<String>('TEMP_REPORT_DIR');

    return BotConfig._(
      botToken: botToken,
      databaseName: databaseName,
      defaultAdminId: defaultAdminId,
      pathToConfigData: pathToConfigData,
      tempReportDir: tempReportDir,
    );
  }

  // Создаем директорию для временных отчетов если не существует
  void ensureTempReportDirExists() {
    final dir = Directory(tempReportDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  // Возвращаем путь к базе данных
  String get dbPath {
    return path.join(Directory.current.path, '$databaseName.db');
  }
}
