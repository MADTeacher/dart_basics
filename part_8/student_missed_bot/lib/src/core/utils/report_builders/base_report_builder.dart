import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;
import '../../database/interfaces/i_database_provider.dart';


abstract class BaseReportBuilder {
  final IDatabaseProvider db;
  final int groupId;
  final int disciplineId;
  final String reportType;
  final String tempReportDir;

  late final Excel excel;
  late final Sheet sheet;
  late final String groupName;
  late final String disciplineName;

  static const redFill = '#FF0000';
  static const greenFill = '#BDECB6';
  static const int studentNameColumn = 0;
  static const int numberOfPassesColumn = 1;

  BaseReportBuilder({
    required this.db,
    required this.groupId,
    required this.disciplineId,
    required this.reportType,
    required this.tempReportDir,
  });

  // Инициализируем Excel,получаем группу и дисциплину
  Future<void> initialize() async {
    excel = Excel.createExcel();

    final group = await db.groupDao.getById(groupId);
    final discipline = await db.disciplineDao.getById(disciplineId);

    if (group == null || discipline == null) {
      throw Exception('Группа или дисциплина не найдены');
    }

    groupName = group.name;
    disciplineName = discipline.name;

    excel.rename(excel.getDefaultSheet()!, disciplineName);
    sheet = excel[disciplineName];
  }

  // Виртуальный метод для построения отчета
  // Его необходимо переопределить в производных классах
  Future<void> buildReport();

  // Метод для установки значения в ячейку
  void setCell(int row, int col, dynamic value) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
    );
    cell.value = TextCellValue(value.toString());
  }

  // Метод для установки цвета ячейки
  void setCellColor(int row, int col, String color) {
    final cell = sheet.cell(
      CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row),
    );
    cell.cellStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString(color),
    );
  }

  // Метод для сохранения отчета
  Future<void> saveReport() async {
    final dir = Directory(tempReportDir);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    final fileName = '${disciplineName}_${reportType}_$groupName.xlsx';
    final filePath = p.join(tempReportDir, fileName);
    final fileBytes = excel.save();

    if (fileBytes != null) {
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
    }
  }

  // Метод для получения пути к отчету
  String getReportPath() {
    final fileName = '${disciplineName}_${reportType}_$groupName.xlsx';
    return p.join(tempReportDir, fileName);
  }
}
