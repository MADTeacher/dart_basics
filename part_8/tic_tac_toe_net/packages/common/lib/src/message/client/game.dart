part of 'client_message.dart';

class MakeMoveCM extends ClientMessage {
  final String room; // имя игровой комнаты
  final String nickName; // имя игрока
  final int horizontal; // позиция по горизонтали
  final int vertical; // позиция по вертикали

  MakeMoveCM(
    this.room,
    this.nickName,
    this.horizontal,
    this.vertical,
  ) : super(CMType.makeMove);

  factory MakeMoveCM.fromJson(Map<String, dynamic> json) {
    return MakeMoveCM(
      json['room'] as String,
      json['nickName'] as String,
      json['horizontal'] as int,
      json['vertical'] as int,
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'room': room,
      'nickName': nickName,
      'horizontal': horizontal,
      'vertical': vertical,
    };
  }
}