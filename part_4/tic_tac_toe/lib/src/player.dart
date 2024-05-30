import 'cell_type.dart';

class Player {
  Cell cellType;

  Player(this.cellType);

  void switchPlayer() {
    cellType = cellType == Cell.cross ? Cell.nought : Cell.cross;
  }

  String get symbol => cellType == Cell.cross ? 'X' : 'O';
}
