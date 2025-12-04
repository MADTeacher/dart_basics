import 'dart:async';

void main(List<String> arguments) {
  var future = Future<String>.sync(() {
    print('Запуск Future');
    return '^_^';
  });
  future.then((value){
    print('($value) - завершение Future');
  });
  print('завершение main');
}
