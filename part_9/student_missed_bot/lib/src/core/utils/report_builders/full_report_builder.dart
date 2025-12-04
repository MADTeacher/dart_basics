import 'base_report_builder.dart';

// Класс для построения полного отчета с датами пропусков
class FullReportBuilder extends BaseReportBuilder {
  FullReportBuilder({
    required super.db,
    required super.groupId,
    required super.disciplineId,
    required super.tempReportDir,
  }) : super(reportType: 'FullReport');

  @override
  Future<void> buildReport() async {
    await initialize();
    // Запрашиваем данные о пропусках студентов группы
    // по дисциплине с датами пропусков
    final performances = await db.missedClassDao.getMissedClassesWithDays(
      groupId,
      disciplineId,
    );

    // Если нет данных, устанавливаем сообщение в первую ячейку
    if (performances.isEmpty) {
      setCell(0, 0, 'Нет данных');
      return;
    }

    // Собираем все уникальные даты пропусков
    final dates = <DateTime>{};
    for (final p in performances) {
      for (final m in p.missedData) {
        dates.add(m.day);
      }
    }
    // Сортируем даты пропусков
    final sortedDates = dates.toList()..sort();

    // Инициализируем строку и столбец
    int row = 0;
    int col = 0;

    // Устанавливаем заголовки
    setCell(row, col++, 'ФИО студента');
    setCell(row, col++, 'Пропущено');

    // Устанавливаем заголовки дат пропусков
    for (final date in sortedDates) {
      // Проверяем, есть ли другие занятия в этот же день
      final sameDay = sortedDates.where(
        (d) =>
            d.day == date.day && d.month == date.month && d.year == date.year,
      );

      // Если несколько занятий в день - добавляем время
      final header = sameDay.length > 1
          ? '${date.day}.${date.month} '
                '${date.hour.toString().padLeft(2, '0')}:'
                '${date.minute.toString().padLeft(2, '0')}'
          : '${date.day}.${date.month}';

      setCell(row, col++, header);
    }
    row++;

    // Заполняем данные студентов
    for (final performance in performances) {
      col = 0; // Сбрасываем столбец в начало
      // Устанавливаем имя студента
      setCell(row, col++, performance.studentName);

      // Устанавливаем количество пропусков
      final missedCount = performance.missedData
          .where((m) => m.isMissed)
          .length;
      setCell(row, col++, missedCount);

      // Устанавливаем отметки по датам
      for (final date in sortedDates) {
        // Ищем запись с точным совпадением DateTime (включая время)
        final missedInfo = performance.missedData.firstWhere(
          (m) => m.day == date,
          orElse: () => throw StateError('Date not found'),
        );

        final mark = missedInfo.isMissed ? 'Н' : 'П';
        final color = missedInfo.isMissed
            ? BaseReportBuilder.redFill
            : BaseReportBuilder.greenFill;

        setCell(row, col, mark); // Устанавливаем отметку
        setCellColor(row, col, color); // Устанавливаем цвет
        col++; // Переходим к следующему столбцу
      }

      row++; // Переходим к следующей строке
    }
  }
}
