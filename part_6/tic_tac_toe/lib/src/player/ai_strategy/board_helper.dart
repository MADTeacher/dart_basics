import '../../board/board_state.dart';
import '../../board/cell_type.dart';

// Вспомогательный класс для работы с доской
class BoardHelper {
  // Получаем список пустых клеток
  static List<List<int>> getEmptyCells(BoardState board) {
    List<List<int>> emptyCells = [];

    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.cells[i][j] == Cell.empty) {
          emptyCells.add([i, j]);
        }
      }
    }

    return emptyCells;
  }

  // Ищем ход, приводящий к выигрышу
  static List<int>? findWinningMove(BoardState board, Cell figure) {
    for (List<int> cell in getEmptyCells(board)) {
      int row = cell[0];
      int col = cell[1];

      // Пробуем сделать ход
      board.cells[row][col] = figure;

      // Проверяем, приведет ли этот ход к выигрышу
      if (board.checkWin(figure)) {
        // Отменяем ход и возвращаем координаты
        board.cells[row][col] = Cell.empty;
        return [row, col];
      }

      // Отменяем ход
      board.cells[row][col] = Cell.empty;
    }

    return null; // Нет выигрышного хода
  }

  // Получаем противоположную фигуру
  static Cell getOpponentFigure(Cell figure) {
    return figure == Cell.cross ? Cell.nought : Cell.cross;
  }
}
