void main(List<String> arguments) {
  var inputValue = 0;
  var resultValue = 0;
  var scalingValue = 100;
  try{
    resultValue = scalingValue ~/ inputValue;
  }on UnsupportedError{
    print('Произошло деление на ноль!!!');
    rethrow;
  } on ArgumentError catch(e){ print('Ошибка: $e');  }
}
