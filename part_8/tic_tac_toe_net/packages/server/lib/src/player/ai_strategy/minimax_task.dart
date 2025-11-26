import 'dart:isolate';

import 'package:common/board.dart';

// Задача для вычисления в изоляте
// Содержит все необходимые данные для оценки хода
class MinimaxTask {
  final BoardState boardState; // Состояние доски
  final Cell figure; // Фигура компьютера
  final int row; // Ряд хода
  final int col; // Колонка хода

  // Максимальная глубина поиска (null = без ограничений)
  final int? maxDepth;

  // Порт для отправки результата обратно
  final SendPort responsePort;

  const MinimaxTask({
    required this.boardState,
    required this.figure,
    required this.row,
    required this.col,
    required this.responsePort,
    this.maxDepth,
  });
}

// Результат вычисления в изоляте
class MinimaxResult {
  final int row; // Ряд хода
  final int col; // Колонка хода
  final int score; // Оценка хода

  const MinimaxResult({
    required this.row,
    required this.col,
    required this.score,
  });
}
