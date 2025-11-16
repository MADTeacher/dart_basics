import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:student_missed/app.dart';

void main(List<String> arguments) async {
  ConsoleHelpers.initialize();

  // Загрузка переменных окружения
  final env = DotEnv()..load();

  final databaseName = env.getValue<String>('DB_NAME');
  final tempReportDir = env.getValue<String>('TEMP_REPORT_DIR');
  final configDataPath = env.getValue<String>('PATH_TO_CONFIG_DATA');

  ConsoleHelpers.printInfo('Инициализация CLI приложения...');

  // Проверяем, является ли это первым запуском приложения
  // приложения (БД существует или нет)
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных. Если мы не укажем абсолютный путь,
  // то БД будет создана в следующей директории проекта:
  // .dart_tool\sqflite_common_ffi\databases
  String dbPath = p.join(appDocumentsDir.path, '$databaseName.db');
  final isFirstRun = _isFirstRun(dbPath);

  // Открываем соединение с базой данных
  final db = await SqliteDatabase.create(dbPath );

  // Создание экземпляра CLI-приложения
  final app = CliApp(
    db: db,
    tempReportDir: tempReportDir,
    configDataPath: configDataPath,
    isFirstRun: isFirstRun,
  );

  try {
    // Запускаем CLI приложение
    await app.start();
  } finally {
    // Закрываем соединение с базой данных
    await app.close();
  }
}

bool _isFirstRun(String dbPath) {
  final dbFile = File(dbPath);
  return !dbFile.existsSync();
}
