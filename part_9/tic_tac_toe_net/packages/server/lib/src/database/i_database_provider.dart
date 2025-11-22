import 'package:common/finish_game_shapshot.dart';

abstract interface class IDatabaseProvider {
  // Сохраняет информацию о завершенной игре
  Future<void> saveFinishedGame(FinishGameSnapshot snapshot);

  // Получает все завершенные игры
  Future<List<FinishGameSnapshot>> getAllFinishedGames();

  // Получает конкретную завершенную игру по ID
  Future<FinishGameSnapshot> getFinishedGameById(int id);
  
  // Закрываем соединение с базой данных
  Future<void> close();
}
