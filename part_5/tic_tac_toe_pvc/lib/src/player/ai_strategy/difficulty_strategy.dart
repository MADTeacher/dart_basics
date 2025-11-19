import '../../board/board.dart';
import '../../board/cell_type.dart';

// Интерфейс стратегии выбора хода для компьютерного игрока
abstract class DifficultyStrategy {
  // Выполняем ход на основе стратегии
  ({int row, int col}) makeMove(Board board, Cell figure);
}
