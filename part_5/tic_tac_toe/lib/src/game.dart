import 'dart:io';

import 'board.dart';
import 'cell_type.dart';
import 'game_state.dart';
import 'i_game_saver.dart';
import 'player.dart';

class Game {
  final Board board;
  final Player currentPlayer;
  GameState state;
  GameSaver saver;

  Game(
    this.board,
    this.currentPlayer,
    this.saver, {
    this.state = GameState.playing,
  });

  void updateState() {
    if (board.checkWin(Cell.cross)) {
      state = GameState.crossWin;
    } else if (board.checkWin(Cell.nought)) {
      state = GameState.noughtWin;
    } else if (board.checkDraw()) {
      state = GameState.draw;
    }
  }

  bool saveCheck(String input) {
    if (input == "save") {
      print("Input file name:");
      String? fileName = stdin.readLineSync();
      if (fileName != null) {
        saver.saveGame(this, fileName);
      }
      return true;
    }
    return false;
  }

  void play() {
    while (state == GameState.playing) {
      board.printBoard();
      StringBuffer buffer = StringBuffer();
      buffer.write("${currentPlayer.symbol}'s turn. ");
      buffer.write("Enter row and column (e.g. 1 2): ");

      bool validInput = false;
      int? x, y;

      while (!validInput) {
        stdout.write(buffer.toString());
        String? input = stdin.readLineSync();
        if (input == null) {
          print("Invalid input. Please try again.");
          continue;
        }
        if (saveCheck(input)) {
          continue;
        }
        if (input == "q") {
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

  Map<String, dynamic> toJson() {
    return {
      'board': board.toJson(),
      'currentPlayer': currentPlayer.toJson(),
      'gameState': state.name,
    };
  }
}

