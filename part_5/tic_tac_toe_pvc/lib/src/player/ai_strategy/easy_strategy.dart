import 'dart:math';

import '../../board/board.dart';
import '../../board/cell_type.dart';
import 'board_helper.dart';
import 'difficulty_strategy.dart';

final Random _random = Random();

// Стратегия легкого уровня сложности
// Выполняем случайный ход на свободную клетку
class EasyStrategy implements DifficultyStrategy {
  const EasyStrategy();

  @override
  ({int row, int col}) makeMove(Board board, Cell figure) {
    List<List<int>> emptyCells = BoardHelper.getEmptyCells(board);

    if (emptyCells.isEmpty) {
      return (row: -1, col: -1);
    }

    int randomIndex = _random.nextInt(emptyCells.length);
    return (row: emptyCells[randomIndex][0], col: emptyCells[randomIndex][1]);
  }
}
