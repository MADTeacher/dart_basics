import 'cell_type.dart';

class BoardState {
  final List<List<Cell>> cells;
  final int size;

  BoardState(this.size)
    : cells = List.generate(size, (_) => List.filled(size, Cell.empty));

  BoardState.setup(this.size, this.cells);

  bool checkWin(Cell player) {
    for (int i = 0; i < size; i++) {
      if (cells[i].every((cell) => cell == player)) return true;
      if (cells.every((row) => row[i] == player)) return true;
    }
    if (List.generate(
      size,
      (i) => cells[i][i],
    ).every((cell) => cell == player)) {
      return true;
    }
    if (List.generate(
      size,
      (i) => cells[i][size - i - 1],
    ).every((cell) => cell == player)) {
      return true;
    }
    return false;
  }

  bool checkDraw() {
    return cells.every((row) => row.every((cell) => cell != Cell.empty));
  }
}
