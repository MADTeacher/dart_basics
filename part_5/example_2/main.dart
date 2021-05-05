import 'cat.dart';

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat()
      ..age=3
      ..name='Тимоха';

/*
// ошибка
  var cat = Cat()
      ..age=3
      ..name='Тимоха'
      .._sleepState=true;
*/
  
  cat.helloMaster(); // Мя-я-я-я-у!!!
  cat.currentState(); // Кот бодрствует
  cat.sleep(); // Кот засыпает: Хр-р-р-р-р...
  cat.sleep(); // Сон во сне... мммм...
  cat.wakeUp(); // Лениво потягиваясь, открывает глаза...
}
