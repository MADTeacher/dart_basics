import 'dart:async';
import 'dart:math';

import 'package:common/board.dart';
import 'package:common/finish_game_shapshot.dart';
import 'package:common/message.dart';

import 'database/i_database_provider.dart';
import 'player/i_player.dart';
import 'player/computer_player.dart';
import 'game_state.dart';

const symbols = [Cell.cross, Cell.nought];

// Класс комнаты для игры в крестики-нолики
class Room {
  final String name; // Название комнаты
  Board board; // Доска для игры
  IPlayer? player1; // Первый игрок
  IPlayer? player2; // Второй игрок
  IPlayer? currentPlayer; // Активный игрок
  GameState state = GameState.waitingOpponent; // Состояние игры
  final IDatabaseProvider
  database; // База данных для хранения игровой статистики
  final GameMode mode; // Режим игры
  final ComputerDifficulty? difficulty; // Уровень сложности компьютера

  // Проверяем, заполнена ли комната
  bool get isFull => player1 != null && player2 != null;

  Room(this.name, this.database, int boardSize, this.mode, this.difficulty)
    : board = Board(boardSize) {
    // Если режим игры — PvC, то создаем компьютерного игрока
    if (mode == GameMode.playerVsComputer) {
      player2 = ComputerPlayer(
        Cell.nought,
        difficulty ?? ComputerDifficulty.easy,
      );
    }
  }

  // Возвращаем количество игроков в комнате
  int playersAmount() {
    if (player1 != null && player2 != null) {
      return 2; // Если оба игрока есть, возвращаем 2
    } else if (player1 != null || player2 != null) {
      return 1; // Если только один игрок, возвращаем 1
    }
    return 0; // Если ни один игрок не добавлен, возвращаем 0
  }

  // Возвращаем размер доски
  int boardSize() => board.size;

  // Добавляем игрока в комнату
  void addPlayer(IPlayer player) {
    if (player1 == null) {
      player1 = player; // Первый игрок
      // Устанавливаем фигуру по умолчанию
      // Если фигура уже установлена и не равна X, переключаем
      player1!.figure = Cell.cross;
    } else if (player2 == null && mode == GameMode.playerVsPlayer) {
      // Второй игрок добавляется только в режиме PvP
      // В режиме PvC второй игрок уже создан как ComputerPlayer
      player2 = player;
      // Устанавливаем фигуру по умолчанию
      // Если фигура уже установлена и не равна O, переключаем
      player2!.figure = Cell.nought;
    }
  }

  // Удаляем игрока из комнаты
  void playerLeave(IPlayer player) {
    if (player1 == player) {
      player1 = null; // Удаляем первого игрока
      // Если в комнате есть второй игрок и он человек,
      // уведомляем его о выходе соперника
      if (player2 != null && !player2!.isComputer) {
        player2?.sendMessage(OpponentLeftSM(player.nickName));
      }
    } else if (player2 == player) {
      player2 = null; // Удаляем второго игрока
      // Если в комнате есть первый игрок,
      // уведомляем его о выходе соперника
      if (player1 != null) {
        player1?.sendMessage(OpponentLeftSM(player.nickName));
      }
    }
  }

  // Переключаем активного игрока
  void _switchCurrentPlayer() {
    if (currentPlayer == player1) {
      currentPlayer = player2; // Если сейчас ходил первый, теперь ход второго
    } else {
      currentPlayer = player1; // И наоборот
    }
  }

  // Медод для инициализации игры и ее начала
  Future<void> initiateGame() async {
    if (!isFull) {
      return; // Если игроков меньше двух, игра не начинается
    }

    // Список для определения игрока, ходящего первым
    if (!board.isEmpty()) {
      // Если доска не пуста, создаем новую
      board = Board(board.size);
    }

    // Выбираем случайным образом, кто ходит первым (X или O)
    final starterSymbol = symbols[Random().nextInt(symbols.length)];
    switch (starterSymbol) {
      case Cell.cross:
        state = GameState.crossStep;
      case Cell.nought:
        state = GameState.noughtStep;
      default:
        break;
    }

    // Устанавливаем активного игрока в зависимости
    // от режима игры и символа
    if (mode == GameMode.playerVsComputer) {
      // В режиме PvC человек всегда Player1
      if (state == GameState.crossStep) {
        currentPlayer = player1;
      } else if (state == GameState.noughtStep) {
        currentPlayer = player2;
      }
    } else {
      // В режиме PvP ищем, кто играет выбранным символом
      if ((state == GameState.crossStep && player1?.figure == Cell.cross) ||
          (state == GameState.noughtStep && player1?.figure == Cell.nought)) {
        currentPlayer = player1;
      } else {
        currentPlayer = player2;
      }
    }

    // Отправляем сообщение о начале игры
    final message = InitiateGameSM(board, starterSymbol);
    player1?.sendMessage(message);
    player2?.sendMessage(message);

    // Если сейчас ход компьютера, он делает ход автоматически
    if (currentPlayer?.isComputer == true) {
      final result = await currentPlayer!.makeMove(board);
      await playerStep(currentPlayer!, result.x, result.y);
    }
  }

  // Метод для выполнения хода игрока
  Future<void> playerStep(IPlayer player, int x, int y) async {
    // Проверяем, что сейчас идет ход (игра не завершена)
    if (state != GameState.crossStep && state != GameState.noughtStep) {
      player.sendMessage(ErrorSM('Game is not in progress.'));
      return;
    }
    // Проверяем, что ход делает именно тот игрок, чей сейчас ход
    if (player != currentPlayer) {
      player.sendMessage(ErrorSM('It is not your turn.'));
      return;
    }

    // Проверяем границы доски
    if (x < 0 || x >= board.size || y < 0 || y >= board.size) {
      player.sendMessage(
        ErrorSM(
          'Invalid move. Row and column must be between 1 and ${board.size}.',
        ),
      );
      return;
    }

    // Ставим символ игрока на выбранную клетку
    final moveSuccess = board.setSymbol(x, y, currentPlayer!.figure);
    if (!moveSuccess) {
      // Если ход невалидный (клетка уже занята), отправляем ошибку только этому игроку
      player.sendMessage(ErrorSM('Invalid move. Cell is already occupied.'));
      return;
    }

    ServerMessage message;
    // Проверяем, выиграл ли этот игрок
    if (board.checkWin(currentPlayer!.figure)) {
      if (currentPlayer!.figure == Cell.cross) {
        state = GameState.crossWin; // Победа крестиков
      } else {
        state = GameState.noughtWin; // Победа ноликов
      }
      // Формируем сообщение о завершении игры
      message = EndGameSM(board, currentPlayer!.figure);

      // Сохраняем информацию о завершенной игре в базе данных
      final figureWinner = currentPlayer!.figure;
      final winnerNickName = currentPlayer!.nickName;
      var info = figureWinner == Cell.cross ? 'X' : 'O';
      final winnerName = '$winnerNickName ( $info )';

      String anotherPlayerNickName;
      if (currentPlayer == player1) {
        anotherPlayerNickName = player2!.nickName;
      } else {
        anotherPlayerNickName = player1!.nickName;
      }

      await database.saveFinishedGame(
        FinishGameSnapshot(
          board: board,
          playerFigure: figureWinner,
          winnerName: winnerName,
          playerNickName: anotherPlayerNickName,
          time: DateTime.now(),
        ),
      );
    } else if (board.checkDraw()) {
      // Если доска заполнена, но победителя нет — ничья
      state = GameState.draw;
      message = EndGameSM(board, Cell.empty);
    } else {
      // Если игра не закончена, меняем активного игрока и продолжаем
      if (currentPlayer!.figure == Cell.cross) {
        state = GameState.noughtStep;
      } else {
        state = GameState.crossStep;
      }
      _switchCurrentPlayer();
      // Сообщаем о новом состоянии игры
      message = UpdateStateSM(board, currentPlayer!.figure);
    }

    // Отправляем сообщение обоим игрокам
    player1?.sendMessage(message);
    player2?.sendMessage(message);

    // Если игра завершена (победа или ничья),
    // ждем 10 секунд и запускаем новую
    if (state == GameState.crossWin ||
        state == GameState.noughtWin ||
        state == GameState.draw) {
      await Future.delayed(const Duration(seconds: 10));
      await initiateGame();
      return;
    }

    // Если теперь ход компьютера, он автоматически делает его
    if (currentPlayer?.isComputer == true) {
      final result = await currentPlayer!.makeMove(board);
      await playerStep(currentPlayer!, result.x, result.y);
    }
  }
}
