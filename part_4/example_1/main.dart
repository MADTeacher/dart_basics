import 'src/my_calculator.dart' as calculator;
import 'src/short_calculator.dart';

void main(List<String> arguments) {
  print(add(3.5, 10)); // вызов функции из short_calculator.dart
  print(calculator.mul(2.5, 4));
  print(calculator.pow2(3));
  print(calculator.add(2.5, 4)); // вызов функции из my_calculator.dart
}
