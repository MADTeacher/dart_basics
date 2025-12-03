import 'dart:convert';
import 'dart:io';

import 'package:common/message.dart';
import 'package:common/match_history.dart';
import 'package:common/finish_game_shapshot.dart';

import 'database/i_database_provider.dart';
import 'player/player.dart';
import 'player/i_player.dart';
import 'room.dart';

int _defaultPlayerCount = 0;

// Функция для обработки сообщений от клиента
Future<void> clientMessageHandler(
  ClientMessage message,
  Socket client,
  Map<String, Room> rooms, // Map<ИмяКомнаты, экземпляр Room>
  Map<String, IPlayer> players, // Map<Ник, экземпляр Player>
  IDatabaseProvider database,
) async {
  switch (message) {
    case NickNameCM(nickName: var nickName):
      // Авторизация игрока
      _clientNickNameHandler(nickName, client, players);
    case RoomsListCM():
      // Отправляем список комнат с полной информацией
      var roomInfos = rooms.entries.map((entry) {
        var room = entry.value;
        return RoomInfo(
          name: room.name,
          boardSize: room.boardSize(),
          isFull: room.isFull,
          gameMode: room.mode.modeStr,
          difficulty: room.difficulty?.name,
        );
      }).toList();
      client.write(jsonEncode(RoomsInfoSM(roomInfos)));
    case JoinToRoomCM():
      // Подключаем игрока к комнате
      _joinToRoomHandler(message, client, rooms, players);
    case LeaveFromRoomCM(roomName: var roomName, nickName: var nickName):
      // Отключаем игрока от комнаты
      rooms[roomName]!.playerLeave(players[nickName]!);
    case MakeMoveCM():
      // Игрок делает ход
      await rooms[message.room]!.playerStep(
        players[message.nickName]!,
        message.horizontal,
        message.vertical,
      );
    case WinnerListCM():
      // Список идентификаторов матчей, завершившихся победой
      var allGames = await database.getAllFinishedGames();
      var winnersSet = <String>{};
      for (var game in allGames) {
        var matchId = '${game.winnerName}|${game.time.toIso8601String()}';
        winnersSet.add(matchId);
      }
      client.write(jsonEncode(WinnersListSM(winnersSet.toList())));
    case WinnerInfoCM(winner: var matchId):
      // Информация о конкретном матче
      try {
        // Пытаемся парсить matchId как число (ID игры)
        var gameId = int.tryParse(matchId);
        FinishGameSnapshot? game;

        if (gameId != null) {
          // Если это ID, получаем игру по ID
          game = await database.getFinishedGameById(gameId);
        } else {
          // Если это строка в формате "winnerName|timestamp"
          var parts = matchId.split('|');
          if (parts.length == 2) {
            var winnerName = parts[0];
            var time = parts[1];
            var allGames = await database.getAllFinishedGames();
            game = allGames.firstWhere(
              (g) =>
                  g.winnerName == winnerName &&
                  g.time.toIso8601String() == time,
            );
          }
        }

        if (game != null) {
          // Извлекаем имя игрока из winnerName (формат: "PlayerName ( X )")
          var winnerNameMatch = RegExp(
            r'^(.+?)\s*\(.*\)$',
          ).firstMatch(game.winnerName);
          var winnerPlayerName =
              winnerNameMatch?.group(1)?.trim() ?? game.winnerName;

          var match = MatchHistory(
            winner: game.winnerName,
            player1: winnerPlayerName,
            player2: game.playerNickName,
            board: game.board,
          );
          client.write(jsonEncode(WinnerInfoSM(match)));
        } else {
          // Игра не найдена
          client.write(jsonEncode(ErrorSM('Game not found')));
        }
      } catch (e) {
        // Ошибка при получении игры
        client.write(jsonEncode(ErrorSM('Error getting game: $e')));
      }
  }
}

// Функция для обработки сообщений о никнейме игрока
void _clientNickNameHandler(
  String nickName,
  Socket client,
  Map<String, IPlayer> players,
) {
  if (players.containsKey(nickName)) {
    nickName = 'Player$_defaultPlayerCount';
    _defaultPlayerCount++;
  }
  players[nickName] = Player(nickName, socket: client);
  print('New player: $nickName');
  client.write(jsonEncode(NickNamePlayerSM(nickName)));
}

// Функция для обработки сообщений о присоединении игрока к комнате
void _joinToRoomHandler(
  JoinToRoomCM message,
  Socket client, // сокет клиента, отправляющего запрос.
  Map<String, Room> rooms,
  Map<String, IPlayer> players,
) async {
  try {
    var JoinToRoomCM(:nickName, :roomName) = message;

    // Проверяем существование комнаты
    if (!rooms.containsKey(roomName)) {
      client.write(jsonEncode(ErrorSM('Room $roomName not found')));
      return;
    }

    // Проверяем существование игрока
    if (!players.containsKey(nickName)) {
      client.write(jsonEncode(ErrorSM('Player $nickName not found')));
      return;
    }

    final room = rooms[roomName]!;
    final player = players[nickName]!;

    // Проверяем, не заполнена ли уже комната
    if (room.isFull) {
      // Комната заполнена, отправляем клиенту сообщение об ошибке
      client.write(jsonEncode(ErrorSM('Room $roomName is full')));
      return;
    }

    // Добавляем игрока в комнату
    room.addPlayer(player);

    // Отправляем клиенту информацию о успешном присоединении
    client.write(
      jsonEncode(
        JoinToRoomSM(
          roomName,
          player.figure, // Тип символа игрока
          room.board,
        ),
      ),
    );

    // Инициируем начало игры
    await room.initiateGame();
  } catch (e) {
    // Обрабатываем любые ошибки и отправляем сообщение клиенту
    print('Error in _joinToRoomHandler: $e');
    client.write(jsonEncode(ErrorSM('Error joining room: $e')));
  }
}
