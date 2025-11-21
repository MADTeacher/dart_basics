import '../board/board.dart';
import '../board/cell_type.dart';

final class FinishGameSnapshot {
  // Состояние игрового поля
  final Board board;
  // Фигура игрока (X или O)
  final Cell playerFigure;
  // Имя победителя
  final String winnerName;
  // Никнейм игрока
  final String playerNickName;
  // Время завершения игры
  final DateTime time;

  FinishGameSnapshot({
    required this.board,
    required this.playerFigure,
    required this.winnerName,
    required this.playerNickName,
    required this.time,
  });

  factory FinishGameSnapshot.fromJson(Map<String, dynamic> json) {
    return FinishGameSnapshot(
      board: Board.fromJson(json['board']),
      playerFigure: Cell.values.firstWhere(
        (e) => e.toString() == json['player_figure'],
      ),
      winnerName: json['winner_name'],
      playerNickName: json['nick_name'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board': board.toJson(),
      'player_figure': playerFigure.toString(),
      'winner_name': winnerName,
      'nick_name': playerNickName,
      'time': time.toIso8601String(),
    };
  }
}
