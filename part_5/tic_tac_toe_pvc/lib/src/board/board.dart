import 'dart:io';

import 'cell_type.dart';

class Board {
  late List<List<Cell>> cells;
  final int size;

  Board(this.size) {
    cells = List.generate(size, (_) => List.filled(size, Cell.empty));
  }

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

  bool checkWin(Cell player) {
    // Check rows, columns and diagonals
    for (int i = 0; i < size; i++) {
      if (cells[i].every((cell) => cell == player)) return true;
      if (cells.every((row) => row[i] == player)) return true;
    }
    // Check diagonals
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

  factory Board.fromJson(Map<String, dynamic> json) {
    var board = Board(json['size']);
    board.cells = (json['cells'] as List)
        .map(
          (row) => (row as List)
              .map(
                (cell) => Cell.values.firstWhere((e) => e.toString() == cell),
              )
              .toList(),
        )
        .cast<List<Cell>>()
        .toList();
    return board;
  }
}
