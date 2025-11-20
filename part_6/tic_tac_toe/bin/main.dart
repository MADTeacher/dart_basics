import 'dart:io';

import 'package:tic_tac_toe/tic_tac_toe.dart';

void main() async {
  var saver = JsonGameStorage();

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
          GameSnapshot? snapshot = saver.loadGame(fileName);
          if (snapshot != null) {
            game = Game.fromSnapshot(snapshot, saver);
            break;
          } else {
            print('Game not found');
          }
        }
        await game.play();

      case '2':
        Game game = Game.createCustomGame(saver);
        await game.play();
      case _:
        print('Exiting...');
        exit(0);
    }
  }
}
