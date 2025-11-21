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

// Класс для хранения информации об изоляте
class _IsolateInfo {
  final Isolate isolate;
  final SendPort sendPort;

  _IsolateInfo({required this.isolate, required this.sendPort});
}

// Стратегия сложного уровня с использованием изолятов
// для параллельной оценки ходов на больших досках
class IsolateHardStrategy implements DifficultyStrategy {
  // Стратегия для небольших и пустых досок
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

    // Иначе используем параллельную оценку ходов
    return await _makeParallelMinimaxMove(board, figure, emptyCells);
  }

  // Параллельная оценка ходов с использованием изолятов
  Future<({int row, int col})> _makeParallelMinimaxMove(
    Board board,
    Cell figure,
    List<List<int>> emptyCells,
  ) async {
    // Определяем количество изолятов. Берем минимальное из
    // количества доступных потоков на CPU и количества пустых ячеек
    final numberOfIsolates = min(
      Platform.numberOfProcessors,
      emptyCells.length,
    );

    print(
      'Using $numberOfIsolates isolates for '
      'board ${board.size}x${board.size}',
    );
    // Запускаем таймер для измерения времени
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

      stopwatch.stop(); // Останавливаем таймер
      print(
        'Parallel evaluation completed in '
        '${stopwatch.elapsedMilliseconds}ms',
      );

      // Находим лучший ход и возвращаем его
      MinimaxResult best = results.reduce((a, b) => a.score > b.score ? a : b);

      return (row: best.row, col: best.col);
    } finally {
      // Убиваем изоляты
      await _cleanupIsolates(isolates);
    }
  }

  // Создаем пул, в котором будет count изолятов
  Future<List<_IsolateInfo>> _createIsolatePool(int count) async {
    final List<_IsolateInfo> isolates = [];

    for (int i = 0; i < count; i++) {
      final receivePort = ReceivePort();
      // Запускаем изолят и передаем ему порт
      // для отправки результатов
      final isolate = await Isolate.spawn(minimaxWorker, receivePort.sendPort);

      // Получаем SendPort от изолята
      final sendPort = await receivePort.first as SendPort;

      isolates.add(_IsolateInfo(isolate: isolate, sendPort: sendPort));
    }

    return isolates;
  }

  // Распределяем задачи между изолятами и собираем результаты
  Future<List<MinimaxResult>> _distributeTasksToIsolates(
    List<_IsolateInfo> isolates,
    Board board,
    Cell figure,
    List<List<int>> emptyCells,
  ) async {
    // Список будущих результатов
    final List<Future<MinimaxResult>> futures = [];
    int isolateIndex = 0;

    // Начинаем распределять ходы по изолятам
    int? maxDepth;
    int emptyCount = emptyCells.length;

    if (board.size >= _minBoardSizeForIsolates) {
      // Адаптивная глубина в зависимости от заполненности
      // для досок размером nxn и выше,
      // где n = _minBoardSizeForIsolates, т.к.
      // слишком большая глубина поиска может привести к проблемам
      // с производительностью
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
      'Using depth $maxDepth for board ${board.size}'
      'x${board.size} with $emptyCount empty cells',
    );

    // Начинаем распределять ходы по изолятам
    for (final cell in emptyCells) {
      // Получаем изолят
      final isolateInfo = isolates[isolateIndex];
      // Увеличиваем isolateIndex
      isolateIndex = (isolateIndex + 1) % isolates.length;

      // Отправляем задачу в изолят
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

    // Ждем и возвращаем все результаты
    return await Future.wait(futures);
  }

  // Отправляем задачу в изолят и получаем результат
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

    return response; // Возвращаем результат
  }

  // Убиваем изоляты
  Future<void> _cleanupIsolates(List<_IsolateInfo> isolates) async {
    for (final isolateInfo in isolates) {
      isolateInfo.isolate.kill(priority: Isolate.immediate);
    }
  }
}
