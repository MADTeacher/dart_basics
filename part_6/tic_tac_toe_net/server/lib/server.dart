import 'dart:io';
import 'dart:convert';

import 'package:common/message.dart';
import 'package:common/server_config.dart' as serv;

import 'src/match_loader.dart';
import 'src/match_saver.dart';
import 'src/player.dart';
import 'src/room.dart';
import 'src/client_message_handlers.dart';

class TicTacToeServer {
  MatchSaver saver = MatchSaver();
  MatchLoader loader = MatchLoader();
  Map<String, Room> rooms = {};
  Map<String, Player> players = {};
  final String serverIP;
  final int serverPort;

  TicTacToeServer([
    this.serverIP = serv.serverIP,
    this.serverPort = serv.serverPort,
  ]) {
    rooms = {
      "Test1 Room": Room(4, saver),
      "Test2 Room": Room(3, saver),
    };
  }

  void start() async {
    // Стартуем сервер на заданном порту
    var server = await ServerSocket.bind(serverIP, serverPort);
    print(
      'Сервер запущен на: ${server.address.address}:${server.port}',
    );

    // Ожидаем подключения клиентов
    await for (var client in server) {
      handleClient(client); // Обрабатываем подключение клиента
    }
  }

  void handleClient(Socket client) {
    client.cast<List<int>>().transform(utf8.decoder).listen(
      (String rawData) async {
        var message = ClientMessage.fromJson(
          jsonDecode(rawData),
        );
        clientMessageHandler(
          // Обрабатываем полученное сообщение
          message,
          client,
          rooms,
          players,
          loader,
        );
      },
      onDone: () {
        playerDisconnect(client);
      },
    );
  }

  void playerDisconnect(Socket client) {
    // Отключаем игрока
    Player? disconnectedPlayer;
    for (var player in players.values) {
      if (player.chekSocket(client)) {
        disconnectedPlayer = player;
        break;
      }
    }
    if (disconnectedPlayer is Player) {
      for (var room in rooms.values) {
        room.playerLeave(disconnectedPlayer);
      }
    }
    players.remove(disconnectedPlayer?.nickName);
    print('Disconnected: ${disconnectedPlayer?.nickName}');
  }
}
