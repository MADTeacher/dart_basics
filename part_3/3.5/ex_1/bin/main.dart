import 'dart:io';

import 'package:conquest_functions/my_math.dart';


void main() {
  // пользователь вводит 2 числа через пробел
  String? input = stdin.readLineSync();
  List<String> inputValues = input!.split(' '); 
  List<int> numbers = inputValues.map(int.parse).toList();
  print(add(numbers[0], numbers[1]));
}