import 'dart:io';

import 'board_state.dart';
import 'cell_type.dart';

class Board extends BoardState {
  Board(super.size);
  Board.setup(int size, List<List<Cell>> cells) : super.setup(size, cells);

  factory Board.fromJson(Map<String, dynamic> json) {
    final int size = json['size'];
    final List<List<Cell>> cells = (json['cells'] as List)
        .map(
          (row) => (row as List)
              .map(
                (cell) => Cell.values.firstWhere((e) => e.toString() == cell),
              )
              .toList(),
        )
        .cast<List<Cell>>()
        .toList();
    return Board.setup(size, cells);
  }

  factory Board.fromBoardState(BoardState boardState) {
    return Board.setup(boardState.size, boardState.cells);
  }

  BoardState get boardState => this;

  void printBoard() {
    stdout.write('  ');
    for (int i = 0; i < size; i++) {
      stdout.write('${i + 1} ');
    }
    stdout.write('\n');

    for (int i = 0; i < size; i++) {
      stdout.write('${i + 1} ');
      for (int j = 0; j < size; j++) {
        switch (cells[i][j]) {
          case Cell.empty:
            stdout.write('. ');
          case Cell.cross:
            stdout.write('X ');
          case Cell.nought:
            stdout.write('O ');
        }
      }
      print('');
    }
  }

  bool _makeMove(int x, int y) {
    return cells[y][x] == Cell.empty;
  }

  bool setSymbol(int x, int y, Cell cellType) {
    if (_makeMove(x, y)) {
      cells[y][x] = cellType;
      return true;
    }
    return false;
  }

  Map<String, dynamic> toJson() {
    return {
      'size': size,
      'cells': cells
          .map(
            (List<Cell> row) =>
                row.map((Cell cell) => cell.toString()).toList(),
          )
          .toList(),
    };
  }
}
