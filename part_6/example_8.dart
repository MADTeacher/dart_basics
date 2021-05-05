class MyException implements Exception {
  final String? msg;

  const MyException([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}

void myFunc(){
  throw MyException('Пользовательское исключение');
}

void main(List<String> arguments) {
  try{
    myFunc();
  } on MyException catch(e, s){
    print(e);
    print(s);
  }
}
