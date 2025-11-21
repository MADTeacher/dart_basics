import '../model/game_snapshot.dart';
import '../model/finish_game_shapshot.dart';

abstract interface class IDatabaseProvider {
  /// Сохраняет снапшот игры для указанного игрока
  Future<void> saveSnapshot(GameSnapshot snapshot, String playerNickName);

  /// Получает все снапшоты игр для указанного игрока
  Future<List<GameSnapshot>> getSnapshots(String nickName);

  /// Проверяет существует ли снапшот с указанным именем для данного игрока
  Future<bool> isSnapshotExist(String snapshotName, String nickName);

  /// Сохраняет информацию о завершенной игре
  Future<void> saveFinishedGame(FinishGameSnapshot snapshot);

  /// Получает все завершенные игры для указанного игрока
  Future<List<FinishGameSnapshot>> getFinishedGames(String nickName);

  /// Закрывает соединение с базой данных
  Future<void> close();
}
