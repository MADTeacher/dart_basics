import 'package:common/board.dart';

String cellSymbol(Cell cell) {
  return switch (cell) {
    Cell.empty => ' ',
    Cell.cross => 'X',
    Cell.nought => 'O',
  };
}

void printMainMenu() {
  print('*' * 20);
  print('1. Join to room');
  print('2. Get logs list');
  print('3. Exit');
  print('*' * 20);
}
