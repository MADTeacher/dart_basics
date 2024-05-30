import 'package:tic_tac_toe/tic_tac_toe.dart';

void main() {
  while (!initBoard()) {
    print('Invalid size, please enter again');
  }
  play();
}
