import 'cat.dart';

void main(List<String> arguments) {
  var cat = Cat('Тимоха', 'Москва');

  print('Возраст кота "${cat.name}" = ${cat.age}');
  // Возраст кота "Тимоха" = 4
  print(
    'Город прожавания кота "${cat.name}" = ${cat.address}',
  ); // Город прожавания кота "Тимоха" = Москва
  cat.helloMaster();
  cat.currentState(); // Кот спит
}
