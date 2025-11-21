import '../board/board.dart';
import '../board/cell_type.dart';

// Интерфейс для любого игрока, будь то человек или компьютер
abstract interface class IPlayer {
  // Получение символа игрока (X или O)
  String get symbol;

  // Получение текущей фигуры игрока
  Cell get cellType;

  // Проверка, является ли игрок компьютером
  bool get isComputer;

  // Переключение хода на другого игрока
  void switchPlayer();

  // Выполнение хода игрока
  // Возвращает координаты хода (x, y) и признак успешности
  Future<({int x, int y, bool success})> makeMove(Board board);

  // Перевод данных игрока в JSON-формат
  Map<String, dynamic> toJson();
}
