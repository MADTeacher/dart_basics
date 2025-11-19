part of 'client_message.dart';

// Сообщение о запросе списка комнат
class RoomsListCM extends ClientMessage {
  RoomsListCM() : super(CMType.roomsList);

  factory RoomsListCM.fromJson(Map<String, dynamic> json) {
    return RoomsListCM();
  }

  @override
  Map<String, dynamic> _getBody() {
    return {};
  }
}

// Сообщение о присоединении к комнате
class JoinToRoomCM extends ClientMessage {
  final String roomName;
  final String nickName;

  JoinToRoomCM(
    this.roomName,
    this.nickName,
  ) : super(CMType.joinToRoom);

  factory JoinToRoomCM.fromJson(Map<String, dynamic> json) {
    return JoinToRoomCM(
      json['roomName'] as String,
      json['nickName'] as String,
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'roomName': roomName,
      'nickName': nickName,
    };
  }
}

// Сообщение о выходе из комнаты
class LeaveFromRoomCM extends ClientMessage {
  final String roomName;
  final String nickName;

  LeaveFromRoomCM(
    this.roomName,
    this.nickName,
  ) : super(CMType.leaveFromRoom);

  factory LeaveFromRoomCM.fromJson(Map<String, dynamic> json) {
    return LeaveFromRoomCM(
      json['roomName'] as String,
      json['nickName'] as String,
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'roomName': roomName,
      'nickName': nickName,
    };
  }
}