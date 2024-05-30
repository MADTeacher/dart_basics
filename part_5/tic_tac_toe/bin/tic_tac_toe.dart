import 'dart:io';

import 'package:tic_tac_toe/tic_tac_toe.dart';

void main() {
  var saver = JsonGameStateWorker();
  int? size;

  while (true) {
    print('1 - load game');
    print('2 - new game');
    print('q - quit');
    var input = stdin.readLineSync()!;
    switch (input) {
      case '1':
        Game? game;
        while (true) {
          print('Input file name:');
          String? fileName = stdin.readLineSync();
          if (fileName == null) {
            print('Invalid input');
            continue;
          }
          game = saver.loadGame(fileName);
          if (game != null) {
            break;
          } else {
            print('Game not found');
          }
        }
        game.play();

      case '2':
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
        Game game = Game(board, player, saver);
        game.play();
      case _:
        print('Exiting...');
        exit(0);
    }
  }
}
