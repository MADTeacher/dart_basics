import 'dart:async';

class MyException implements Exception {
  final String? msg;

  const MyException([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}

int myFunction(){
  var sum = 0;
  for(var i=0; i<30; i++){
    sum += i;
    if(sum > 40){
      throw MyException();
    }
  }
  return sum;
}

void main(List<String> arguments) {
  var future = Future<int>(myFunction);
  future.then(print)
    .catchError((onError) => print(onError),
                test: (error) => error is MyException);
  Future(()=> print('-_-'));
  print('завершение main');
}
