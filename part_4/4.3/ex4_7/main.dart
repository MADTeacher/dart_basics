import 'cat.dart';

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat('Тимоха', 3, 'Москва', true);

  print(cat.name); // Тимоха
  print(cat.age); // 3
  print(cat.address); // Москва

  cat.helloMaster(); 
  cat.currentState(); // Кот спит
}
