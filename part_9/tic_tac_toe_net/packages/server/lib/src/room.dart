import 'dart:math';

import 'package:common/board.dart';
import 'package:common/match_history.dart';
import 'package:common/message.dart';

import 'match_saver.dart';
import 'player.dart';
import 'game_state.dart';

const symbols = [Cell.cross, Cell.nought];

class Room {
  Board board;
  Player? player1;
  Player? player2;
  GameState state = GameState.waitingOpponent;
  final MatchSaver saver;

  bool get isFull => player1 != null && player2 != null;

  Room(int boardSize, this.saver) : board = Board(boardSize);

  void addPlayer(Player player) {
    if (player1 == null) {
      player1 = player;
      player1?.cellType = Cell.cross;
    } else if (player2 == null) {
      player2 = player;
      player2?.cellType = Cell.nought;
    }
  }

  void playerLeave(Player player) {
    if (player1 == player) {
      player1 = null;
      player2?.sendMessage(
        // оповещаем второго игрока о выходе первого
        LeaveFromRoomSM(player.nickName),
      );
    } else if (player2 == player) {
      player2 = null;
      player1?.sendMessage(
        LeaveFromRoomSM(player.nickName),
      );
    }
  }

  void initiateGame() {
    if (!isFull) {
      return;
    }
    var randomPlayer = symbols[Random().nextInt(symbols.length)];
    if (!board.isEmpty()) {
      // если игровое поле не пустое
      board = Board(board.size); // очищаем поле
    }
    ServerMessage? message;
    switch (randomPlayer) {
      case Cell.cross:
        state = GameState.crossStep;
        message = ChangedRoomBoardSM(board, Cell.cross);
      case Cell.nought:
        state = GameState.noughtStep;
        message = ChangedRoomBoardSM(board, Cell.nought);
      default:
        break;
    }
    player1?.sendMessage(message!);
    player2?.sendMessage(message!);
  }

  void playerStep(Player player, int x, int y) {
    if (state != GameState.crossStep && state != GameState.noughtStep) {
      return;
    }

    bool isPlayerTurn =
        (state == GameState.crossStep && player.cellType == Cell.cross) ||
            (state == GameState.noughtStep && player.cellType == Cell.nought);
    if (!isPlayerTurn) {
      return;
    }

    Cell currentPlayerCell = player.cellType;
    board.setSymbol(x, y, currentPlayerCell);

    ServerMessage? message;
    if (board.checkWin(currentPlayerCell)) {
      state = currentPlayerCell == Cell.cross
          ? GameState.crossWin
          : GameState.noughtWin;
      message = EndGameSM(board, currentPlayerCell);
      var info = currentPlayerCell == Cell.cross ? 'X' : 'O';
      saver.saveMatch(MatchHistory(
        winner:
            '${player.nickName} ( $info )',
        player1: player1!.nickName,
        player2: player2!.nickName,
        board: board,
      ));
    } else if (board.checkDraw()) {
      state = GameState.draw;
      message = EndGameSM(board, Cell.empty);
    } else {
      state = currentPlayerCell == Cell.cross
          ? GameState.noughtStep
          : GameState.crossStep;
      message = ChangedRoomBoardSM(
        board,
        state == GameState.noughtStep ? Cell.nought : Cell.cross,
      );
    }

    player1?.sendMessage(message);
    player2?.sendMessage(message);

    if (state == GameState.crossWin ||
        state == GameState.noughtWin ||
        state == GameState.draw) {
      initiateGame();
    }
  }
}
