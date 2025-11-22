import 'board.dart';

class MatchHistory {
  final String winner;
  final String player1;
  final String player2;
  final Board board;

  MatchHistory({
    required this.winner,
    required this.player1,
    required this.player2,
    required this.board,
  });

  factory MatchHistory.fromJson(Map<String, dynamic> json) {
    return MatchHistory(
      winner: json['winner'] as String,
      player1: json['player1'] as String,
      player2: json['player2'] as String,
      board: Board.fromJson(json['board']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'winner': winner,
      'player1': player1,
      'player2': player2,
      'board': board.toJson(),
    };
  }
}