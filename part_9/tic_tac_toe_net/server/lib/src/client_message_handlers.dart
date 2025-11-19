import 'dart:convert';
import 'dart:io';

import 'package:common/message.dart';

import 'match_loader.dart';
import 'player.dart';
import 'room.dart';

int _defaultPlayerCount = 0;

void clientMessageHandler(
  ClientMessage message,
  Socket client,
  Map<String, Room> rooms, // Map<ИмяКомнаты, экземпляр Room>
  Map<String, Player> players, // Map<Ник, экземпляр Player>
  MatchLoader loader,
) async {
  switch (message) {
    case NickNameCM(nickName: var nickName):
      // Авторизация игрока
      _clientNickNameHandler(nickName, client, players);
    case RoomsListCM():
      // Отправляем список комнат
      client.write(jsonEncode(
        RoomsInfoSM(rooms.keys.toList()),
      ));
    case JoinToRoomCM():
      // Подключаем игрока к комнате
      _joinToRoomHandler(message, client, rooms, players);
    case LeaveFromRoomCM(
        roomName: var roomName,
        nickName: var nickName,
      ):
      // Отключаем игрока от комнаты
      rooms[roomName]!.playerLeave(players[nickName]!);
    case CellValueCM():
      // Игрок делает ход
      rooms[message.room]!.playerStep(
        players[message.nickName]!,
        message.horizontal,
        message.vertical,
      );
    case WinnerListCM():
      // Список файлов матчей, завершившихся победой
      var winnersList = await loader.listMatches();
      client.write(
        jsonEncode(WinnersListSM(winnersList)),
      );
    case WinnerInfoCM(winner: var fileName):
      // Информация о конкретном матче
      var winner = await loader.loadMatch(fileName);
      if (winner != null) {
        client.write(
          jsonEncode(WinnerInfoSM(winner)),
        );
      }
  }
}

void _clientNickNameHandler(
  String nickName,
  Socket client,
  Map<String, Player> players,
) {
  if (players.containsKey(nickName)) {
    nickName = 'Player$_defaultPlayerCount';
    _defaultPlayerCount++;
  }
  players[nickName] = Player(
    nickName,
    socket: client,
  );
  print('New player: $nickName');
  client.write(jsonEncode(NickNamePlayerSM(nickName)));
}


void _joinToRoomHandler(
  JoinToRoomCM message,
  Socket client, // сокет клиента, отправляющего запрос.
  Map<String, Room> rooms,
  Map<String, Player> players,
) async {
  var JoinToRoomCM(:nickName, :roomName) = message;
  // Проверяем, не заполнена ли уже комната
  if (rooms[roomName]!.isFull) {
    // Комната заполнена, отправляем клиенту сообщение об ошибке
    client.write(jsonEncode(ErrorSM(
      'Room $roomName is full',
    )));
  } else {
    // Добавляем игрока в комнату
    rooms[roomName]!.addPlayer(
      players[nickName]!,
    );
    // Отправляем клиенту информацию о успешном присоединении
    client.write(jsonEncode(JoinToRoomSM(
      roomName,
      players[nickName]!.cellType, // Тип символа игрока
      rooms[roomName]!.board,
    )));
    // Инициируем начало игры
    rooms[roomName]!.initiateGame();
  }
}
