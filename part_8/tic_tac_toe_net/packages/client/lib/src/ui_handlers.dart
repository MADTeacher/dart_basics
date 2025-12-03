import 'dart:io';

import 'package:common/message.dart';

import '../client.dart';
import 'client_state.dart';
import 'input_handler.dart';

// Класс для обработки событий пользовательского интерфейса
class UIHandlers {
  // Клиент, с которым связан обработчик
  final TicTacToeClient client;
  // Обработчик ввода
  final InputHandler inputHandler;

  UIHandlers(this.client, this.inputHandler);

  // Выводим главное меню клиента для
  // взаимодействия с пользователем и обрабатываем ввод
  Future<void> mainMenu() async {
    // Выводим меню
    print('Enter command:');
    print('1 - Get room list');
    print('2 - Join room');
    print('3 - Get finished games');
    print('4 - Get finished game by id');
    print('5 - Exit');
    stdout.write('> ');

    var input = await inputHandler.readLine();
    if (input == null) {
      client.close();
      return;
    }
    input = input.trim();

    var command = int.tryParse(input);
    if (command == null) {
      print('Invalid command.');
      return;
    }

    // Обрабатываем ввод пользователя
    switch (command) {
      case 1: // Получаем список комнат
        client.sendToServer(RoomsListCM());
        client.setState(ClientState.waitResponseFromServer);
      case 2: // Присоединяемся к комнате
        stdout.write('Enter room name: ');
        var roomInput = await inputHandler.readLine();
        if (roomInput == null) {
          return;
        }
        roomInput = roomInput.trim();
        client.roomName = roomInput;
        client.sendToServer(JoinToRoomCM(client.roomName, client.playerName));
        client.setState(ClientState.waitResponseFromServer);
      case 3: // Получаем список завершенных игр
        client.sendToServer(WinnerListCM());
        client.setState(ClientState.waitResponseFromServer);
      case 4: // Получаем завершенную игру по id
        stdout.write('Enter game id: ');
        var gameIdInput = await inputHandler.readLine();
        if (gameIdInput == null) {
          return;
        }
        var gameId = int.tryParse(gameIdInput.trim());
        if (gameId == null) {
          print('Invalid game id.');
          return;
        }
        // В текущей версии нет сообщения для получения игры по ID
        // Используем WinnerInfoCM с ID как строкой
        client.sendToServer(WinnerInfoCM(gameId.toString()));
        client.setState(ClientState.waitResponseFromServer);
      case 5: // Выходим из программы
        client.close();
        exit(0);
      default:
        print('Unknown command.');
        return;
    }
  }

  // Обрабатываем ход игрока
  Future<void> playing() async {
    stdout.write(
      '\nEnter command: <row> <col> or q for '
      'exit to main menu\n> ',
    );
    var input = await inputHandler.readLine();
    if (input == null) {
      return;
    }
    input = input.trim();

    if (input == 'q') {
      // Если игрок хочет выйти в меню
      client.leaveFromRoom();
      return;
    }

    // Разделяем ввод игрока на строки
    var parts = input.split(' ');
    if (parts.length != 2) {
      print('Usage: <row> <col>');
      return;
    }

    var row = int.tryParse(parts[0]);
    var col = int.tryParse(parts[1]);
    if (row == null || col == null) {
      print('Row and column must be numbers.');
      return;
    }

    // Валидируем ввод игрока
    if (!client.validateMove(row, col)) {
      return; // validateMove prints the error
    }

    // Создаем сообщение о ходе игрока
    client.sendToServer(
      MakeMoveCM(client.roomName, client.playerName, row - 1, col - 1),
    );
    // Переходим в состояние ожидания ответа от сервера
    client.setState(ClientState.waitResponseFromServer);
  }

  // Ожидаем присоединения оппонента к комнате
  Future<void> waitingOpponentInRoom() async {
    var now = DateTime.now();
    // Если прошло более 3 секунд с момента последнего сообщения
    if (client.lastMsgTime == null ||
        now.difference(client.lastMsgTime!) > const Duration(seconds: 3)) {
      client.lastMsgTime = now;
      print('\nWaiting for opponent to join...');
      print('Press \'q\' and Enter to return to main menu');
      stdout.write('> ');
    }

    // Небольшая задержка, чтобы не нагружать процессор
    await Future.delayed(const Duration(milliseconds: 100));
  }
}
