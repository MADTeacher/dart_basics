import 'dart:io';
import 'dart:convert';

import 'package:common/board.dart';
import 'package:common/message.dart';

class Player {
  final String nickName;
  Cell? _cellType;
  Socket? _socket;

  Player(this.nickName, {Cell? cellType, Socket? socket})
      : _cellType = cellType,
        _socket = socket;

  factory Player.fromJson(Map<String, dynamic> json) {
    var nickName = json['nickName'] as String;
    var cellType = Cell.values.firstWhere(
      (e) => e.toString() == json['cellType'],
    );
    return Player(nickName, cellType: cellType);
  }

  void setSocket(Socket socket) {
    _socket = socket;
  }

  void sendMessage(ServerMessage message) {
    _socket?.write(jsonEncode(message));
  }

  set cellType(Cell cellType) {
    _cellType = cellType;
  }

  Cell get cellType => _cellType!;

  bool chekSocket(Socket socket) {
    return _socket == socket;
  }

  Map<String, dynamic> toJson() {
    return {
      'nickName': nickName,
      'cellType': _cellType.toString(),
    };
  }
}
