part of 'game.dart';

const int _defaultBoardSize = 3;
const int _minBoardSize = 3;
const int _maxBoardSize = 10;

// Функция для создания новой игры
// с пользовательскими настройками, в котором
// запрашивает у пользователя:
// - размер игрового поля
// - режим игры (PvP или PvC)
// - уровень сложности (для режима PvC)
Game _createCustomGame(IDatabaseProvider provider) {
  final size = _getBoardSize();
  final board = Board(size);
  final mode = _getGameMode();

  final difficulty = mode == GameMode.playerVsComputer
      ? _getDifficulty()
      : null;

  return _createGame(board, provider, mode, difficulty);
}

// Создаем новую игру с заданными параметрами
Game _createGame(
  Board board,
  IDatabaseProvider provider,
  GameMode mode,
  ComputerDifficulty? difficulty,
) {
  final player1 = Player(Cell.cross);
  final player2 = mode == GameMode.playerVsPlayer
      ? Player(Cell.nought)
      : ComputerPlayer(Cell.nought, difficulty ?? ComputerDifficulty.medium);

  return Game(
    board: board,
    player1: player1,
    player2: player2,
    provider: provider,
    mode: mode,
    difficulty: difficulty,
  );
}

// Запрашиваем у пользователя размер доски
int _getBoardSize() {
  while (true) {
    stdout.write(
      'Choose board size (min: $_minBoardSize, '
      'max: $_maxBoardSize, default: $_defaultBoardSize): ',
    );

    final input = stdin.readLineSync();
    if (input == null || input.isEmpty) {
      return _defaultBoardSize;
    }

    final size = int.tryParse(input);
    if (size == null || size < _minBoardSize || size > _maxBoardSize) {
      print('Invalid input. Please try again!');
      continue;
    }

    return size;
  }
}

// Запрашиваем у пользователя режим игры
GameMode _getGameMode() {
  while (true) {
    print('Choose game mode:');
    print('1 - Player vs Player (PvP)');
    print('2 - Player vs Computer (PvC)');
    stdout.write('Your choice: ');

    final input = stdin.readLineSync();
    if (input == null) {
      print('Invalid input. Please try again!');
      continue;
    }

    switch (input) {
      case '1':
        return GameMode.playerVsPlayer;
      case '2':
        return GameMode.playerVsComputer;
      default:
        print('Invalid input. Please try again!');
    }
  }
}

// Запрашиваем у пользователя уровень сложности компьютера
ComputerDifficulty _getDifficulty() {
  while (true) {
    print('Choose computer difficulty:');
    print('1 - Easy (random moves)');
    print('2 - Medium (block winning moves)');
    print('3 - Hard (optimal strategy)');
    stdout.write('Your choice: ');

    final input = stdin.readLineSync();
    if (input == null) {
      print('Invalid input. Please try again!');
      continue;
    }

    switch (input) {
      case '1':
        return ComputerDifficulty.easy;
      case '2':
        return ComputerDifficulty.medium;
      case '3':
        return ComputerDifficulty.hard;
      default:
        print('Invalid input. Please try again!');
    }
  }
}
