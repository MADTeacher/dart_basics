import '../model/game_snapshot.dart';
import '../model/finish_game_shapshot.dart';

abstract interface class IDatabaseProvider {
  // Сохраняем снапшот игры для указанного игрока
  Future<void> saveSnapshot(GameSnapshot snapshot, String playerNickName);

  // Получаем все снапшоты игр для указанного игрока
  Future<List<GameSnapshot>> getSnapshots(String nickName);

  // Проверяем существует ли снапшот с указанным именем для данного игрока
  Future<bool> isSnapshotExist(String snapshotName, String nickName);

  // Сохраняем информацию о завершенной игре
  Future<void> saveFinishedGame(FinishGameSnapshot snapshot);

  // Получаем все завершенные игры для указанного игрока
  Future<List<FinishGameSnapshot>> getFinishedGames(String nickName);

  // Закрываем соединение с базой данных
  Future<void> close();
}
