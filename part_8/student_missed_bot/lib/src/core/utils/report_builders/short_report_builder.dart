import 'base_report_builder.dart';

// Класс для построения краткого отчета
class ShortReportBuilder extends BaseReportBuilder {
  ShortReportBuilder({
    required super.db,
    required super.groupId,
    required super.disciplineId,
    required super.tempReportDir,
  }) : super(reportType: 'ShortReport');

  @override
  Future<void> buildReport() async {
    await initialize();

    // Запрашиваем данные о пропусках студентов группы по дисциплине
    final result = await db.missedClassDao.countMissedClasses(
      groupId,
      disciplineId,
    );
    final totalClasses = result.totalClasses;
    final performances = result.performances;

    int row = 0;

    // Устанавливаем заголовки
    setCell(row, BaseReportBuilder.studentNameColumn, 'ФИО студента');
    setCell(row, BaseReportBuilder.numberOfPassesColumn, 'Пропущено занятий');
    row++;

    // Заполняем данные студентов
    for (final performance in performances) {
      // Устанавливаем имя студента
      setCell(
        row,
        BaseReportBuilder.studentNameColumn,
        performance.studentName,
      );
      // Устанавливаем количество пропусков
      setCell(
        row,
        BaseReportBuilder.numberOfPassesColumn,
        performance.numberOfPasses,
      );
      // рассчитываем процент пропусков. Если он больше 25%,
      //то устанавливаем красный цвет, иначе зеленый
      final missPercent = totalClasses > 0
          ? performance.numberOfPasses / totalClasses
          : 0;
      final color = missPercent > 0.25
          ? BaseReportBuilder.redFill
          : BaseReportBuilder.greenFill;
      setCellColor(row, BaseReportBuilder.numberOfPassesColumn, color);

      row++; // Переходим к следующей строке
    }

    // Устанавливаем информацию о всего занятиях
    row++;
    setCell(row, BaseReportBuilder.studentNameColumn, 'Всего занятий');
    row++;
    setCell(row, BaseReportBuilder.studentNameColumn, totalClasses);
  }
}
