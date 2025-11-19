part of 'server_message.dart';

// Сообщение со списком файлов завершенных игр
class WinnersListSM extends ServerMessage {
  final List<String> winners;

  WinnersListSM(this.winners) : super(SMType.winnersList);

  factory WinnersListSM.fromJson(Map<String, dynamic> json) {
    var winners = json['winners'] as List<dynamic>;
    return WinnersListSM(winners
        .map(
          (winner) => winner as String,
        )
        .toList());
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'winners': winners,
    };
  }
}

// Сообщение с информацией о конкретном матче
class WinnerInfoSM extends ServerMessage {
  final MatchHistory matchHistory;

  WinnerInfoSM(
    this.matchHistory,
  ) : super(SMType.winnerInfo);

  factory WinnerInfoSM.fromJson(Map<String, dynamic> json) {
    return WinnerInfoSM(
      MatchHistory.fromJson(
        json['matchHistory'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  Map<String, dynamic> _getBody() {
    return {
      'matchHistory': matchHistory.toJson(),
    };
  }
}