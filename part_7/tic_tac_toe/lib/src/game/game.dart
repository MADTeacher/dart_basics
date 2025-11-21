import 'dart:io';
import 'dart:math';

import '../board/board.dart';
import '../board/cell_type.dart';
import '../model/game_snapshot.dart';
import '../model/finish_game_shapshot.dart';
import '../player/computer_player.dart';
import '../player/i_player.dart';
import '../player/player.dart';
import '../database/i_database_provider.dart';
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
  final IDatabaseProvider _dbProvider;
  final GameMode _mode;
  final ComputerDifficulty? _difficulty;
  GameState _state;

  // Конструктор по умолчанию
  Game({
    required Board board,
    required IPlayer player1,
    required IPlayer player2,
    required IDatabaseProvider provider,
    required GameMode mode,
    ComputerDifficulty? difficulty,
    GameState state = GameState.playing,
  }) : _board = board,
       _player1 = player1,
       _player2 = player2,
       _currentPlayer = player1,
       _dbProvider = provider,
       _mode = mode,
       _difficulty = difficulty,
       _state = state;

  // Именованный конструктор для создания игры из сохраненного снапшота
  factory Game.fromSnapshot(GameSnapshot snapshot, IDatabaseProvider provider) {
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
      provider: provider,
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
  Future<bool> _handleSaveCommand(String input) async {
    // Проверяем, если пользователь ввел только "save" без имени файла
    if (input == _saveCommand) {
      print('Error: missing filename. Please use the format: save snapName');
      return true;
    }

    // Проверяем команду сохранения с именем файла
    if (input.startsWith('$_saveCommand ')) {
      final snapName = input.substring(_saveCommand.length + 1).trim();

      // Проверяем, что имя файла не пустое
      if (snapName.isEmpty) {
        print('Error: empty file name. Please use the format: save snapName');
        return true;
      }

      // Вводим никнейм под которым сохраняем снапшот
      print('Please, enter youre NickName: ');
      var nickName = stdin.readLineSync()!;
      if (nickName == '') {
        print('Error: empty NickName!');
        return true;
      }

      try {
        final snapshot = GameSnapshot(
          snapshotName: snapName,
          board: _board,
          playerFigure: _player1.cellType,
          gameState: _state.index,
          gameMode: _mode.index,
          difficulty: _difficulty?.toString(),
        );
        await _dbProvider.saveSnapshot(snapshot, nickName);
        print('Game saved to snapshot: $snapName');
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
        await _handleHumanMove();
      }

      if (_state == GameState.playing) {
        _updateState();
        if (_state == GameState.playing) {
          _switchCurrentPlayer();
        }
      }
    }

    await _printGameResult();
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
  Future<void> _handleHumanMove() async {
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
      if (await _handleSaveCommand(input)) {
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
  Future<void> _printGameResult() async {
    _board.printBoard();
    print('');
    String? winner;

    switch (_state) {
      case GameState.crossWin:
        print('X wins!');
        winner = 'X';
      case GameState.noughtWin:
        print('O wins!');
        winner = 'O';
      case GameState.draw:
        print("It's a draw!");
        winner = 'Draw';
      case GameState.quit:
        print('Game exited.');
      case GameState.playing:
        break;
    }

    if (winner != null) {
      await saveFinishedGame(winner);
    }
  }

  // Сохраняем результат игры
  Future<void> saveFinishedGame(String winner) async {
    // Запрашиваем ник игрока
    stdout.write('Enter your nickname to save the game result: ');
    final nickName = stdin.readLineSync()?.trim() ?? '';

    if (nickName.isEmpty) {
      print("Nickname is empty, game result not saved.");
      print('Press Enter to continue...');
      stdin.readLineSync();
      return;
    }

    try {
      // Создаем снапшот
      final finishSnapshot = FinishGameSnapshot(
        board: _board,
        playerFigure: _currentPlayer.cellType,
        winnerName: winner,
        playerNickName: nickName,
        time: DateTime.now(),
      );

      // Сохраняем в базу данных
      await _dbProvider.saveFinishedGame(finishSnapshot);
      print('Game result saved successfully!');
    } catch (e) {
      print('Error saving game result: $e');
    }
  }

  // Переадресуем вызов в функцию _createCustomGame
  // в game_setup.dart для создания игры
  // с пользовательскими настройками
  static Game createCustomGame(IDatabaseProvider provider) {
    return _createCustomGame(provider);
  }
}
