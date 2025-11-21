import '../../board/board.dart';
import '../../board/cell_type.dart';
import 'board_helper.dart';
import 'difficulty_strategy.dart';
import 'easy_strategy.dart';

// Стратегия среднего уровня сложности
// Проверяем возможность выигрыша или блокируем выигрыш противника
class MediumStrategy implements DifficultyStrategy {
  final EasyStrategy _easyStrategy = const EasyStrategy();

  const MediumStrategy();

  @override
  Future<({int row, int col})> makeMove(Board board, Cell figure) async {
    // Проверяем, можем ли мы выиграть за один ход
    List<int>? move = BoardHelper.findWinningMove(board, figure);
    if (move != null) {
      return (row: move[0], col: move[1]);
    }

    // Проверяем, нужно ли блокировать победу противника
    Cell opponentFigure = BoardHelper.getOpponentFigure(figure);

    move = BoardHelper.findWinningMove(board, opponentFigure);
    if (move != null) {
      return (row: move[0], col: move[1]);
    }

    // Занимаем центр, если свободен (хорошая стратегия)
    int center = board.size ~/ 2;
    if (board.cells[center][center] == Cell.empty) {
      return (row: center, col: center);
    }

    // Занимаем угол, если свободен
    List<List<int>> corners = [
      [0, 0],
      [0, board.size - 1],
      [board.size - 1, 0],
      [board.size - 1, board.size - 1],
    ];

    for (List<int> corner in corners) {
      if (board.cells[corner[0]][corner[1]] == Cell.empty) {
        return (row: corner[0], col: corner[1]);
      }
    }

    // Если нет лучшего хода, делаем случайный ход
    return _easyStrategy.makeMove(board, figure);
  }
}
