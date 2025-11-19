import 'dart:math';

import '../board/board.dart';
import '../board/cell_type.dart';
import 'i_player.dart';

// Уровни сложности компьютера
enum ComputerDifficulty {
  easy('Easy'),
  medium('Medium'),
  hard('Hard');

  final String name;

  const ComputerDifficulty(this.name);
}

class ComputerPlayer implements IPlayer {
  Cell _figure;
  ComputerDifficulty _difficulty;
  late Random _random;

  ComputerPlayer(this._figure, this._difficulty) {
    _random = Random();
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

  @override
  ({int x, int y, bool success}) makeMove(Board board) {
    print('$symbol (Computer) making move... ');

    int row, col;
    switch (_difficulty) {
      case ComputerDifficulty.easy:
        var result = _makeEasyMove(board);
        row = result.row;
        col = result.col;
      case ComputerDifficulty.medium:
        var result = _makeMediumMove(board);
        row = result.row;
        col = result.col;
      case ComputerDifficulty.hard:
        var result = _makeHardMove(board);
        row = result.row;
        col = result.col;
    }

    print('Move made (${row + 1}, ${col + 1})');
    return (x: row, y: col, success: true);
  }

  // Легкий уровень: случайный ход на свободную клетку
  ({int row, int col}) _makeEasyMove(Board board) {
    List<List<int>> emptyCells = _getEmptyCells(board);
    if (emptyCells.isEmpty) {
      return (row: -1, col: -1);
    }

    int randomIndex = _random.nextInt(emptyCells.length);
    return (row: emptyCells[randomIndex][0], col: emptyCells[randomIndex][1]);
  }

  // Средний уровень: проверяет возможность выигрыша
  // или блокировки выигрыша противника
  ({int row, int col}) _makeMediumMove(Board board) {
    // Проверяем, можем ли мы выиграть за один ход
    List<int>? move = _findWinningMove(board, _figure);
    if (move != null) {
      return (row: move[0], col: move[1]);
    }

    // Проверяем, нужно ли блокировать победу противника
    Cell opponentFigure = _figure == Cell.cross ? Cell.nought : Cell.cross;

    move = _findWinningMove(board, opponentFigure);
    if (move != null) {
      return (row: move[0], col: move[1]);
    }

    // Занимаем центр, если свободен (хорошая стратегия)
    int center = board.size ~/ 2;
    if (board.cells[center][center] == Cell.empty) {
      return (row: center, col: center);
    }

    // Занимаем угол, если свободен
    List<List<int>> corners = [
      [0, 0],
      [0, board.size - 1],
      [board.size - 1, 0],
      [board.size - 1, board.size - 1],
    ];

    for (List<int> corner in corners) {
      if (board.cells[corner[0]][corner[1]] == Cell.empty) {
        return (row: corner[0], col: corner[1]);
      }
    }

    // Если нет лучшего хода, делаем случайный ход
    return _makeEasyMove(board);
  }

  // Сложный уровень: использует алгоритм минимакс для оптимального хода
  ({int row, int col}) _makeHardMove(Board board) {
    // Если доска пустая, ходим в центр или угол (оптимальный первый ход)
    List<List<int>> emptyCells = _getEmptyCells(board);
    if (emptyCells.length == board.size * board.size) {
      // Первый ход - центр или угол
      int center = board.size ~/ 2;
      // 50% шанс выбрать центр на нечетной доске
      if (_random.nextInt(2) == 0 && board.size % 2 == 1) {
        return (row: center, col: center);
      } else {
        List<List<int>> corners = [
          [0, 0],
          [0, board.size - 1],
          [board.size - 1, 0],
          [board.size - 1, board.size - 1],
        ];
        List<int> randomCorner = corners[_random.nextInt(corners.length)];
        return (row: randomCorner[0], col: randomCorner[1]);
      }
    }

    // Для небольших досок (3x3) используем полный минимакс
    if (board.size <= 3) {
      int bestScore = -1000;
      List<int> bestMove = [-1, -1];

      // Рассматриваем все свободные клетки
      for (List<int> cell in emptyCells) {
        int row = cell[0];
        int col = cell[1];

        // Пробуем сделать ход
        board.cells[row][col] = _figure;

        // Вычисляем оценку хода через минимакс
        int score = _minimax(board, 0, false);

        // Возвращаем клетку в исходное состояние
        board.cells[row][col] = Cell.empty;

        // Обновляем лучший ход
        if (score > bestScore) {
          bestScore = score;
          bestMove = [row, col];
        }
      }

      return (row: bestMove[0], col: bestMove[1]);
    }

    // Для больших досок используем стратегию среднего уровня,
    // так как полный минимакс будет слишком ресурсоемким
    return _makeMediumMove(board);
  }

  // Алгоритм минимакс для определения оптимального хода
  int _minimax(Board board, int depth, bool isMaximizing) {
    Cell opponentFigure = _figure == Cell.cross ? Cell.nought : Cell.cross;

    // Проверяем терминальное состояние
    if (board.checkWin(_figure)) {
      return 10 - depth; // Выигрыш, чем быстрее, тем лучше
    } else if (board.checkWin(opponentFigure)) {
      return depth - 10; // Проигрыш, чем дольше, тем лучше
    } else if (board.checkDraw()) {
      return 0; // Ничья
    }

    List<List<int>> emptyCells = _getEmptyCells(board);

    if (isMaximizing) {
      int bestScore = -1000;

      // Проходим по всем свободным клеткам
      for (List<int> cell in emptyCells) {
        int row = cell[0];
        int col = cell[1];

        // Делаем ход
        board.cells[row][col] = _figure;

        // Рекурсивно оцениваем ход
        int score = _minimax(board, depth + 1, false);

        // Отменяем ход
        board.cells[row][col] = Cell.empty;

        bestScore = max(score, bestScore);
      }

      return bestScore;
    } else {
      int bestScore = 1000;

      // Проходим по всем свободным клеткам
      for (List<int> cell in emptyCells) {
        int row = cell[0];
        int col = cell[1];

        // Делаем ход противника
        board.cells[row][col] = opponentFigure;

        // Рекурсивно оцениваем ход
        int score = _minimax(board, depth + 1, true);

        // Отменяем ход
        board.cells[row][col] = Cell.empty;

        bestScore = min(score, bestScore);
      }

      return bestScore;
    }
  }

  // Вспомогательная функция для поиска хода, приводящего к выигрышу
  List<int>? _findWinningMove(Board board, Cell figure) {
    for (List<int> cell in _getEmptyCells(board)) {
      int row = cell[0];
      int col = cell[1];

      // Пробуем сделать ход
      board.cells[row][col] = figure;

      // Проверяем, приведет ли этот ход к выигрышу
      if (board.checkWin(figure)) {
        // Отменяем ход и возвращаем координаты
        board.cells[row][col] = Cell.empty;
        return [row, col];
      }

      // Отменяем ход
      board.cells[row][col] = Cell.empty;
    }

    return null; // Нет выигрышного хода
  }

  // Получение списка пустых клеток
  List<List<int>> _getEmptyCells(Board board) {
    List<List<int>> emptyCells = [];

    for (int i = 0; i < board.size; i++) {
      for (int j = 0; j < board.size; j++) {
        if (board.cells[i][j] == Cell.empty) {
          emptyCells.add([i, j]);
        }
      }
    }

    return emptyCells;
  }

  // Вспомогательные методы max и min
  int max(int a, int b) {
    return a > b ? a : b;
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
}
