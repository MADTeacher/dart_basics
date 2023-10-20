class MyException implements Exception {
  final String? msg;
  const MyException([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}

class MyError extends Error {
  final String? msg;
  MyError([this.msg]);

  @override
  String toString() => msg ?? 'MyException';
}

class MyNewError extends Error {}


void main(List<String> arguments) {
  try{
    throw MyException('Пользовательское исключение');
  } on MyException catch(e){
    print(e); // Пользовательское исключение
  }

  try{
    throw MyError('Пользовательская ошибка');
  } on MyError catch(e){
    print(e); // Пользовательское исключение
  }

  try{
    throw MyNewError();
  } on MyNewError catch(e){
    print(e); // Instance of 'MyNewError'
  }
}
