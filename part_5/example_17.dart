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

abstract class flying {
  void fly() {
    print('Полет');
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

mixin Chiping on Bird{
  void chip(){
    flyToEat();
    print('Чик-чирик!');
  }
}

class Sparrow extends Bird with Chiping{}


void main(List<String> arguments) {
  var bird = Sparrow()..chip();
}

