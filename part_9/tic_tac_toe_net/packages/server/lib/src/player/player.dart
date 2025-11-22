import 'dart:convert';
import 'dart:io';

import 'package:common/board.dart';
import 'package:common/message.dart';
import 'i_player.dart';

class Player implements IPlayer {
  final String _nickName;
  Cell? _figure;
  Socket? _socket;

  Player(this._nickName, {Cell? figure, Socket? socket})
    : _figure = figure,
      _socket = socket;

  factory Player.fromJson(Map<String, dynamic> json) {
    var nickName = json['nickName'] as String;
    var cellType = Cell.values.firstWhere(
      (e) => e.toString() == json['cellType'],
    );
    return Player(nickName, figure: cellType);
  }

  // Возвращаем текущую фигуру игрока
  @override
  Cell get figure => _figure!;

  @override
  set figure(Cell figure) {
    _figure = figure;
  }

  // Изменяем фигуру текущего игрока
  @override
  void switchPlayer() {
    _figure = _figure == Cell.cross ? Cell.nought : Cell.cross;
  }

  // Возвращаем символ игрока
  @override
  String get symbol => _figure?.symbol ?? '';

  @override
  bool get isComputer => false;

  // Метод-заглушка, т.к. ввод игрока осуществляется на
  // уровне пакета game, где нужно еще отрабатывать
  // команду на выход и сохранение игровой сессии
  @override
  Future<({int x, int y, bool success})> makeMove(Board board) async {
    return (x: -1, y: -1, success: false);
  }

  @override
  bool chekSocket(Socket socket) {
    return _socket == socket;
  }

  @override
  String get nickName => _nickName;

  @override
  void sendMessage(ServerMessage message) {
    if (_socket != null) {
      final jsonStr = jsonEncode(message);
      _socket!.write(jsonStr);
    }
  }

  void setSocket(Socket socket) {
    _socket = socket;
  }
}
