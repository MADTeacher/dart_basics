void main(List<String> arguments) {
  var inputValue = 0;
  var resultValue = 0;
  var scalingValue = 100;
  try{
    if (inputValue == 0){
      throw ArgumentError();
    }
  }on IntegerDivisionByZeroException{
    print('Произошло деление на ноль!!!');
    rethrow;
  } on ArgumentError catch(e){
    print('Ошибка: $e');
  }

}
