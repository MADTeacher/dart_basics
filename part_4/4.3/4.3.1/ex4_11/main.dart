import 'cat.dart';

void catProcessing(Cat cat) {
  print('Возраст кота "${cat.name}" = ${cat.age}');
  print(
    'Город прожавания кота "${cat.name}" = ${cat.address}',
  );
  cat.helloMaster();
  cat.currentState();
}

void main(List<String> arguments) {
  var cat = Cat(
    name: 'Тимоха',
    sleepState: true,
    address: 'Питер',
  );
  catProcessing(cat);
  print('*' * 20);

  cat = Cat.onlyName('Твикс');
  catProcessing(cat);
  print('*' * 20);

  cat = Cat.defaultCat();
  catProcessing(cat);
  print('*' * 20);

  cat = Cat.fromNameAndAddress('Тимоха', 'Москва');
  catProcessing(cat);
}
