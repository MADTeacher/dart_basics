import 'dart:math'; // подключаем библиотеку math 
// для использования функции pow

int Function(int value) degree(int degree){
  return (int value) => pow(value, degree).toInt();
}

void main(List<String> arguments) {
  var calculation = degree(3);
  print(calculation(3)); // 27
  print(calculation(2)); // 8
  calculation = degree(8);
  print(calculation(3)); // 6561
  print(calculation(7)); // 5764801
}
