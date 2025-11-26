import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:common/message.dart';

import 'message_handlers.dart';
import '../client.dart';

// Класс для работы с сокетом и буфером сообщений
class SocketHandler {
  // Клиент, с которым связан обработчик
  final TicTacToeClient client;
  // Сокет для связи с сервером
  Socket? socket;
  // Буфер для хранения сообщений
  String _messageBuffer = '';

  SocketHandler(this.client);

  // Подключаемся к серверу
  Future<void> connect(String serverIP, int serverPort) async {
    socket = await Socket.connect(serverIP, serverPort);
    print('Connected to server.');
    _startReadingMessages();
  }

  // Отправляем сообщение на сервер
  void sendToServer(ClientMessage message) {
    if (socket != null) {
      socket!.write(jsonEncode(message));
    }
  }

  // Запускаем чтение сообщений от сервера
  void _startReadingMessages() {
    // Подписываемся на чтение сообщений от сервера
    // и записываем их в буфер, с последующей обработкой
    socket
        ?.cast<List<int>>()
        .transform(utf8.decoder)
        .listen(
          (String chunk) {
            _messageBuffer += chunk;
            _processBuffer();
          },
          onDone: () {
            print('Connection closed');
            client.close();
          },
          onError: (error) {
            print('Connection error: $error');
            client.close();
          },
        );
  }

  // Обрабатываем буфер сообщений
  void _processBuffer() {
    // Пытаемся распарсить JSON из буфера
    while (_messageBuffer.isNotEmpty) {
      // Пропускаем пробелы в начале
      _messageBuffer = _messageBuffer.trimLeft();
      if (_messageBuffer.isEmpty) break;

      // Ищем полный JSON объект
      int braceCount = 0;
      bool inString = false;
      bool escaped = false;
      int startIndex = 0;

      if (_messageBuffer[startIndex] != '{') {
        // Если не JSON объект, очищаем буфер
        _messageBuffer = '';
        break;
      }

      // Ищем конец JSON объекта
      int endIndex = -1;
      for (int i = startIndex; i < _messageBuffer.length; i++) {
        final char = _messageBuffer[i];

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
        final jsonStr = _messageBuffer.substring(startIndex, endIndex + 1);
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        final message = ServerMessage.fromJson(json);
        messageHandler(message, client);

        // Удаляем обработанную часть из буфера
        _messageBuffer = _messageBuffer.substring(endIndex + 1);
      } catch (e) {
        print('Error parsing message: $e');
        _messageBuffer = '';
        break;
      }
    }
  }

  // Закрываем соединение с сервером
  void close() {
    socket?.destroy();
  }
}

