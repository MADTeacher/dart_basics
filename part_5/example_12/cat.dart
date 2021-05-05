import 'animal.dart';

class Cat extends Animal {
  Cat(String name, int age) : super(name, age);
  
  @override //переопределяем метод базового класса
  void helloMaster(){
    if(!sleepState){
      print('$name: Мя-я-я-я-у!!!');
    }
  }

  void purr(){ //метод доступный только экземплярам класса Cat
    print('$name: М-р-р-р-р-р');
  }
}
