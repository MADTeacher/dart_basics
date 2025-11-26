void main(List<String> arguments) {
  var inputValue = 0;
  var resultValue = 0;
  var scalingValue = 100;

 // 1
  try{
    resultValue = scalingValue ~/ inputValue;
  }
  catch(e){
    // перехват всех исключений и ошибок
    print('Произошло деление на ноль!!!');
    print(e);
  }

// Произошло деление на ноль!!!
// IntegerDivisionByZeroException

 //2
  try{
    resultValue = scalingValue ~/ inputValue;
  } on UnsupportedError {
    // перехват специализированного исключения
    print('Произошло деление на ноль!!!');
  }
// Произошло деление на ноль!!!

//3
  try{
    resultValue = scalingValue ~/ inputValue;
  }on Exception catch (e) {
  // Перехватывает все исключения
  print('Сгенерированное исключение: $e');
  } catch (e) {
  // Перехватывает вообще всё 
  // и исключения и ошибки
  print('Что-то из ряда вон выходящего: $e');
  }
//Сгенерированное исключение: IntegerDivisionByZeroException

//4
  try{
    resultValue = scalingValue ~/ inputValue;
  }on UnsupportedError {
    // перехват специализированного исключения
    print('Произошло деление на ноль!!!');
  }
  finally{
    print('Что бы ни произошло, я - великолепен!!!');
  }
// Произошло деление на ноль!!!
// Что бы ни произошло, я - великолепен!!!
}
