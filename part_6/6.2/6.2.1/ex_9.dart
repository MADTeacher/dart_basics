import 'dart:async';

void main(List<String> arguments) {
  var future = Future<String>.value('^_^');
  future.then((value){
    print('($value) - завершение Future');
  });
  print('завершение main');
}
