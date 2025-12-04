class MyError extends Error {}

class MyException implements Exception {
  final String? msg;
  const MyException([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}


void exceptionFunc(){
  throw MyException('Пользовательское исключение');
}

void errorFunc(){
  throw MyError();
}

void main(List<String> arguments) {
  try{
    exceptionFunc();
  } on MyException catch(e, s){
    print(e);
    print(s);
  }

  try{
    errorFunc();
  } on MyError catch(e, s){
    print(e);
    print(s);
  }
 // или 
 // on MyError catch(e){
 //    print(e);
 //    print(e.stackTrace);
 //  }
}
