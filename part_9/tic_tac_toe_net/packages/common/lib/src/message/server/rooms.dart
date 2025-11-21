part of 'server_message.dart';

// Сообщение со списком существующих комнат
class RoomsInfoSM extends ServerMessage {
  final List<String> rooms;

  RoomsInfoSM(this.rooms) : super(SMType.roomsInfo);

  factory RoomsInfoSM.fromJson(Map<String, dynamic> json) {
    var rooms = json['rooms'] as List<dynamic>;
    return RoomsInfoSM(rooms
        .map(
          (room) => room as String,
        )
        .toList());
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'rooms': rooms,
    };
  }
}

// Сообщение о выходе из комнаты
class LeaveFromRoomSM extends ServerMessage {
  final String nickName;

  LeaveFromRoomSM(
    this.nickName,
  ) : super(SMType.leaveFromRoom);

  factory LeaveFromRoomSM.fromJson(Map<String, dynamic> json) {
    return LeaveFromRoomSM(
      json['nickName'] as String,
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'nickName': nickName,
    };
  }
}

// Сообщение о присоединении к комнате
class JoinToRoomSM extends ServerMessage {
  final String roomName;
  final Cell cellType;
  final Board board;

  JoinToRoomSM(
    this.roomName,
    this.cellType,
    this.board,
  ) : super(SMType.joinToRoom);

  factory JoinToRoomSM.fromJson(Map<String, dynamic> json) {
    return JoinToRoomSM(
      json['roomName'] as String,
      Cell.values.firstWhere(
        (e) => e.toString() == json['cellType'],
      ),
      Board.fromJson(json['board']),
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'roomName': roomName,
      'cellType': cellType.toString(),
      'board': board.toJson(),
    };
  }
}