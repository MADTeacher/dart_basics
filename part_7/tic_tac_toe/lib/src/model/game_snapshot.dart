import '../board/board.dart';
import '../board/cell_type.dart';

final class GameSnapshot {
  final String snapshotName;
  // Текущее состояние игрового поля
  final Board board;
  // Текущий символ игрока, который ходит
  final Cell playerFigure;
  // Текущее состояние игры
  final int gameState;
  // Текущий режим игры (0 - PvP, 1 - PvC)
  final int gameMode;
  // Уровень сложности компьютера
  final String? difficulty;

  GameSnapshot({
    required this.snapshotName,
    required this.board,
    required this.playerFigure,
    required this.gameState,
    required this.gameMode,
    this.difficulty,
  });

  factory GameSnapshot.fromJson(Map<String, dynamic> json) {
    return GameSnapshot(
      snapshotName: json['name'],
      board: Board.fromJson(json['board']),
      playerFigure: Cell.values.firstWhere(
        (e) => e.toString() == json['playerFigure'],
      ),
      gameState: json['gameState'],
      gameMode: json['gameMode'],
      difficulty: json['difficulty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': snapshotName,
      'board': board.toJson(),
      'playerFigure': playerFigure.toString(),
      'gameState': gameState,
      'gameMode': gameMode,
      'difficulty': difficulty,
    };
  }
}
