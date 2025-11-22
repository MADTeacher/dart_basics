import 'dart:async';
import 'dart:io';
import 'dart:convert';

import '../client.dart';
import 'client_state.dart';

// Класс для обработки пользовательского ввода
class InputHandler {
  // Клиент, с которым связан обработчик
  final TicTacToeClient client;
  // Очередь для хранения введенных строк
  final List<String> _inputQueue = [];
  // Подписка на стандартный ввод
  StreamSubscription? _stdinSubscription;
  // Комплетер для ожидания ввода
  Completer<String>? _inputWaiter;

  InputHandler(this.client);

  // Устанавливаем единый обработчик ввода
  void setup() {
    stdin.lineMode = true;
    stdin.echoMode = true;

    _stdinSubscription = stdin
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((String line) {
      // Обрабатываем ввод в зависимости от текущего состояния
      if (client.getState() == ClientState.waitingOpponentInRoom) {
        // Во время ожидания противника обрабатываем 'q' для выхода
        if (line.trim() == 'q') {
          client.leaveFromRoom();
        }
        // Игнорируем другой ввод
      } else {
        // В других состояниях добавляем в очередь или передаем ожидающему
        if (_inputWaiter != null && !_inputWaiter!.isCompleted) {
          _inputWaiter!.complete(line);
          _inputWaiter = null;
        } else {
          _inputQueue.add(line);
        }
      }
    });
  }

  // Читаем строку из единого обработчика ввода
  Future<String?> readLine() async {
    if (_inputQueue.isNotEmpty) {
      return _inputQueue.removeAt(0);
    }

    _inputWaiter = Completer<String>();
    return await _inputWaiter!.future;
  }

  // Закрываем обработчик ввода
  void close() {
    _stdinSubscription?.cancel();
  }
}

