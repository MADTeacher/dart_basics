import 'dart:math';

import 'package:common/board.dart';
import 'board_helper.dart';
import 'difficulty_strategy.dart';
import 'medium_strategy.dart';

final Random _random = Random();

// Стратегия сложного уровня сложности
// Используем алгоритм минимакс для оптимального хода при
// небольших досках (3x3) и эвристическую стратегию при
// больших досках для уменьшения нагрузки на ЦП
class HardStrategy implements DifficultyStrategy {
  final MediumStrategy _mediumStrategy = const MediumStrategy();

  const HardStrategy();

  @override
  Future<({int row, int col})> makeMove(Board board, Cell figure) async {
    // Если доска пустая, ходим в центр или угол (оптимальный первый ход)
    List<List<int>> emptyCells = BoardHelper.getEmptyCells(board);
    if (emptyCells.length == board.size * board.size) {
      return _makeFirstMove(board);
    }

    // Для небольших досок (3x3) используем полный минимакс
    if (board.size <= 4) {
      return _makeMinimaxMove(board, figure, emptyCells);
    }

    // Для больших досок используем среднюю стратегию
    return _mediumStrategy.makeMove(board, figure);
  }

  // Делаем оптимальный первый ход (центр или угол)
  ({int row, int col}) _makeFirstMove(Board board) {
    int center = board.size ~/ 2;

    // 50% шанс выбрать центр на нечетной доске
    if (_random.nextInt(2) == 0 && board.size % 2 == 1) {
      return (row: center, col: center);
    } else {
      List<List<int>> corners = [
        [0, 0],
        [0, board.size - 1],
        [board.size - 1, 0],
        [board.size - 1, board.size - 1],
      ];
      List<int> randomCorner = corners[_random.nextInt(corners.length)];
      return (row: randomCorner[0], col: randomCorner[1]);
    }
  }

  // Выполняем ход используя алгоритм минимакс
  ({int row, int col}) _makeMinimaxMove(
    Board board,
    Cell figure,
    List<List<int>> emptyCells,
  ) {
    int bestScore = -1000;
    List<int> bestMove = [-1, -1];

    // Рассматриваем все свободные клетки
    for (List<int> cell in emptyCells) {
      int row = cell[0];
      int col = cell[1];

      // Пробуем сделать ход
      board.cells[row][col] = figure;

      // Вычисляем оценку хода через минимакс
      int score = _minimax(board, figure, 0, false);

      // Возвращаем клетку в исходное состояние
      board.cells[row][col] = Cell.empty;

      // Обновляем лучший ход
      if (score > bestScore) {
        bestScore = score;
        bestMove = [row, col];
      }
    }

    return (row: bestMove[0], col: bestMove[1]);
  }

  // Алгоритм минимакс для определения оптимального хода
  int _minimax(Board board, Cell figure, int depth, bool isMaximizing) {
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

    if (isMaximizing) {
      return _maximizingPlayer(board, figure, depth, emptyCells);
    } else {
      return _minimizingPlayer(board, figure, depth, emptyCells);
    }
  }

  // Максимизирующий игрок (компьютер)
  int _maximizingPlayer(
    Board board,
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

      // Рекурсивно оцениваем ход
      int score = _minimax(board, figure, depth + 1, false);

      // Отменяем ход
      board.cells[row][col] = Cell.empty;

      bestScore = max(score, bestScore);
    }

    return bestScore;
  }

  // Минимизирующий игрок (противник)
  int _minimizingPlayer(
    Board board,
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

      // Рекурсивно оцениваем ход
      int score = _minimax(board, figure, depth + 1, true);

      // Отменяем ход
      board.cells[row][col] = Cell.empty;

      bestScore = min(score, bestScore);
    }

    return bestScore;
  }

  // Возвращаем максимум из двух чисел
  int max(int a, int b) {
    return a > b ? a : b;
  }

  // Возвращаем минимум из двух чисел
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
