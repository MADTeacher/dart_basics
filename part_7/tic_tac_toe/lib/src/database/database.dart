import 'dart:async';
import 'dart:convert';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../model/game_snapshot.dart';
import '../model/finish_game_shapshot.dart';
import '../board/cell_type.dart';
import '../board/board.dart';
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
        // Создаем таблицу игроков
        await db.execute('''
          CREATE TABLE player (
            nick_name TEXT PRIMARY KEY NOT NULL
          )
        ''');

        // Создаем таблицу снапшотов игр
        await db.execute('''
          CREATE TABLE game_snapshot (
            id INTEGER PRIMARY KEY,
            snapshot_name TEXT NOT NULL,
            board_json TEXT NOT NULL,
            player_figure INTEGER NOT NULL,
            state INTEGER NOT NULL,
            mode INTEGER NOT NULL,
            difficulty TEXT NOT NULL,
            player_nick_name TEXT NOT NULL,
            FOREIGN KEY (player_nick_name) REFERENCES player(nick_name)
          )
        ''');

        // Создаем таблицу завершенных игр
        await db.execute('''
          CREATE TABLE player_finish_game (
            id INTEGER PRIMARY KEY,
            winner_name TEXT NOT NULL,
            board_json TEXT NOT NULL,
            player_figure INTEGER NOT NULL,
            time TEXT NOT NULL,
            player_nick_name TEXT NOT NULL,
            FOREIGN KEY (player_nick_name) REFERENCES player(nick_name)
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

  // Создаем или получаем игрока по никнейму
  Future<void> _ensurePlayerExists(String nickName) async {
    try {
      // Сначала проверяем, существует ли игрок
      final existing = await _db.query(
        'player',
        where: 'nick_name = ?',
        whereArgs: [nickName],
        limit: 1,
      );

      if (existing.isNotEmpty) {
        return;
      }

      // Если не существует, добавляем игрока в базу данных
      await _db.insert('player', {'nick_name': nickName});
    } catch (e) {
      throw DbException('Failed to ensure player exists: $e');
    }
  }

  // Сохраняем снапшот игры для указанного игрока
  @override
  Future<void> saveSnapshot(
    GameSnapshot snapshot,
    String playerNickName,
  ) async {
    try {
      await _ensurePlayerExists(playerNickName);

      final boardJson = jsonEncode(snapshot.board.toJson());

      await _db.insert('game_snapshot', {
        'snapshot_name': snapshot.snapshotName,
        'board_json': boardJson,
        'player_figure': snapshot.playerFigure.index,
        'state': snapshot.gameState,
        'mode': snapshot.gameMode,
        'difficulty': snapshot.difficulty ?? '',
        'player_nick_name': playerNickName,
      }, conflictAlgorithm: ConflictAlgorithm.fail);
    } catch (e) {
      throw DbException('Failed to save snapshot: $e');
    }
  }

  // Получаем все снапшоты игр для указанного игрока
  @override
  Future<List<GameSnapshot>> getSnapshots(String nickName) async {
    try {
      final maps = await _db.query(
        'game_snapshot',
        where: 'player_nick_name = ?',
        whereArgs: [nickName],
      );

      final snapshots = <GameSnapshot>[];
      for (final map in maps) {
        final boardJson = jsonDecode(map['board_json'] as String);
        final snapshot = GameSnapshot(
          snapshotName: map['snapshot_name'] as String,
          board: Board.fromJson(boardJson),
          playerFigure: Cell.values[map['player_figure'] as int],
          gameState: map['state'] as int,
          gameMode: map['mode'] as int,
          difficulty: (map['difficulty'] as String).isEmpty
              ? null
              : map['difficulty'] as String,
        );
        snapshots.add(snapshot);
      }
      return snapshots;
    } catch (e) {
      throw DbException('Failed to get snapshots: $e');
    }
  }

  // Проверяем существует ли снапшот с указанным именем для данного игрока
  @override
  Future<bool> isSnapshotExist(String snapshotName, String nickName) async {
    try {
      final result = await _db.query(
        'game_snapshot',
        where: 'snapshot_name = ? AND player_nick_name = ?',
        whereArgs: [snapshotName, nickName],
        limit: 1,
      );
      return result.isNotEmpty;
    } catch (e) {
      throw DbException('Failed to check snapshot existence: $e');
    }
  }

  // Сохраняем информацию о завершенной игре
  @override
  Future<void> saveFinishedGame(FinishGameSnapshot snapshot) async {
    try {
      await _ensurePlayerExists(snapshot.playerNickName);

      final boardJson = jsonEncode(snapshot.board.toJson());

      await _db.insert('player_finish_game', {
        'winner_name': snapshot.winnerName,
        'board_json': boardJson,
        'player_figure': snapshot.playerFigure.index,
        'time': snapshot.time.toIso8601String(),
        'player_nick_name': snapshot.playerNickName,
      });
    } catch (e) {
      throw DbException('Failed to save finished game: $e');
    }
  }

  // Получаем все завершенные игры для указанного игрока
  @override
  Future<List<FinishGameSnapshot>> getFinishedGames(String nickName) async {
    try {
      final maps = await _db.query(
        'player_finish_game',
        where: 'player_nick_name = ?',
        whereArgs: [nickName],
      );

      final finishedGames = <FinishGameSnapshot>[];
      for (final map in maps) {
        final boardJson = jsonDecode(map['board_json'] as String);
        final snapshot = FinishGameSnapshot(
          board: Board.fromJson(boardJson),
          playerFigure: Cell.values[map['player_figure'] as int],
          winnerName: map['winner_name'] as String,
          playerNickName: map['player_nick_name'] as String,
          time: DateTime.parse(map['time'] as String),
        );
        finishedGames.add(snapshot);
      }
      return finishedGames;
    } catch (e) {
      throw DbException('Failed to get finished games: $e');
    }
  }
}
