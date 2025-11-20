import 'dart:io';
import 'dart:math';

import '../board/board.dart';
import '../board/cell_type.dart';
import '../model/game_snapshot.dart';
import '../player/computer_player.dart';
import '../player/i_player.dart';
import '../player/player.dart';
import '../storage/i_game_storage.dart';
import 'game_state.dart';

part 'game_setup.dart';

// Основной класс игры "Крестики-нолики"
class Game {
  // Константы для команд и границ
  static const String _saveCommand = 'save';
  static const String _quitCommand = 'q';

  // Поля (переменные) класса
  final Board _board;
  final IPlayer _player1;
  final IPlayer _player2;
  IPlayer _currentPlayer;
  final IGameSaver _saver;
  final GameMode _mode;
  final ComputerDifficulty? _difficulty;
  GameState _state;

  // Конструктор по умолчанию
  Game({
    required Board board,
    required IPlayer player1,
    required IPlayer player2,
    required IGameSaver saver,
    required GameMode mode,
    ComputerDifficulty? difficulty,
    GameState state = GameState.playing,
  }) : _board = board,
       _player1 = player1,
       _player2 = player2,
       _currentPlayer = player1,
       _saver = saver,
       _mode = mode,
       _difficulty = difficulty,
       _state = state;

  // Именованный конструктор для создания игры из сохраненного снапшота
  factory Game.fromSnapshot(GameSnapshot snapshot, IGameSaver saver) {
    final mode = GameMode.values[snapshot.gameMode];
    final state = GameState.values[snapshot.gameState];

    ComputerDifficulty? difficulty;
    if (snapshot.difficulty != null) {
      difficulty = ComputerDifficulty.values.firstWhere(
        (e) => e.toString() == snapshot.difficulty,
      );
    }

    final player1 = Player(snapshot.playerFigure);
    final player2Figure = snapshot.playerFigure == Cell.cross
        ? Cell.nought
        : Cell.cross;

    final player2 = mode == GameMode.playerVsPlayer
        ? Player(player2Figure)
        : ComputerPlayer(
            player2Figure,
            difficulty ?? ComputerDifficulty.medium,
          );

    return Game(
      board: snapshot.board,
      player1: player1,
      player2: player2,
      saver: saver,
      mode: mode,
      difficulty: difficulty,
      state: state,
    );
  }

  // Геттеры для доступа к приватным полям
  Board get board => _board;
  GameState get state => _state;
  GameMode get mode => _mode;

  // Переключаем активного игрока
  void _switchCurrentPlayer() {
    _currentPlayer = _currentPlayer == _player1 ? _player2 : _player1;
  }

  // Обновляем состояние игры после хода
  void _updateState() {
    if (_board.checkWin(Cell.cross)) {
      _state = GameState.crossWin;
    } else if (_board.checkWin(Cell.nought)) {
      _state = GameState.noughtWin;
    } else if (_board.checkDraw()) {
      _state = GameState.draw;
    }
  }

  // Проверяем и обрабатываем команду сохранения
  bool _handleSaveCommand(String input) {
    // Проверяем, если пользователь ввел только "save" без имени файла
    if (input == _saveCommand) {
      print('Error: missing filename. Please use the format: save filename');
      return true;
    }

    // Проверяем команду сохранения с именем файла
    if (input.startsWith('$_saveCommand ')) {
      final filename = input.substring(_saveCommand.length + 1).trim();

      // Проверяем, что имя файла не пустое
      if (filename.isEmpty) {
        print('Error: empty file name. Please use the format: save filename');
        return true;
      }

      try {
        final snapshot = GameSnapshot(
          board: _board,
          playerFigure: _player1.cellType,
          gameState: _state.index,
          gameMode: _mode.index,
          difficulty: _difficulty?.toString(),
        );
        _saver.saveGame(snapshot, filename);
        print('Game saved to file: $filename');
        return true;
      } catch (e) {
        print('Error saving game: $e');
        return false;
      }
    }
    return false;
  }

  // Запускаем основной цикл игры
  Future<void> play() async {
    // Случайный выбор первого игрока
    _randomizeFirstPlayer();

    print('For saving the game enter: save filename');
    print('For exiting the game enter: q');
    print('For making a move enter: row col');
    print('');

    while (_state == GameState.playing) {
      _board.printBoard();

      if (_isComputerTurn) {
        await _handleComputerMove();
      } else {
        _handleHumanMove();
      }

      if (_state == GameState.playing) {
        _updateState();
        if (_state == GameState.playing) {
          _switchCurrentPlayer();
        }
      }
    }

    _printGameResult();
  }

  // Проверяем, является ли текущий ход ходом компьютера
  bool get _isComputerTurn =>
      _mode == GameMode.playerVsComputer && _currentPlayer.isComputer;

  // Обрабатываем ход компьютера
  Future<void> _handleComputerMove() async {
    print('Computer is making a move...');
    final result = await _currentPlayer.makeMove(_board);

    if (result.success) {
      _board.setSymbol(result.x, result.y, _currentPlayer.cellType);
    }
  }

  // Обрабатываем ход игрока-человека
  void _handleHumanMove() {
    var validInput = false;

    while (!validInput) {
      stdout.write(
        "${_currentPlayer.symbol}'s turn. Enter row and column (e.g. 1 2): ",
      );

      final input = stdin.readLineSync();
      if (input == null) {
        print('Invalid input. Please try again!');
        continue;
      }

      // Проверка выхода из игры
      if (input == _quitCommand) {
        _state = GameState.quit;
        break;
      }

      // Проверка и выполнение сохранения игры
      if (_handleSaveCommand(input)) {
        continue;
      }

      // Парсим ввод и выполняем ход
      if (_tryMakeMove(input)) {
        validInput = true;
      }
    }
  }

  // Пытаемся выполнить ход игрока
  bool _tryMakeMove(String input) {
    final parseResult = (_currentPlayer as Player).parseMove(input, _board);
    if (!parseResult.success) {
      print('Invalid data. Please try again!');
      return false;
    }

    if (!_board.setSymbol(
      parseResult.x,
      parseResult.y,
      _currentPlayer.cellType,
    )) {
      print('This cell is already occupied!');
      return false;
    }

    return true;
  }

  // Случайно выбираем первого игрока
  void _randomizeFirstPlayer() {
    final random = Random();
    if (random.nextBool()) {
      _currentPlayer = _player2;
      print('${_player2.cellType.symbol} turn first!');
    } else {
      _currentPlayer = _player1;
      print('${_player1.cellType.symbol} turn first!');
    }
    print('');
  }

  // Выводим результат игры
  void _printGameResult() {
    _board.printBoard();
    print('');

    switch (_state) {
      case GameState.crossWin:
        print('X wins!');
      case GameState.noughtWin:
        print('O wins!');
      case GameState.draw:
        print("It's a draw!");
      case GameState.quit:
        print('Game exited.');
      case GameState.playing:
        break;
    }
  }

  // Переадресуем вызов в функцию _createCustomGame
  // в game_setup.dart для создания игры
  // с пользовательскими настройками
  static Game createCustomGame(IGameSaver saver) {
    return _createCustomGame(saver);
  }
}
