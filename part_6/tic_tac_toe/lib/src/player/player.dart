import '../board/board.dart';
import '../board/cell_type.dart';
import 'i_player.dart';

class Player implements IPlayer {
  Cell _figure;

  Player(this._figure);

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      Cell.values.firstWhere((e) => e.toString() == json['cellType']),
    );
  }

  // Возвращаем текущую фигуру игрока
  @override
  Cell get cellType => _figure;

  // Изменяем фигуру текущего игрока
  @override
  void switchPlayer() {
    _figure = _figure == Cell.cross ? Cell.nought : Cell.cross;
  }

  // Возвращаем символ игрока
  @override
  String get symbol => _figure.symbol;

  @override
  Map<String, dynamic> toJson() {
    return {'cellType': _figure.toString()};
  }

  @override
  bool get isComputer => false;

  // Метод-заглушка, т.к. ввод игрока осуществляется на
  // уровне пакета game, где нужно еще отрабатывать
  // команду на выход и сохранение игровой сессии
  @override
  Future<({int x, int y, bool success})> makeMove(Board board) async {
    return (x: -1, y: -1, success: false);
  }

  // Обрабатываем строку ввода и
  // преобразуем ее в координаты хода
  ({int x, int y, bool success}) parseMove(String move, Board board) {
    var inputList = move.split(' ');
    if (inputList.length != 2) {
      print("Invalid input. Please try again.");
      return (x: -1, y: -1, success: false);
    }
    int? x = int.tryParse(inputList[1]);
    int? y = int.tryParse(inputList[0]);
    if (x == null ||
        y == null ||
        x < 1 ||
        x > board.size ||
        y < 1 ||
        y > board.size) {
      print("Invalid input. Please try again.");
      return (x: -1, y: -1, success: false);
    }
    // Преобразуем введенные координаты (начиная с 1)
    // в индексы массива (начиная с 0)
    return (x: x - 1, y: y - 1, success: true);
  }
}
