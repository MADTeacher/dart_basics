import 'cat.dart';

void main(List<String> arguments) {
  var cat = Cat(name: 'Тимоха', sleepState: true);
  
  print('Возраст кота "${cat.name}" = ${cat.age}');
  // Возраст кота "Тимоха" = 2
  print(
    'Город прожавания кота "${cat.name}" = ${cat.address}',
  ); // Город прожавания кота "Тимоха" = Default City
  cat.helloMaster();
  cat.currentState(); // Кот спит
}
