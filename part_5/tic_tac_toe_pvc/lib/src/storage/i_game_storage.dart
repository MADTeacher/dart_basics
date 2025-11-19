import '../model/game_snapshot.dart';

abstract interface class IGameLoader {
  GameSnapshot? loadGame(String path);
}

abstract interface class IGameSaver {
  void saveGame(GameSnapshot currentGame, String path);
}

abstract interface class IGameStorage implements IGameLoader, IGameSaver {}
