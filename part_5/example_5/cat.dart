class Cat{
  late final String name;
  int age = 0;
  // по умолчанию кот, при создании экземпляра класса
  // всегда бодрствует
  bool _sleepState = false; 

  Cat({required this.name, this.age = 2, required bool sleepState})
      : _sleepState = sleepState;

  Cat.onlyName(String nameCat) 
      : this(name: nameCat, sleepState: true);

  Cat.fromNameAndAge(String name, int old)
      : this(name: name, age: old, sleepState: true);


  bool get isSleep => _sleepState;
  set setSleepState(bool val) => _sleepState = val;

  void sleep(){
    if(!_sleepState){
      _sleepState = true;
      print('Кот засыпает: Хр-р-р-р-р...');
    }
    else{
      print('Сон во сне... мммм...');
    }
  }

  void wakeUp(){
    if(_sleepState){
      _sleepState = false;
      print('Лениво потягиваясь, открывает глаза...');
    }
  }

  void helloMaster(){
    if(!_sleepState){
      print('Мя-я-я-я-у!!!');
    }
  }

  void currentState(){
    if(_sleepState){
      print('Кот спит');
    }
    else{
      print('Кот бодрствует');  
    }
  }
}
