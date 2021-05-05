void main(List<String> arguments) {
  var inputValue = 0;
  var resultValue = 0;
  var scalingValue = 100;
  try{
    if (inputValue == 0){
      throw IntegerDivisionByZeroException();
    }
    resultValue = scalingValue ~/ inputValue;
  }on IntegerDivisionByZeroException{
    print('Произошло деление на ноль!!!');
  }
  catch(e){
    print('Ошибка: $e');
  }
// Произошло деление на ноль!!!

  try{
    if (inputValue == 0){
      throw ArgumentError();
    }
    resultValue = scalingValue ~/ inputValue;
  }on IntegerDivisionByZeroException{
    print('Произошло деление на ноль!!!');
  }
  catch(e){
    print('Ошибка: $e');
  }
  //Ошибка: Invalid argument(s)
}
