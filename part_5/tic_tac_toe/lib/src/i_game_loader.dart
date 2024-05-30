import 'game.dart';

abstract interface class GameLoader {
  Game? loadGame(String saveFilePath);
}