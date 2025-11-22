import 'dart:io';

import 'package:common/board.dart';
import 'package:common/message.dart';

import '../client.dart';
import 'client_state.dart';

// Класс для обработки сообщений от сервера
class ServerMessageHandlers {
  // Клиент, с которым связан обработчик
  final TicTacToeClient client;

  ServerMessageHandlers(this.client);

  // Обрабатываем ответ сервера, содержащий никнейм игрока
  void handleNickNameResponse(NickNamePlayerSM message) {
    print('\nWelcome, ${message.nickName}!');
    client.playerName = message.nickName;
    client.setState(ClientState.mainMenu);
  }

  // Обрабатываем сообщение о списке комнат
  void handleRoomListResponse(RoomsInfoSM message) {
    print('\nAvailable rooms:');
    // Если список комнат пуст
    if (message.rooms.isEmpty) {
      print('No rooms available.');
    } else {
      // Иначе выводим список комнат с информацией о режиме и сложности
      for (var room in message.rooms) {
        var difficultyStr = room.difficulty ?? '';
        if (difficultyStr.isNotEmpty) {
          print(
            '- ${room.name} (Board Size: ${room.boardSize}'
            'x${room.boardSize}, '
            'Full: ${room.isFull}, Mode: ${room.gameMode}, '
            'Difficulty: $difficultyStr)',
          );
        } else {
          print(
            '- ${room.name} (Board Size: ${room.boardSize}'
            'x${room.boardSize}, '
            'Full: ${room.isFull}, Mode: ${room.gameMode})',
          );
        }
      }
    }
    client.setState(ClientState.mainMenu);
  }

  // Обрабатываем ответ на запрос на присоединение к комнате
  void handleRoomJoinResponse(JoinToRoomSM message) {
    client.mySymbol = message.cellType;
    client.roomName = message.roomName;
    if (message.board.size > 0) {
      // Проверяем размер поля
      client.board = message.board;
      print(
        '\nSuccessfully joined room \'${message.roomName}\' '
        'as ${message.cellType.symbol}.',
      );
      client.board!.printBoard();
    } else {
      print(
        '\nSuccessfully joined room \'${message.roomName}\''
        ' as ${message.cellType.symbol}. '
        'Waiting for game to start...',
      );
    }
    // переходим в состояние ожидания присоединения оппонента к комнате
    client.setState(ClientState.waitingOpponentInRoom);
  }

  // Обрабатываем ответ на запрос на получение списка завершенных игр
  void handleFinishedGamesResponse(WinnersListSM message) {
    print('\nFinished games:');
    // Если список завершенных игр пуст
    if (message.winners.isEmpty) {
      print('No finished games.');
    } else {
      // Иначе выводим список завершенных игр
      for (var i = 0; i < message.winners.length; i++) {
        print('${i + 1} - ${message.winners[i]}');
      }
    }
    client.setState(ClientState.mainMenu);
  }

  // Обрабатываем ответ на запрос на получение данных
  // о конкретной завершенной игре
  void handleFinishedGameResponse(WinnerInfoSM message) {
    // Выводим информацию о завершенной игре
    print('\nFinished game:');
    print(
      'Winner: ${message.matchHistory.winner}, '
      'Player1: ${message.matchHistory.player1}, '
      'Player2: ${message.matchHistory.player2}',
    );
    client.board = message.matchHistory.board;
    client.board!.printBoard();
    print('');
    client.setState(ClientState.mainMenu);
  }

  // Обрабатываем ответ на запрос на инициализацию игры
  void handleInitGame(InitiateGameSM message) {
    client.board = message.board;
    client.currentPlayer = message.currentPlayer;
    print('\n--- Game Started ---');
    client.board!.printBoard();
    _printTurnInfo();
    if (message.currentPlayer == client.mySymbol) {
      // Устанавливаем состояние, что ходит игрок
      client.setState(ClientState.playerMove);
    } else {
      // Устанавливаем состояние, что ходит оппонент
      client.setState(ClientState.opponentMove);
    }
  }

  // Обрабатываем сообщение об обновлении состояния игры
  void handleUpdateState(UpdateStateSM message) {
    client.board = message.board;
    client.currentPlayer = message.currentPlayer;
    print('\n--- Game State Update ---');
    client.board!.printBoard();
    _printTurnInfo();
    if (message.currentPlayer == client.mySymbol) {
      // Устанавливаем состояние, что ходит игрок
      client.setState(ClientState.playerMove);
    } else {
      // Устанавливаем состояние, что ходит оппонент
      client.setState(ClientState.opponentMove);
    }
  }

  // Обрабатываем сообщение об окончании игры
  void handleEndGame(EndGameSM message) {
    client.board = message.board;
    print('\n--- Game Over ---');
    client.board!.printBoard();
    // Выводим информацию о победителе
    if (message.winner == Cell.empty) {
      print('It\'s a Draw!');
    } else {
      print('Player ${message.winner.symbol} wins!');
    }
    client.setState(ClientState.endGame);
    stdout.write('> ');
  }

  // Обрабатываем сообщение об ошибке
  void handleError(ErrorSM message) {
    print('\nServer Error: ${message.message}');
    // Если ошибка произошла во время игры (ожидание ответа от сервера после хода),
    // остаемся в состоянии playerMove, чтобы игрок мог попробовать сделать ход еще раз
    if (client.getState() == ClientState.waitResponseFromServer &&
        client.board != null) {
      // Проверяем, чей сейчас ход - если наш, переходим в playerMove
      if (client.currentPlayer == client.mySymbol) {
        client.setState(ClientState.playerMove);
      } else {
        // Если не наш ход, переходим в opponentMove
        client.setState(ClientState.opponentMove);
      }
    } else {
      // В остальных случаях возвращаемся в главное меню
      client.setState(ClientState.mainMenu);
    }
  }

  // Обрабатываем сообщение об отключении оппонента
  void handleOpponentLeft(OpponentLeftSM message) {
    print('\nPlayer \'${message.nickName}\' has left the game.');
    // Переходим в состояние ожидания присоединения оппонента к комнате
    client.setState(ClientState.waitingOpponentInRoom);
  }

  // Выводит информацию о ходе игрока
  void _printTurnInfo() {
    if (client.board == null) {
      return;
    }
    if (client.currentPlayer == client.mySymbol) {
      // Если ход игрока
      print('It\'s your turn.');
    } else if (client.currentPlayer != null &&
        client.currentPlayer != Cell.empty) {
      // Если ход оппонента
      print('It\'s player ${client.currentPlayer!.symbol}\'s turn.');
    }
    stdout.write('> ');
  }
}
