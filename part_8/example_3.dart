import 'dart:async';

int add() => 10 + 15;
void myPrint(int a) => print(a);

void main(List<String> arguments) {
  var firstFuture = Future<int>(add);
  var secondFuture = Future(()=> 'Oo');
  firstFuture.then(myPrint);
  secondFuture.then(print);
  print('завершение main');
}
