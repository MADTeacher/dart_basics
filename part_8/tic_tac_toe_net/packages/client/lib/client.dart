import 'dart:async';
import 'dart:io';

import 'package:common/board.dart';
import 'package:common/server_config.dart' as serv;
import 'package:common/message.dart';

import 'src/client_state.dart';
import 'src/socket_handler.dart';
import 'src/input_handler.dart';
import 'src/ui_handlers.dart';

// Класс для работы с клиентом
class TicTacToeClient {
  // Обработчик работы с сокетом
  SocketHandler? _socketHandler;
  // Обработчик ввода
  InputHandler? _inputHandler;
  // Обработчик событий пользовательского интерфейса
  UIHandlers? _uiHandlers;

  Board? board; // игровое поле
  Cell? mySymbol; // фигура игрока
  Cell? currentPlayer; // фигура игрока, чей сейчас ход
  String playerName = ''; // имя игрока
  String roomName = ''; // имя комнаты
  ClientState state =
      ClientState.waitNickNameConfirm; // текущее состояние клиента
  DateTime? lastMsgTime; // время последнего сообщения

  final String serverIP;
  final int serverPort;

  TicTacToeClient([
    this.serverIP = serv.serverIP,
    this.serverPort = serv.serverPort,
  ]);

  // Запускаем клиент, инициализируя все обработчики
  Future<void> run() async {
    _socketHandler = SocketHandler(this);
    _inputHandler = InputHandler(this);
    _uiHandlers = UIHandlers(this, _inputHandler!);

    await _socketHandler!.connect(serverIP, serverPort);

    // Настраиваем единый обработчик ввода
    _inputHandler!.setup();

    // Запускаем управление пользовательским потоком
    await handleUserFlow();
  }

  // Получаем текущее состояние клиента
  ClientState getState() {
    return state;
  }

  // Устанавливаем новое состояние клиента
  void setState(ClientState newState) {
    // Если переходим в состояние opponentMove
    if (newState == ClientState.opponentMove &&
        state != ClientState.opponentMove) {
      print('\nWaiting for opponent\'s move...');
    } else if (newState == ClientState.waitingOpponentInRoom &&
        state != ClientState.waitingOpponentInRoom) {
      // Если переходим в состояние waitingOpponentInRoom
      print('\nWaiting for opponent to join...');
    }

    state = newState;
  }

  // Отправляем сообщение на сервер
  void sendToServer(ClientMessage message) {
    _socketHandler?.sendToServer(message);
  }

  // Метод управления всем пользовательским потоком:
  // запрашиваем никнейм у пользователя,
  // отправляем его на сервер,
  // и в цикле обрабатываем состояния клиента
  Future<void> handleUserFlow() async {
    // Запрашиваем никнейм у пользователя
    stdout.write('Enter your nickname: ');
    var input = await _inputHandler!.readLine();
    if (input == null) {
      close();
      return;
    }
    input = input.trim();
    playerName = input;

    // Формируем сообщение и отправляем никнейм на сервер
    sendToServer(NickNameCM(playerName));

    // Основной цикл обработки состояний
    while (true) {
      switch (getState()) {
        case ClientState.waitNickNameConfirm:
          // Ожидаем подтверждения никнейма от сервера
          await Future.delayed(const Duration(milliseconds: 100));
          continue;
        case ClientState.mainMenu:
          // Переходим в главное меню
          await _uiHandlers!.mainMenu();
        case ClientState.playerMove:
          // Отрабатываем ход игрока
          await _uiHandlers!.playing();
        case ClientState.opponentMove:
          // Ожидаем данные по ходу противника
          await Future.delayed(const Duration(milliseconds: 1000));
          continue;
        case ClientState.endGame:
          // Игра завершена. Ждем ее перезапуск от сервера
          print('\nGame has ended. Restarting in 10 seconds...');
          await Future.delayed(const Duration(seconds: 10));
          continue;
        case ClientState.waitResponseFromServer:
          // Ожидание ответа от сервера
          await Future.delayed(const Duration(milliseconds: 100));
          continue;
        case ClientState.waitingOpponentInRoom:
          // Ожидание противника в комнате
          await _uiHandlers!.waitingOpponentInRoom();
          // Проверяем, не изменилось ли состояние (например, после обработки сообщения)
          if (getState() != ClientState.waitingOpponentInRoom) {
            continue;
          }
      }
    }
  }

  // Проверяем валидность хода игрока
  bool validateMove(int row, int col) {
    if (board == null) {
      print('Game has not started yet.');
      return false;
    }
    // Если ход вне поля
    if (row < 1 || row > board!.size || col < 1 || col > board!.size) {
      print(
        'Invalid move. Row and column must be between 1 and ${board!.size}.',
      );
      return false;
    }
    // Нормируем индекс для доступа к полю
    if (board!.cells[row - 1][col - 1] != Cell.empty) {
      print('Invalid move. Cell is already occupied.');
      return false;
    }
    return true;
  }

  // Метод для выхода из комнаты
  void leaveFromRoom() {
    sendToServer(LeaveFromRoomCM(roomName, playerName));
    setState(ClientState.mainMenu);
  }

  // Закрываем клиент и все его обработчики
  void close() {
    _inputHandler?.close();
    _socketHandler?.close();
  }
}
