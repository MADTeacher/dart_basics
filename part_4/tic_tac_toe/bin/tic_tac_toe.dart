import 'dart:io';

import 'package:tic_tac_toe/tic_tac_toe.dart';

void main() {
  int? size;
  while (true) {
    stdout.write('Enter the size of the board (3-9): ');
    size = int.tryParse(stdin.readLineSync()!);
    size ??= 3;
    if (size < 3 || size > 9) {
      continue;
    }
    break;
  }

  Board board = Board(size);
  Player player = Player(Cell.cross);
  Game game = Game(board, player);
  game.play();
}