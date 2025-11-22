import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

import 'package:common/message.dart';
import 'package:common/server_config.dart' as serv;

import 'src/database/database.dart';
import 'src/database/i_database_provider.dart';
import 'src/player/player.dart';
import 'src/player/i_player.dart';
import 'src/player/computer_player.dart';
import 'src/room.dart';
import 'src/game_state.dart';
import 'src/client_message_handlers.dart';

// Класс сервера для игры в крестики-нолики
class TicTacToeServer {
  // База данных для хранения игровой статистики
  late IDatabaseProvider database;
  // Карта комнат для хранения игровых комнат
  Map<String, Room> rooms = {};
  // Карта игроков для хранения игроков, подключенных к серверу
  Map<String, IPlayer> players = {};
  final String serverIP; // IP-адрес сервера
  final int serverPort; // Порт сервера

  TicTacToeServer([
    this.serverIP = serv.serverIP,
    this.serverPort = serv.serverPort,
  ]);

  // Инициализируем сервер, создаем базу данных и комнаты
  Future<void> initialize() async {
    final dbPath = p.join(Directory.current.path, 'tic_tac_toe.db');
    database = await SqliteDatabase.create(dbPath);
    // Создаем комнаты и добавляем их в карту rooms по ключу,
    // который является именем комнаты
    rooms = {
      "room1": Room("room1", database, 3, GameMode.playerVsPlayer, null),
      "room2": Room(
        "room2",
        database,
        3,
        GameMode.playerVsComputer,
        ComputerDifficulty.easy,
      ),
      "room3": Room(
        "room3",
        database,
        5,
        GameMode.playerVsComputer,
        ComputerDifficulty.medium,
      ),
      "room4": Room(
        "room4",
        database,
        6,
        GameMode.playerVsComputer,
        ComputerDifficulty.hard,
      ),
    };
  }

  // Запускаем сервер
  void start() async {
    await initialize();
    // Стартуем сервер на заданном порту
    var server = await ServerSocket.bind(serverIP, serverPort);
    print('Сервер запущен на: ${server.address.address}:${server.port}');

    // Ожидаем подключения клиентов
    await for (var client in server) {
      handleClient(client); // Обрабатываем подключение клиента
    }
  }

  // Метод для обработки подключения клиента к серверу
  void handleClient(Socket client) {
    // Каждый клиент имеет свой буфер
    String clientBuffer = '';

    client
        .cast<List<int>>()
        .transform(utf8.decoder)
        .listen(
          (String chunk) async {
            clientBuffer += chunk;
            clientBuffer = await _processClientBuffer(client, clientBuffer);
          },
          onDone: () {
            playerDisconnect(client);
          },
        );
  }

  // Метод для обработки буфера клиента
  Future<String> _processClientBuffer(Socket client, String buffer) async {
    // Пытаемся распарсить JSON из буфера
    while (buffer.isNotEmpty) {
      // Пропускаем пробелы в начале
      buffer = buffer.trimLeft();
      if (buffer.isEmpty) break;

      // Ищем полный JSON объект
      int braceCount = 0;
      bool inString = false;
      bool escaped = false;
      int startIndex = 0;

      if (buffer[startIndex] != '{') {
        // Если не JSON объект, очищаем буфер
        return '';
      }

      // Ищем конец JSON объекта
      int endIndex = -1;
      for (int i = startIndex; i < buffer.length; i++) {
        final char = buffer[i];

        if (escaped) {
          escaped = false;
          continue;
        }

        if (char == '\\') {
          escaped = true;
          continue;
        }

        if (char == '"') {
          inString = !inString;
          continue;
        }

        if (!inString) {
          if (char == '{') {
            braceCount++;
          } else if (char == '}') {
            braceCount--;
            if (braceCount == 0) {
              endIndex = i;
              break;
            }
          }
        }
      }

      if (endIndex == -1) {
        // Полный объект еще не получен
        break;
      }

      // Парсим найденный JSON объект
      try {
        final jsonStr = buffer.substring(startIndex, endIndex + 1);
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        final message = ClientMessage.fromJson(json);
        await clientMessageHandler(message, client, rooms, players, database);

        // Удаляем обработанную часть из буфера
        buffer = buffer.substring(endIndex + 1);
      } catch (e) {
        print('Error parsing client message: $e');
        return '';
      }
    }

    return buffer;
  }

  // Метод для обработки отключения игрока от сервера
  void playerDisconnect(Socket client) {
    // Отключаем игрока
    IPlayer? disconnectedPlayer;
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
