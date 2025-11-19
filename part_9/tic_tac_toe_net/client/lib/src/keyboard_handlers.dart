import 'package:common/message.dart';

import 'client_state.dart';
import '../client.dart';
import 'utils.dart';

Future<void> keyboardHandler(
  String input,
  TicTacToeClient client,
) async {
  switch (client.state) { // обработчик состояния
    case ClientState.nickName: // ввод никнейма
      client.sendToServer(NickNameCM(input));
      client.state = ClientState.idle;
    case ClientState.mainMenu: // работа с главным меню
      _mainMenuHandler(input, client);
    case ClientState.joinToRoom: // работа с меню комнат
      _joinRoomMenuHandler(input, client);
    case ClientState.getWinsList: // работа с меню историей матчей
      _getWinsListHandler(input, client);
    case ClientState.waitStartGame || // основной игровой цикл
          ClientState.stepWaiting ||
          ClientState.playing:
      _gameMenuHandler(input, client);
    default:
      break;
  }
}

void _mainMenuHandler(String input, TicTacToeClient client) {
  switch (input) {
    case '1': // переход в меню работы с комнатой
      client.state = ClientState.joinToRoom;
      client.sendToServer(RoomsListCM());
    case '2': // переход в меню работы с файлами матчей
      client.state = ClientState.getWinsList;
      client.sendToServer(WinnerListCM());
    case '3': // выход из приложения
      client.close();
      return;
    default:
      print('Invalid input. Please try again.');
  }
}

void _joinRoomMenuHandler(
  String input,
  TicTacToeClient client,
) async {
  if (input == 'b') {
    client.state = ClientState.mainMenu;
    printMainMenu();
    return;
  }
  var index = int.tryParse(input);
  var rooms = client.rooms;
  if (index == null || index - 1 < 0 || index - 1 >= rooms.length) {
    print('Invalid input. Please try again.');
    client.state = ClientState.mainMenu;
    printMainMenu();
    return;
  }
  client.sendToServer(JoinToRoomCM(
    rooms[index - 1],
    client.nickName,
  ));
}

void _getWinsListHandler(
  String input,
  TicTacToeClient client,
) {
  if (input == 'b') {
    client.state = ClientState.mainMenu;
    printMainMenu();
    return;
  }
  var index = int.tryParse(input);
  var winners = client.winnersList;
  if (index == null || index - 1 < 0 || index - 1 >= winners.length) {
    print('Invalid input. Please try again.');
    client.state = ClientState.mainMenu;
    printMainMenu();
    return;
  }
  client.sendToServer(WinnerInfoCM(
    winners[index - 1],
  ));
}

void _gameMenuHandler(
  String input,
  TicTacToeClient client,
) async {
  if (input == 'b') {
    _leaveFromRoom(client);
    return;
  }
  if (client.state == ClientState.playing) {
    int? x, y;
    var inputList = input.split(' ');
    if (inputList.length != 2) {
      print("Invalid input. Please try again.");
      return;
    }
    x = int.tryParse(inputList[1]);
    y = int.tryParse(inputList[0]);
    var board = client.board!;
    if (x == null ||
        y == null ||
        x < 1 ||
        x > board.size ||
        y < 1 ||
        y > board.size) {
      print("Invalid input. Please try again.");
      return;
    }
    x -= 1;
    y -= 1;
    if (board.setSymbol(x, y, client.cell!)) {
      client.sendToServer(
        CellValueCM(client.currentRoom, client.nickName, x, y),
      );
      client.state = ClientState.stepWaiting;
    } else {
      print('This cell is already occupied!');
    }
  }
}

void _leaveFromRoom(TicTacToeClient client) {
  client.sendToServer(
    LeaveFromRoomCM(
      client.currentRoom,
      client.nickName,
    ),
  );
  client.state = ClientState.mainMenu;
  printMainMenu();
}
