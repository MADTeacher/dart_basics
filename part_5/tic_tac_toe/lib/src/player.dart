import 'cell_type.dart';

class Player {
  Cell cellType;

  Player(this.cellType);

  void switchPlayer() {
    cellType = cellType == Cell.cross ? Cell.nought : Cell.cross;
  }

  String get symbol => cellType == Cell.cross ? 'X' : 'O';

  Map<String, dynamic> toJson() {
    return {
      'cellType': cellType.toString(),
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(Cell.values.firstWhere(
      (e) => e.toString() == json['cellType'],
    ));
  }
}
