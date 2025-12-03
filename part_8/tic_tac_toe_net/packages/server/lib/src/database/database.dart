import 'dart:async';
import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:common/finish_game_shapshot.dart';
import 'package:common/board.dart';
import 'i_database_provider.dart';
import 'db_exception.dart';

class SqliteDatabase implements IDatabaseProvider {
  final Database _db;

  SqliteDatabase._(this._db);

  static Future<SqliteDatabase> create(String dbPath) async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final db = await openDatabase(
      dbPath,
      version: 1,
      // Конфигурируем базу данных при открытии соединения
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        // Создаем таблицу завершенных игр
        await db.execute('''
          CREATE TABLE player_finish_games (
            id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            winner_name TEXT NOT NULL,
            another_player_name TEXT NOT NULL,
            board_json TEXT NOT NULL,
            player_figure INTEGER NOT NULL,
            time TEXT NOT NULL
          )
        ''');
      },
    );

    // Возвращаем экземпляр базы данных
    return SqliteDatabase._(db);
  }

  // Закрываем соединение с базой данных
  @override
  Future<void> close() async {
    await _db.close();
  }

  // Сохраняем информацию о завершенной игре
  @override
  Future<void> saveFinishedGame(FinishGameSnapshot snapshot) async {
    try {
      final boardJson = jsonEncode(snapshot.board.toJson());

      await _db.insert('player_finish_games', {
        'winner_name': snapshot.winnerName,
        'another_player_name': snapshot.playerNickName,
        'board_json': boardJson,
        'player_figure': snapshot.playerFigure.index,
        'time': snapshot.time.toIso8601String(),
      });
    } catch (e) {
      throw DbException('Failed to save finished game: $e');
    }
  }

  // Получаем все завершенные игры
  @override
  Future<List<FinishGameSnapshot>> getAllFinishedGames() async {
    try {
      final maps = await _db.query('player_finish_games');

      final finishedGames = <FinishGameSnapshot>[];
      for (final map in maps) {
        final boardJson = jsonDecode(map['board_json'] as String);
        final snapshot = FinishGameSnapshot(
          board: Board.fromJson(boardJson),
          playerFigure: Cell.values[map['player_figure'] as int],
          winnerName: map['winner_name'] as String,
          playerNickName: map['another_player_name'] as String,
          time: DateTime.parse(map['time'] as String),
        );
        finishedGames.add(snapshot);
      }
      return finishedGames;
    } catch (e) {
      throw DbException('Failed to get all finished games: $e');
    }
  }

  // Получаем конкретную завершенную игру
  @override
  Future<FinishGameSnapshot> getFinishedGameById(int id) async {
    try {
      final maps = await _db.query(
        'player_finish_games',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isEmpty) {
        throw DbException('Finished game not found');
      }
      final map = maps.first;
      final boardJson = jsonDecode(map['board_json'] as String);
      return FinishGameSnapshot(
        board: Board.fromJson(boardJson),
        playerFigure: Cell.values[map['player_figure'] as int],
        winnerName: map['winner_name'] as String,
        playerNickName: map['another_player_name'] as String,
        time: DateTime.parse(map['time'] as String),
      );
    } catch (e) {
      throw DbException('Failed to get finished game by id: $e');
    }
  }
}
