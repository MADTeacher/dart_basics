part of 'server_message.dart';

// Информация о комнате
class RoomInfo {
  final String name;
  final int boardSize;
  final bool isFull;
  final String gameMode; // "PvP" или "PvC"
  final String? difficulty; // "Easy", "Medium", "Hard" или null

  RoomInfo({
    required this.name,
    required this.boardSize,
    required this.isFull,
    required this.gameMode,
    this.difficulty,
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) {
    return RoomInfo(
      name: json['name'] as String,
      boardSize: json['boardSize'] as int,
      isFull: json['isFull'] as bool,
      gameMode: json['gameMode'] as String,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'boardSize': boardSize,
      'isFull': isFull,
      'gameMode': gameMode,
      if (difficulty != null) 'difficulty': difficulty,
    };
  }
}

// Сообщение со списком существующих комнат
class RoomsInfoSM extends ServerMessage {
  final List<RoomInfo> rooms;

  RoomsInfoSM(this.rooms) : super(SMType.roomsInfo);

  factory RoomsInfoSM.fromJson(Map<String, dynamic> json) {
    var rooms = json['rooms'] as List<dynamic>;
    return RoomsInfoSM(rooms
        .map(
          (room) => RoomInfo.fromJson(room as Map<String, dynamic>),
        )
        .toList());
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

// Сообщение о выходе из комнаты
class OpponentLeftSM extends ServerMessage {
  final String nickName;

  OpponentLeftSM(
    this.nickName,
  ) : super(SMType.opponentLeft);

  factory OpponentLeftSM.fromJson(Map<String, dynamic> json) {
    return OpponentLeftSM(
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