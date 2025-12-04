import 'dart:io';
import 'package:excel/excel.dart';

// Парсер Excel-файла с данными о студентах
class ExcelParser {
  final String filePath;

  ExcelParser(this.filePath);

  // Парсим файл и возвращаем структуру: 
  // дисциплина -> группа -> [студенты]
  Map<String, Map<String, List<String>>> parse() {
    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('Файл $filePath не найден');
    }
    // Читаем файл как массив байт
    final bytes = file.readAsBytesSync();
    // Декодируем байты в Excel-объект
    final excel = Excel.decodeBytes(bytes);

    // Создаем Map для хранения данных
    final Map<String, Map<String, List<String>>> data = {};

    // Проходим по всем листам Excel-объекта
    for (final sheetName in excel.tables.keys) {
      final sheet = excel.tables[sheetName];
      if (sheet == null) continue;

      // Формат имени листа: "Группа|Дисциплина"
      final parts = sheetName.split('|');
      if (parts.length != 2) continue;

      final groupName = parts[0].trim();
      final disciplineName = parts[1].trim();

      // Если дисциплина еще не добавлена в Map, добавляем ее
      if (!data.containsKey(disciplineName)) {
        data[disciplineName] = {};
      }

      // Добавляем пустую группу в Map
      data[disciplineName]![groupName] = [];

      // Читаем студентов из первого столбца (A)
      // и добавляем их в Map
      for (var row in sheet.rows) {
        final cell = row[0];
        if (cell?.value != null) {
          final studentName = cell!.value.toString().trim();
          if (studentName.isNotEmpty) {
            data[disciplineName]![groupName]!.add(studentName);
          }
        }
      }
    }

    // Возвращаем Map{
    //  "disciplineName": {
    //   "groupName": [studentNames]
    //  }
    // }
    return data;
  }
}
