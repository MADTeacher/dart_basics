import 'animal.dart';

class Dog extends Animal {
  late int _aggressionLevel;

  Dog(String name, int age, int aggressionLevel) :  super(name, age) {
    _aggressionLevel = aggressionLevel;
  }

  @override //переопределяем метод базового класса
  void helloMaster() {
    if (!sleepState) {
      var hello = 'У-у-у-у!';
      if(_aggressionLevel >= 5){
        hello = 'Гр-р-р-р-р!!!';
      }
      else if (_aggressionLevel > 2){
        hello = 'Гав!';
      }
      print('$name: $hello');
    }
  }

//метод доступный только экземплярам класса Dog
  void whine() => print('$name: У-у-у-у-у!');
}
