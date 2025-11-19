import 'package:common/message.dart';

import '../client.dart';
import 'client_state.dart';
import 'utils.dart';

void messageHandler(
  ServerMessage message,
  TicTacToeClient client,
) async {
  var state = client.state;
  if (message is NickNamePlayerSM && client.state == ClientState.idle) {
    client.nickName = message.nickName;
    print('Your nickname: ${client.nickName}');
    client.state = ClientState.mainMenu;
    printMainMenu();
  } else if (state == ClientState.joinToRoom) {
    await _joinToRoomHandler(message, client);
  } else if (state == ClientState.waitStartGame ||
      state == ClientState.stepWaiting ||
      state == ClientState.playing) {
    await _gameHandler(message, client);
  } else if (state == ClientState.getWinsList) {
    await _getWinsListHandler(message, client);
  }
}

Future<void> _gameHandler(
  ServerMessage message,
  TicTacToeClient client,
) async {
  switch (message) {
    case ChangedRoomBoardSM():
      print('*' * 20);
      client.board = message.board;
      if (client.cell == message.currentPlayer) {
        print('Your turn');
        print("Enter row and column (e.g. 1 2): ");
        client.state = ClientState.playing;
      } else {
        print('Opponent turn');
        client.state = ClientState.stepWaiting;
      }
      client.board?.printBoard();
    case LeaveFromRoomSM():
      print('*' * 20);
      print('Opponent "${message.nickName}" leave room');
      client.state = ClientState.waitStartGame;
    case EndGameSM():
      print('*' * 20);
      if (message.winner == client.cell) {
        print('***You win!***');
      } else {
        print('***You lose!***');
      }
      client.board = message.board;
      client.board?.printBoard();
      client.state = ClientState.waitStartGame;
      print('***Start new game***');
    default:
      client.state = ClientState.mainMenu;
      printMainMenu();
  }
}

Future<void> _joinToRoomHandler(
  ServerMessage message,
  TicTacToeClient client,
) async {
  switch (message) {
    case JoinToRoomSM():
      var symbol = cellSymbol(message.cellType);
      print('*' * 20);
      print('Joined to room ${message.roomName}');
      print('Your symbol: $symbol');
      print('For leave room enter "b"');
      client.board = message.board;
      client.cell = message.cellType;
      client.currentRoom = message.roomName;
      client.board?.printBoard();
      client.state = ClientState.waitStartGame;
      print('Waiting start game...');
    case RoomsInfoSM():
      client.rooms = message.rooms;
      var i = 0;
      for (var it in client.rooms) {
        print('${++i} - $it');
      }
      print('Enter room index (b - back): ');
    case ErrorSM(message: var text):
      print(text);
      client.state = ClientState.mainMenu;
      printMainMenu();
    default:
      client.state = ClientState.mainMenu;
      printMainMenu();
  }
}

Future<void> _getWinsListHandler(
  ServerMessage message,
  TicTacToeClient client,
) async {
  switch (message) {
    case WinnersListSM(winners: var winners):
      client.winnersList = winners;
      var i = 0;
      for (var it in client.winnersList) {
        print('${++i} - $it');
      }
      print('Enter index (b - back): ');
    case WinnerInfoSM(matchHistory: var history):
      print('${'*' * 10}Match history${'*' * 10}');
      print('Winner: ${history.winner}');
      print('Player1: ${history.player1}');
      print('Player2: ${history.player2}');
      history.board.printBoard();
      client.state = ClientState.mainMenu;
      printMainMenu();
    case ErrorSM(message: var text):
      print(text);
      client.state = ClientState.mainMenu;
      printMainMenu();
    default:
      client.state = ClientState.mainMenu;
      printMainMenu();
  }
}
