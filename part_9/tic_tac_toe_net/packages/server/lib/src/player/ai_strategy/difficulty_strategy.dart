import 'package:common/board.dart';

// Интерфейс стратегии выбора хода для компьютерного игрока
abstract class DifficultyStrategy {
  // Выполняем ход на основе стратегии
  Future<({int row, int col})> makeMove(Board board, Cell figure);
}
