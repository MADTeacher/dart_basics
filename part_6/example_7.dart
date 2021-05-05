class MyException implements Exception {
  final String? msg;

  const MyException([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}

void main(List<String> arguments) {
  try{
    throw MyException('Пользовательское исключение');
  } on MyException catch(e){
    print(e); // Пользовательское исключение
  }
}
