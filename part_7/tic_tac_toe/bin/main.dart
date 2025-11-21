import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:tic_tac_toe/tic_tac_toe.dart';

// Загружаем сохраненную игру
Future<void> loadGame(IDatabaseProvider repository) async {
  while (true) {
    stdout.write('Input your nickname: ');
    final nickName = stdin.readLineSync()?.trim() ?? '';
    if (nickName.isEmpty) {
      print('Nickname cannot be empty!');
      continue;
    }

    List<GameSnapshot> snapshots;
    try {
      // Получаем все снапшоты игрока
      snapshots = await repository.getSnapshots(nickName);
    } catch (e) {
      print('Error loading game: $e');
      continue;
    }

    // Выводим все снапшоты игрока
    print('\n═══════════════════ SAVED GAMES ════════════════════');
    print('┌────────┬────────────────┬─────────┬─────────┬────────────┐');
    print('│   ID   │      Name      │  Figure │   Mode  │ Difficulty │');
    print('├────────┼────────────────┼─────────┼─────────┼────────────┤');

    if (snapshots.isEmpty) {
      print('│        │  No saved games found                              │');
      print('└────────┴───────────────────────────────────────────────────┘');
    } else {
      for (var i = 0; i < snapshots.length; i++) {
        final snapshot = snapshots[i];

        // Конвертируем режим игры (0=PvP, 1=PvC) в читаемый текст
        final gameMode = snapshot.gameMode == 0 ? 'PvP' : 'PvC';

        // Конвертируем сложность в читаемый текст
        String difficulty = '-';
        if (snapshot.gameMode == 1 && snapshot.difficulty != null) {
          // Извлекаем название из строки типа "ComputerDifficulty.easy"
          final parts = snapshot.difficulty!.split('.');
          difficulty = parts.length > 1 ? parts[1] : snapshot.difficulty!;
          // Делаем первую букву заглавной
          difficulty = difficulty[0].toUpperCase() + difficulty.substring(1);
        }

        // Форматированный вывод с выравниванием колонок
        final figure = snapshot.playerFigure.symbol;
        final name = snapshot.snapshotName.isEmpty
            ? 'Game $i'
            : snapshot.snapshotName;

        final id = i.toString().padRight(4);
        final namePadded = name.padRight(14).substring(0, 14);
        final figurePadded = figure.padRight(4);
        final modePadded = gameMode.padRight(5);
        final difficultyPadded = difficulty.padRight(7);

        print(
          '│   $id │ $namePadded │    $figurePadded │'
          '   $modePadded │    $difficultyPadded │',
        );
      }
      print('└────────┴────────────────┴─────────┴─────────┴────────────┘');
    }

    if (snapshots.isEmpty) {
      return;
    }

    // Запрашиваем номер снапшота
    int snapID;
    while (true) {
      stdout.write('Enter snapshot number: ');
      final num = stdin.readLineSync()?.trim() ?? '';

      final parsed = int.tryParse(num);
      if (parsed == null || parsed < 0 || parsed >= snapshots.length) {
        print('Invalid snapshot number. Please try again.');
        continue;
      }
      snapID = parsed;
      break;
    }

    // Восстанавливаем игру из снапшота
    final loadedGame = Game.fromSnapshot(snapshots[snapID], repository);

    // Запускаем игру
    await loadedGame.play();
    break;
  }
}

// Показываем все завершенные игры
Future<void> showFinishedGames(IDatabaseProvider repository) async {
  stdout.write('Enter nickname: ');
  final nickName = stdin.readLineSync()?.trim() ?? '';
  if (nickName.isEmpty) {
    print('Nickname cannot be empty!');
    return;
  }

  List<FinishGameSnapshot> finishedGames;
  try {
    // Получаем все завершенные игры
    finishedGames = await repository.getFinishedGames(nickName);
  } catch (e) {
    print('Error loading finished games: $e');
    return;
  }

  print('\n═══════════════════ FINISHED GAMES ════════════════════');
  print('┌────────┬─────────┬────────────┬────────────────┐');
  print('│   ID   │  Figure │   Winner   │      Date      │');
  print('├────────┼─────────┼────────────┼────────────────┤');

  if (finishedGames.isEmpty) {
    print('│        │ No finished games found                      │');
    print('└────────┴───────────────────────────────────────────────┘');
  } else {
    for (var i = 0; i < finishedGames.length; i++) {
      final game = finishedGames[i];

      // Форматированный вывод с выравниванием колонок
      final figure = game.playerFigure.symbol;

      // Форматируем дату (день.месяц часы:минуты)
      final dateStr =
          '${game.time.day.toString().padLeft(2, '0')}.'
          '${game.time.month.toString().padLeft(2, '0')} '
          '${game.time.hour.toString().padLeft(2, '0')}:'
          '${game.time.minute.toString().padLeft(2, '0')}';

      final id = i.toString().padRight(4);
      final figurePadded = figure.padRight(4);
      final winnerPadded = game.winnerName.padRight(8).substring(0, 8);
      final datePadded = dateStr.padRight(13);

      print('│   $id │    $figurePadded │  $winnerPadded  │  $datePadded │');
    }
    print('└────────┴─────────┴────────────┴────────────────┘');
  }

  if (finishedGames.isEmpty) {
    return;
  }

  // Запрашиваем номер игры
  int snapID;
  while (true) {
    stdout.write('Enter game number: ');
    final num = stdin.readLineSync()?.trim() ?? '';

    final parsed = int.tryParse(num);
    if (parsed == null || parsed < 0 || parsed >= finishedGames.length) {
      print('Invalid game number. Please try again.');
      continue;
    }
    snapID = parsed;
    break;
  }

  // Выводим выбранную игру
  final chosenGame = finishedGames[snapID];
  chosenGame.board.printBoard();
  print('');
  print('Winner: ${chosenGame.winnerName}');
  final fullDate =
      '${chosenGame.time.day.toString().padLeft(2, '0')}.'
      '${chosenGame.time.month.toString().padLeft(2, '0')}.'
      '${chosenGame.time.year} '
      '${chosenGame.time.hour.toString().padLeft(2, '0')}:'
      '${chosenGame.time.minute.toString().padLeft(2, '0')}';
  print('Date: $fullDate');
  print('');
}

void main() async {
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных. Если мы не укажем абсолютный путь,
  // то БД будет создана в следующей директории проекта:
  // .dart_tool\sqflite_common_ffi\databases
  final dbPath = p.join(appDocumentsDir.path, 'tic_tac.db');

  final repository = await SqliteDatabase.create(dbPath);

  while (true) {
    print('Welcome to Tic-Tac-Toe!');
    print('1 - Load game');
    print('2 - New game');
    print('3 - Show all finished games');
    print('q - Exit');
    stdout.write('Your choice: ');

    final input = stdin.readLineSync()?.trim() ?? '';

    switch (input) {
      case '1': // Загрузка сохраненной игры
        await loadGame(repository);

      case '2': // Создаем новую игру с помощью диалога настройки
        final newGame = Game.createCustomGame(repository);
        // Запускаем игру
        await newGame.play();

      case '3': // Показать все завершенные игры
        await showFinishedGames(repository);

      case 'q':
        print('Goodbye!');
        await repository.close();
        exit(0);

      default:
        print('Invalid choice. Please try again.');
    }
  }
}
