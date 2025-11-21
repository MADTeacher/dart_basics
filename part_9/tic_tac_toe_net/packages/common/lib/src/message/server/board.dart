part of 'server_message.dart';

// Сообщение об изменении состояния игрового поля в комнате
class ChangedRoomBoardSM extends ServerMessage {
  final Board board;
  final Cell currentPlayer;

  ChangedRoomBoardSM(
    this.board,
    this.currentPlayer,
  ) : super(SMType.changedBoard);

  factory ChangedRoomBoardSM.fromJson(
    Map<String, dynamic> json,
  ) {
    return ChangedRoomBoardSM(
        Board.fromJson(json['board']),
        Cell.values.firstWhere(
          (e) => e.toString() == json['currentPlayer'],
        ));
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'board': board.toJson(),
      'currentPlayer': currentPlayer.toString(),
    };
  }
}

// Сообщение об окончании игры
class EndGameSM extends ServerMessage {
  final Board board;
  Cell winner;

  EndGameSM(
    this.board,
    this.winner,
  ) : super(SMType.endGame);

  factory EndGameSM.fromJson(
    Map<String, dynamic> json,
  ) {
    return EndGameSM(
      Board.fromJson(json['board']),
      Cell.values.firstWhere(
        (e) => e.toString() == json['winner'],
      ),
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'board': board.toJson(),
      'winner': winner.toString(),
    };
  }
}