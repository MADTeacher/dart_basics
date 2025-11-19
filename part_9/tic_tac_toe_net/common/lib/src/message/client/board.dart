part of 'client_message.dart';

class CellValueCM extends ClientMessage {
  final String room; // имя игровой комнаты
  final String nickName; // имя игрока
  final int horizontal; // позиция по горизонтали
  final int vertical; // позиция по вертикали

  CellValueCM(
    this.room,
    this.nickName,
    this.horizontal,
    this.vertical,
  ) : super(CMType.cellValue);

  factory CellValueCM.fromJson(Map<String, dynamic> json) {
    return CellValueCM(
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