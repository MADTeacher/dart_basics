import 'dart:convert';
import 'dart:io';

import 'board.dart';
import 'game.dart';
import 'game_state.dart';
import 'i_game_loader.dart';
import 'i_game_saver.dart';
import 'player.dart';

class JsonGameStateWorker implements GameSaver, GameLoader {
  @override
  void saveGame(Game currentGame, String saveFilePath) {
    var encoder = JsonEncoder.withIndent('  ');
    File(saveFilePath).writeAsStringSync(encoder.convert(
      currentGame.toJson(),
    ));
  }

  @override
  Game? loadGame(String saveFilePath) {
    if (File(saveFilePath).existsSync()) {
      final gameStateString = File(saveFilePath).readAsStringSync();
      final gameStateJson = json.decode(gameStateString);
      final board = Board.fromJson(gameStateJson['board']);
      final currentPlayer = Player.fromJson(
        gameStateJson['currentPlayer'],
      );
      final state = GameState.values.firstWhere(
        (element) => element.name == gameStateJson['gameState'],
        orElse: () => GameState.playing,
      );
      return Game(board, currentPlayer, this, state: state);
    }
    return null;
  }
}