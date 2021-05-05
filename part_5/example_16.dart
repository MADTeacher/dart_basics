mixin Eating{
  void eat(){
    print('Кушать');
  }
}

mixin Running{
  void run(){
    print('Бежать');
  }
}

abstract class Purring{
  void purr(){
    print('Му-р-р-р-р');
  }
}

abstract class Whining{
  void whine(){
    print('У-у-у-у-у-у');
  }
  
}

abstract class flying {
  void fly() {
    print('Полет');
  }
}

class  Cat extends Purring with Eating, Running {
  void goToEat(){
    run();
    eat();
    purr();
    print('От послеобеденного мурчания кота можно оглохнуть!');
  }
}

class Dog extends Whining with Eating, Running {
  void runToEat(){
    run();
    eat();
    print('Пес полакомился обедом');
  }
}

class Bird extends flying with Eating, Running {
  void flyToEat(){
    fly();
    run();
    eat();
    print('После обеда птица нежится на солнце');
  }
}

void main(List<String> arguments) {
  var bird = Bird()..flyToEat();
  print('-' * 30);
  var cat = Cat()..goToEat();
  print('-' * 30);
  var dog = Dog()..runToEat();

  print('-' * 30);
  // приводим экземпляры класса к примеси
  var listMixin = <Eating>[bird, cat, dog];
  listMixin.forEach((element) {
    element.eat();
  });
}
