import 'dart:io';

Iterable<int> myGenerator(int n) sync* {
  var k = 0;
  while(k < n){
    if (k % 4 == 0){
      yield k;
    }
    k++;
  }
}

void main(List<String> arguments) {
  var result = <int>[];
  
  print('Введите границу генерируемой послед-ти: '); 
  // читаем значение введенное с клавиатуры
  var n = int.parse(stdin.readLineSync()!); // вводим 20

  for(var it in myGenerator(n)){
    result.add(it);
  }
  print(result); // [0, 4, 8, 12, 16]
}
