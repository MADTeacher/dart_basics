import 'dart:async';

int add() => 10 + 15;

void main(List<String> arguments) {
  var firstFuture = Future<int>(add);
  Future(()=> print('Oo'));
  firstFuture.then((value) => print(value));
  print('завершение main');
}
