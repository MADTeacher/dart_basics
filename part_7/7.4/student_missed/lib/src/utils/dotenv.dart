import 'dart:io';

final class DotEnv {
  // Регулярка для определения целых чисел
  static final _intPattern = RegExp(r'^-?\d+$');
  // Регулярка для определения булевых значений
  static final _boolPattern = RegExp(r'^true|false|True|False$');
  // Таблица для хранения значений окружения
  final Map<String, Object?> _env = {};

  /// Конструктор класса DotEnv
  /// [platformEnv] - флаг, указывающий, нужно ли загружать
  /// переменные окружения платформы
  DotEnv({bool platformEnv = false}) {
    if (platformEnv) {
      _env.addAll(_loadPlatformEnv());
    }
  }

  /// Метод для загрузки переменных окружения из .env файлов
  /// [pathsList] - список путей к .env файлам (по умолчанию ['.env'])
  void load([List<String> pathsList = const ['.env']]) {
    for (var path in pathsList) {
      final file = File.fromUri(Uri.file(path));
      if (!file.existsSync()) {
        throw Exception('.env file not found');
      }
      _env.addAll(_loadLocalEnv(file));
    }
  }

  /// Метод для загрузки переменных окружения платформы и их преобразования
  /// в соответствующие типы данных. Возвращает словарь с
  /// переменными окружения
  Map<String, Object?> _loadPlatformEnv() {
    var platformEnv = Platform.environment;
    Map<String, Object?> config = {};
    for (var MapEntry(:key, :value) in platformEnv.entries) {
      if (_intPattern.hasMatch(value)) {
        // Преобразование строки в целое число
        config[key] = int.parse(value);
      } else if (_boolPattern.hasMatch(value)) {
        // Преобразование строки в булево значение
        config[key] = (value == 'true') || (value == 'True');
      } else {
        // Оставляем значение как строку
        config[key] = value;
      }
    }
    return config;
  }

  /// Метод для получения значения переменной окружения по
  /// ключу с указанным типом
  /// [key] - ключ переменной окружения
  /// Возвращает значение с указанным типом T
  T getValue<T>(String key) {
    return _env[key] as T;
  }

  /// Оператор доступа к переменной окружения по ключу
  /// [key] - ключ переменной окружения
  /// Возвращает значение переменной окружения
  Object? operator [](String key) {
    return _env[key];
  }

  /// Метод для загрузки переменных окружения из локального .env файла
  /// [file] - объект File, представляющий .env файл.
  /// Возвращает словарь с переменными окружения
  static Map<String, Object?> _loadLocalEnv(File file) {
    // Чтение файла построчно
    final lines = file.readAsLinesSync();

    final config = <String, Object?>{};
    for (var line in lines) {
      // Разделение строки на ключ и значение по символу '='
      var parts = line.split('=');
      parts[0] = parts[0].trim();
      parts[1] = parts[1].trim();
      if (parts.length == 2) {
        if (_intPattern.hasMatch(parts[1])) {
          // Преобразование строки в целое число
          config[parts[0]] = int.parse(parts[1]);
        } else if (_boolPattern.hasMatch(parts[1])) {
          // Преобразование строки в булево значение
          config[parts[0]] = (parts[1] == 'true') || (parts[1] == 'True');
        } else {
          // Оставляем значение как строку
          config[parts[0]] = parts[1];
        }
      }
    }
    return config;
  }

  @override
  String toString() {
    return _env.toString();
  }
}