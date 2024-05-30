import 'game.dart';

abstract interface class GameSaver {
  void saveGame(Game currentGame, String saveFilePath);
}