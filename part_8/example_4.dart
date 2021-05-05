import 'dart:async';

void main(List<String> arguments) {
  var future = Future<String>(() =>
                'Привет! Это событие в очереди под номером: ');
  
  var newfuture = Future<String>(() =>
        'Привет! Это еще одно событие в очереди под номером: ');
  
int a = 10;
  future.then((value){
    print('$value 1');
    return 1;
  }).then((value) => print(value + a));

  newfuture.then((value){
    print('$value 2');
    return 2.5;
  }).then((value) => print(value + a));

  print('завершение main');
}
