import 'dart:isolate';
import 'dart:math';

import '../../board/board_state.dart';
import '../../board/cell_type.dart';
import 'board_helper.dart';
import 'minimax_task.dart';

// Точка входа в изолят, отвечающая за вычисление
// алгоритма минимакса с ограничением глубины
void minimaxWorker(SendPort sendPort) {
  // Создаем порт для получения сообщений
  final receivePort = ReceivePort();

  // Отправляем SendPort обратно в главный изолят
  sendPort.send(receivePort.sendPort);

  // Слушаем входящие задачи
  receivePort.listen((message) {
    if (message is MinimaxTask) {
      // Вычисляем оценку хода
      final score = _evaluateMove(message);

      // Создаем результат
      final result = MinimaxResult(
        row: message.row,
        col: message.col,
        score: score,
      );

      // Отправляем результат обратно в главный изолят
      message.responsePort.send(result);
    }
  });
}

// Функция для оценивания одного конкретного хода
int _evaluateMove(MinimaxTask task) {
  // Делаем ход на копии доски
  task.boardState.cells[task.row][task.col] = task.figure;

  // Вычисляем оценку через минимакс
  // (с ограничением глубины или без)
  final score = task.maxDepth != null
      ? _minimaxWithDepthLimit(
          task.boardState,
          task.figure,
          task.maxDepth!,
          false,
        )
      : _minimax(task.boardState, task.figure, 0, false);

  // Возвращаем клетку в исходное состояние
  task.boardState.cells[task.row][task.col] = Cell.empty;

  return score; // Возвращаем оценку
}

// Функция реализующая алгоритм минимакс для
// определения оптимального хода
int _minimax(BoardState board, Cell figure, int depth, bool isMaximizing) {
  Cell opponentFigure = BoardHelper.getOpponentFigure(figure);

  // Проверяем терминальное состояние
  if (board.checkWin(figure)) {
    return 10 - depth; // Выигрыш, чем быстрее, тем лучше
  } else if (board.checkWin(opponentFigure)) {
    return depth - 10; // Проигрыш, чем дольше, тем лучше
  } else if (board.checkDraw()) {
    return 0; // Ничья
  }

  List<List<int>> emptyCells = BoardHelper.getEmptyCells(board);

  // Рекурсивно оцениваем ход
  if (isMaximizing) {
    return _maximizingPlayer(board, figure, depth, emptyCells);
  } else {
    return _minimizingPlayer(board, figure, depth, emptyCells);
  }
}

// Функция, моделирующая ходы максимизирующего игрока (компьютер),
// нацеленного на получение наибольшей оценки. Т.е его цель -
// победить противника или сделать ничью
int _maximizingPlayer(
  BoardState board,
  Cell figure,
  int depth,
  List<List<int>> emptyCells,
) {
  int bestScore = -1000;

  // Проходим по всем свободным клеткам
  for (List<int> cell in emptyCells) {
    int row = cell[0];
    int col = cell[1];

    // Делаем ход
    board.cells[row][col] = figure;

    // Получаем оценку хода для "кожаного мешка"
    int score = _minimax(board, figure, depth + 1, false);

    // Отменяем ход
    board.cells[row][col] = Cell.empty;

    // Обновляем лучшую оценку
    bestScore = max(score, bestScore);
  }

  return bestScore;
}

// Функция, моделирующая ходы минимизирующего игрока (человека), нацеленного
// на получение наименьшей оценки. Т.е его цель - не дать компьютеру
// выиграть или сделать ничью
int _minimizingPlayer(
  BoardState board,
  Cell figure,
  int depth,
  List<List<int>> emptyCells,
) {
  int bestScore = 1000;
  Cell opponentFigure = BoardHelper.getOpponentFigure(figure);

  // Проходим по всем свободным клеткам
  for (List<int> cell in emptyCells) {
    int row = cell[0];
    int col = cell[1];

    // Делаем ход противника
    board.cells[row][col] = opponentFigure;

    // Оцениваем возможный ход компьютера
    int score = _minimax(board, figure, depth + 1, true);

    // Отменяем ход
    board.cells[row][col] = Cell.empty;

    // Обновляем лучшую оценку
    bestScore = min(score, bestScore);
  }

  return bestScore;
}

// Функция, реализующая алгоритм минимакс с
// ограничением по глубине рекурсии
int _minimaxWithDepthLimit(
  BoardState board,
  Cell figure,
  int maxDepth,
  bool isMaximizing,
) {
  final opponentFigure = BoardHelper.getOpponentFigure(figure);

  // Проверяем терминальное состояние
  if (board.checkWin(figure)) {
    return 100;
  } else if (board.checkWin(opponentFigure)) {
    return -100;
  } else if (board.checkDraw()) {
    return 0;
  }

  // Достигли максимальной глубины - эвристическая оценка
  if (maxDepth == 0) {
    return _evaluatePosition(board, figure);
  }

  final emptyCells = BoardHelper.getEmptyCells(board);

  if (isMaximizing) {
    // Моделируем ходы максимизирующего игрока,
    // нацеленного на получение наибольшей оценки
    int bestScore = -1000;

    for (final cell in emptyCells) {
      board.cells[cell[0]][cell[1]] = figure;
      final score = _minimaxWithDepthLimit(board, figure, maxDepth - 1, false);
      board.cells[cell[0]][cell[1]] = Cell.empty;

      if (score > bestScore) {
        bestScore = score;
      }
    }

    return bestScore;
  } else {
    // Моделируем ходы минимизирующего игрока,
    // нацеленного на получение наименьшей оценки
    int bestScore = 1000;

    for (final cell in emptyCells) {
      board.cells[cell[0]][cell[1]] = opponentFigure;
      final score = _minimaxWithDepthLimit(board, figure, maxDepth - 1, true);
      board.cells[cell[0]][cell[1]] = Cell.empty;

      if (score < bestScore) {
        bestScore = score;
      }
    }

    return bestScore;
  }
}

// Функция эвристической оценки позиции, вычисляющая оценку на основе
// потенциальных выигрышных линий. Вызывается при достижении
// максимальной глубины рекурсии
int _evaluatePosition(BoardState board, Cell figure) {
  final opponentFigure = BoardHelper.getOpponentFigure(figure);
  int score = 0;

  // Считаем потенциальные линии, которые
  // могут быть использованы для выигрыша
  score += _countPotentialLines(board, figure) * 3;
  score -= _countPotentialLines(board, opponentFigure) * 3;

  // Бонус за центр
  final center = board.size ~/ 2;
  if (board.cells[center][center] == figure) {
    score += 5;
  } else if (board.cells[center][center] == opponentFigure) {
    score -= 5;
  }

  return score;
}

// Подсчитываем количество потенциальных выигрышных линий,
// которые могут быть использованы для выигрыша
int _countPotentialLines(BoardState board, Cell figure) {
  int count = 0;

  // Проверяем строки
  for (int i = 0; i < board.size; i++) {
    if (_canWinInLine(board.cells[i], figure)) {
      count++;
    }
  }

  // Проверяем колонки
  for (int j = 0; j < board.size; j++) {
    final column = List.generate(board.size, (i) => board.cells[i][j]);
    if (_canWinInLine(column, figure)) {
      count++;
    }
  }

  // Проверяем диагонали
  final diag1 = List.generate(board.size, (i) => board.cells[i][i]);
  if (_canWinInLine(diag1, figure)) {
    count++;
  }

  final diag2 = List.generate(
    board.size,
    (i) => board.cells[i][board.size - i - 1],
  );
  if (_canWinInLine(diag2, figure)) {
    count++;
  }

  return count;
}

// Проверяем, можно ли выиграть в этой линии
bool _canWinInLine(List<Cell> line, Cell figure) {
  final opponentFigure = BoardHelper.getOpponentFigure(figure);

  // Если есть фигура противника - линия заблокирована
  if (line.contains(opponentFigure)) {
    return false;
  }

  // Линия свободна или содержит наши фигуры
  return true;
}
