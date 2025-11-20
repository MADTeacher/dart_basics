import 'dart:convert';
import 'dart:io';

import '../model/game_snapshot.dart';
import 'i_game_storage.dart';

class JsonGameStorage implements IGameStorage {
  @override
  void saveGame(GameSnapshot currentGame, String path) {
    var encoder = JsonEncoder.withIndent('  ');
    File(path).writeAsStringSync(encoder.convert(currentGame.toJson()));
  }

  @override
  GameSnapshot? loadGame(String saveFilePath) {
    if (File(saveFilePath).existsSync()) {
      final gameStateString = File(saveFilePath).readAsStringSync();
      final gameStateJson = json.decode(gameStateString);
      return GameSnapshot.fromJson(gameStateJson);
    }
    return null;
  }
}
