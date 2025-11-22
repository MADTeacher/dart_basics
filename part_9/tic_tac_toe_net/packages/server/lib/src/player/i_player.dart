import 'dart:io';

import 'package:common/board.dart';
import 'package:common/message.dart';

// Интерфейс для любого игрока, будь то человек или компьютер
abstract interface class IPlayer {
  // Получение символа игрока (X или O)
  String get symbol;

  // Получение текущей фигуры игрока
  Cell get figure;

  // Установка фигуры игрока
  set figure(Cell figure);

  // Проверка, является ли игрок компьютером
  bool get isComputer;

  // Переключение хода на другого игрока
  void switchPlayer();

  // Отправка сообщения игроку-клиенту
  void sendMessage(ServerMessage message);

  // Выполнение хода игрока
  // Возвращает координаты хода (x, y) и признак успешности
  Future<({int x, int y, bool success})> makeMove(Board board);

  // Получение никнейма игрока
  String get nickName;

  // Проверка владения сокетом
  bool chekSocket(Socket socket);
}
