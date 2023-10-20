import 'cat.dart';

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat('Тимоха', 5, 'Москва');
  print(cat.name); // Тимоха
  print(cat.age); // 5
  print(cat.address); // Москва

  cat.helloMaster(); // Мя-я-я-я-у!!!
  cat.currentState(); // Кот бодрствует
}
