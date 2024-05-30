import 'dart:io';

import 'board.dart';
import 'cell_type.dart';
import 'game_state.dart';
import 'player.dart';

class Game {
  final Board board;
  final Player currentPlayer;
  GameState state = GameState.playing;

  Game(this.board, this.currentPlayer);

  void updateState() {
    if (board.checkWin(Cell.cross)) {
      state = GameState.crossWin;
    } else if (board.checkWin(Cell.nought)) {
      state = GameState.noughtWin;
    } else if (board.checkDraw()) {
      state = GameState.draw;
    }
  }

  void play() {
    while (state == GameState.playing) {
      board.printBoard();
      StringBuffer buffer = StringBuffer();
      buffer.write("${currentPlayer.symbol}'s turn. ");
      buffer.write("Enter row and column (e.g. 1 2): ");
      stdout.write(buffer.toString());

      bool validInput = false;
      int? x, y;

      while (!validInput) {
        String? input = stdin.readLineSync();
        if (input == null) {
          print("Invalid input. Please try again.");
          continue;
        }
        if (input == 'q') {
          state = GameState.quit;
          break;
        }
        var inputList = input.split(' ');
        if (inputList.length != 2) {
          print("Invalid input. Please try again.");
          continue;
        }
        x = int.tryParse(inputList[1]);
        y = int.tryParse(inputList[0]);
        if (x == null ||
            y == null ||
            x < 1 ||
            x > board.size ||
            y < 1 ||
            y > board.size) {
          print("Invalid input. Please try again.");
          continue;
        }
        x -= 1;
        y -= 1;
        if (board.setSymbol(x, y, currentPlayer.cellType)) {
          updateState();
          currentPlayer.switchPlayer();
          validInput = true;
        } else {
          stdout.writeln('This cell is already occupied!');
        }
      }
    }

    board.printBoard();
    switch (state) {
      case GameState.crossWin:
        stdout.writeln('X wins!');
      case GameState.noughtWin:
        stdout.writeln('O wins!');
      case GameState.draw:
        stdout.writeln("It's a draw!");
      default:
        break;
    }
  }
}
