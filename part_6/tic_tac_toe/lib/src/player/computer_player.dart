import '../board/board.dart';
import '../board/cell_type.dart';
import 'i_player.dart';
import 'ai_strategy/difficulty_strategy.dart';
import 'ai_strategy/easy_strategy.dart';
import 'ai_strategy/medium_strategy.dart';
import 'ai_strategy/isolate_hard_strategy.dart';

// Уровни сложности компьютера
enum ComputerDifficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  final String name;

  const ComputerDifficulty(this.name);
}

// Класс, реализующий функционал компьютерного игрока
class ComputerPlayer implements IPlayer {
  Cell _figure;
  ComputerDifficulty _difficulty;
  late DifficultyStrategy _strategy;

  ComputerPlayer(this._figure, this._difficulty) {
    _strategy = _getStrategy(_difficulty);
  }

  factory ComputerPlayer.fromJson(Map<String, dynamic> json) {
    return ComputerPlayer(
      Cell.values.firstWhere((e) => e.toString() == json['cellType']),
      ComputerDifficulty.values.firstWhere(
        (e) => e.toString() == json['difficulty'],
      ),
    );
  }

  @override
  Cell get cellType => _figure;

  @override
  void switchPlayer() {
    _figure = _figure == Cell.cross ? Cell.nought : Cell.cross;
  }

  @override
  String get symbol => _figure.symbol;

  @override
  Map<String, dynamic> toJson() {
    return {
      'cellType': _figure.toString(),
      'difficulty': _difficulty.toString(),
    };
  }

  @override
  bool get isComputer => true;

  // Выполнение хода компьютером
  @override
  Future<({int x, int y, bool success})> makeMove(Board board) async {
    print('$symbol (Computer) making move... ');
    // Применяем стратегию для расчета хода
    var result = await _strategy.makeMove(board, _figure);
    int row = result.row;
    int col = result.col;

    print('Move made (${row + 1}, ${col + 1})');
    return (x: row, y: col, success: true);
  }

  // Возвращаем стратегию в зависимости от уровня сложности
  DifficultyStrategy _getStrategy(ComputerDifficulty difficulty) {
    switch (difficulty) {
      case ComputerDifficulty.easy:
        return const EasyStrategy();
      case ComputerDifficulty.medium:
        return const MediumStrategy();
      case ComputerDifficulty.hard:
        return const IsolateHardStrategy();
    }
  }
}
