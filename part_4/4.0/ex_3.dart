class Cat{
  late final String name;
  String _address = 'Unknown';
  int age = 0;
  // по умолчанию кот, при создании экземпляра класса
  // всегда бодрствует
  bool _sleepState = false; 

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


void main(List<String> arguments) {
// создаем экземпляр класса Cat
  var cat = Cat()
      ..age=3
      ..name='Тимоха'
      .._sleepState=false;
  
  cat.helloMaster(); // Мя-я-я-я-у!!!
  cat.currentState(); // Кот бодрствует
  cat._sleepState = true;
  cat.currentState(); // Кот спит
  cat.sleep(); // Сон во сне... мммм...
  cat._sleepState = false;
  cat.currentState(); // Кот бодрствует
}
