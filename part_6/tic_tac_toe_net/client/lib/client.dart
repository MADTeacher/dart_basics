import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:common/board.dart';
import 'package:common/server_config.dart' as serv;
import 'package:common/message.dart';

import 'src/client_state.dart';
import 'src/keyboard_handlers.dart';
import 'src/message_handlers.dart';

class TicTacToeClient {
  Socket? socket;
  ClientState state = ClientState.nickName; // стартовое состояние приложения
  List<String> rooms = []; // список комнат на сервере
  List<String> winnersList = []; // список файлов на сервере с матчами, завершившихся победой
  String nickName = '';
  String currentRoom = '';
  Board? board;
  Cell? cell; // символ игрока
  StreamSubscription? subscription; // подписка на ввод данных с клавиатуры

  final String serverIP;
  final int serverPort;

  TicTacToeClient([
    this.serverIP = serv.serverIP,
    this.serverPort = serv.serverPort,
  ]);

  Future<void> run() async {
    socket = await Socket.connect(serverIP, serverPort);
    socket
        ?.cast<List<int>>()
        .transform(
          utf8.decoder,
        )
        .listen(
          _messageHandler,
          onDone: () {
            print('Connection closed');
            close();
          },
        );

    stdout.write('Enter your nickname: ');
    state = ClientState.nickName;

    subscription = stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(_keyboardHandler);
  }

  Future<void> _messageHandler(String rawData) async {
    var json = jsonDecode(rawData);
    var message = ServerMessage.fromJson(json);
    messageHandler(message, this);
  }

  Future<void> _keyboardHandler(String input) async {
    keyboardHandler(input, this);
  }

  void sendToServer(ClientMessage message) {
    socket?.write(jsonEncode(message));
  }

  void keyboardSubCancel() {
    subscription?.cancel();
  }

  void close() {
    state = ClientState.idle;
    subscription?.cancel();
    socket?.destroy();
  }
}
