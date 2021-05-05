import 'cat.dart';

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat()
      ..age=3
      ..name='Тимоха'
      ..setSleepState=false;
  
  cat.helloMaster(); // Мя-я-я-я-у!!!
  cat.currentState(); // Кот бодрствует
  print(cat.isSleep);
  cat.setSleepState = true;
  cat.currentState(); // Кот спит
  cat.sleep(); // Сон во сне... мммм...
}
