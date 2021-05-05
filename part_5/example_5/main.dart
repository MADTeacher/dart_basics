import 'cat.dart';

void catProcessing(Cat cat){
  print('Возраст кота "${cat.name}"  = ${cat.age}');
  cat.helloMaster(); 
  cat.currentState(); 
}

void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat(name: 'Тимоха', sleepState: true);
  catProcessing(cat);
  print('*'*20);
  cat = Cat.onlyName('Тимоха');
  catProcessing(cat);
  print('*'*20);
  cat = Cat.fromNameAndAge('Тимоха', 1);
  catProcessing(cat);
}
