import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import '../../board/board.dart';
import '../../board/cell_type.dart';
import 'board_helper.dart';
import 'difficulty_strategy.dart';
import 'hard_strategy.dart';
import 'isolate_worker.dart';
import 'minimax_task.dart';

// Стратегия сложного уровня с использованием изолятов
// для параллельной оценки ходов на больших досках
class IsolateHardStrategy implements DifficultyStrategy {
  // Стратегия для небольших и пустыхдосок
  final HardStrategy _hardStrategy = const HardStrategy();

  // Минимальный размер доски для использования изолятов
  static const int _minBoardSizeForIsolates = 4;

  const IsolateHardStrategy();

  @override
  Future<({int row, int col})> makeMove(Board board, Cell figure) async {
    // Если доска слишком маленькая или полностью пустая,
    // используем HardStrategy
    List<List<int>> emptyCells = BoardHelper.getEmptyCells(board);
    if ((board.size < _minBoardSizeForIsolates) ||
        (emptyCells.length == board.size * board.size)) {
      return _hardStrategy.makeMove(board, figure);
    }

    return await _makeParallelMinimaxMove(board, figure, emptyCells);
  }

  // Параллельная оценка ходов с использованием изолятов
  Future<({int row, int col})> _makeParallelMinimaxMove(
    Board board,
    Cell figure,
    List<List<int>> emptyCells,
  ) async {
    final numberOfIsolates = min(
      Platform.numberOfProcessors,
      emptyCells.length,
    );

    print(
      'Using $numberOfIsolates isolates for board ${board.size}x${board.size}',
    );
    final stopwatch = Stopwatch()..start();

    // Создаем изоляты
    final isolates = await _createIsolatePool(numberOfIsolates);

    try {
      // Распределяем задачи между изолятами
      final results = await _distributeTasksToIsolates(
        isolates,
        board,
        figure,
        emptyCells,
      );

      stopwatch.stop();
      print(
        'Parallel evaluation completed in ${stopwatch.elapsedMilliseconds}ms',
      );

      // Находим лучший ход
      MinimaxResult best = results.reduce((a, b) => a.score > b.score ? a : b);

      return (row: best.row, col: best.col);
    } finally {
      // Очищаем изоляты
      await _cleanupIsolates(isolates);
    }
  }

  /// Создает пул изолятов
  Future<List<_IsolateInfo>> _createIsolatePool(int count) async {
    final List<_IsolateInfo> isolates = [];

    for (int i = 0; i < count; i++) {
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(minimaxWorker, receivePort.sendPort);

      // Получаем SendPort от изолята
      final sendPort = await receivePort.first as SendPort;

      isolates.add(_IsolateInfo(isolate: isolate, sendPort: sendPort));
    }

    return isolates;
  }

  /// Распределяет задачи между изолятами и собирает результаты
  Future<List<MinimaxResult>> _distributeTasksToIsolates(
    List<_IsolateInfo> isolates,
    Board board,
    Cell figure,
    List<List<int>> emptyCells,
  ) async {
    final List<Future<MinimaxResult>> futures = [];
    int isolateIndex = 0;

    // Распределяем каждый ход по изолятам (round-robin)
    // Определяем глубину поиска (снижена с 4 до 2 для оптимизации)
    int? maxDepth;
    int emptyCount = emptyCells.length;

    if (board.size >= _minBoardSizeForIsolates) {
      // Адаптивная глубина в зависимости от заполненности
      // для досок размером nxn и выше,
      // где n = _minBoardSizeForIsolates
      if (emptyCount > 20) {
        maxDepth = 3; // Начало игры - минимальная глубина
      } else if (emptyCount > 15) {
        maxDepth = 3; // Середина игры
      } else if (emptyCount > 10) {
        maxDepth = 4; // Ближе к концу
      } else {
        maxDepth = 5; // Эндшпиль - можем глубже
      }

      // Дополнительные ограничения для больших досок
      if (board.size >= 7) {
        maxDepth = min(maxDepth, 2);
      }
    }

    print(
      'Using depth $maxDepth for board ${board.size}x${board.size} with $emptyCount empty cells',
    );

    for (final cell in emptyCells) {
      final isolateInfo = isolates[isolateIndex];
      isolateIndex = (isolateIndex + 1) % isolates.length;

      futures.add(
        _sendTaskToIsolate(
          isolateInfo,
          board,
          figure,
          cell[0],
          cell[1],
          maxDepth,
        ),
      );
    }

    // Ждем все результаты
    return await Future.wait(futures);
  }

  /// Отправляет задачу в изолят и получает результат
  Future<MinimaxResult> _sendTaskToIsolate(
    _IsolateInfo isolateInfo,
    Board board,
    Cell figure,
    int row,
    int col,
    int? maxDepth,
  ) async {
    final responsePort = ReceivePort();

    // Создаем задачу с responsePort для получения ответа
    final task = MinimaxTask(
      boardState: board,
      figure: figure,
      row: row,
      col: col,
      responsePort: responsePort.sendPort,
      maxDepth: maxDepth,
    );

    // Отправляем задачу в изолят
    isolateInfo.sendPort.send(task);

    // Ждем ответа
    final response = await responsePort.first as MinimaxResult;

    // Закрываем порт
    responsePort.close();

    return response;
  }

  /// Очищает изоляты
  Future<void> _cleanupIsolates(List<_IsolateInfo> isolates) async {
    for (final isolateInfo in isolates) {
      isolateInfo.isolate.kill(priority: Isolate.immediate);
    }
  }
}

/// Информация об изоляте
class _IsolateInfo {
  final Isolate isolate;
  final SendPort sendPort;

  _IsolateInfo({required this.isolate, required this.sendPort});
}
