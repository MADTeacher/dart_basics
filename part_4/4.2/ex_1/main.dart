import 'cat.dart';

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat()
      ..age=3
      ..name='Тимоха'
      ..sleepState=false;
  
  cat.helloMaster(); // Мя-я-я-я-у!!!
  cat.currentState(); // Кот бодрствует
  cat.sleepState = true;
  cat.currentState(); // Кот спит
  cat.sleep(); // Сон во сне... мммм...
}
