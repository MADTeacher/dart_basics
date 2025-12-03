part of 'server_message.dart';

// Сообщение об изменении состояния игрового поля в комнате
class UpdateStateSM extends ServerMessage {
  final Board board;
  final Cell currentPlayer;

  UpdateStateSM(
    this.board,
    this.currentPlayer,
  ) : super(SMType.updateState);

  factory UpdateStateSM.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateStateSM(
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

class InitiateGameSM extends ServerMessage {
  final Board board;
  final Cell currentPlayer;

  InitiateGameSM(this.board, this.currentPlayer) : super(SMType.initiateGame);

  factory InitiateGameSM.fromJson(Map<String, dynamic> json) {
    return InitiateGameSM(
      Board.fromJson(json['board']),
      Cell.values.firstWhere(
        (e) => e.toString() == json['currentPlayer'],
      ),
    );
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