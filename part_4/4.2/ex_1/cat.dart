class Cat{
  late final String name;
  String address = 'Unknown';
  int age = 0;
  bool sleepState = true;

  void sleep(){
    if(!sleepState){
      sleepState = true;
      print('Кот засыпает: Хр-р-р-р-р...');
    }
    else{
      print('Сон во сне... мммм...');
    }
  }

  void wakeUp(){
    if(sleepState){
      sleepState = false;
      print('Лениво потягиваясь, открывает глаза...');
    }
  }

  void helloMaster(){
    if(!sleepState){
      print('Мя-я-я-я-у!!!');
    }
  }

  
void currentState(){
    if(sleepState){
      print('Кот спит');
    }
    else{
      print('Кот бодрствует');  
    }
  }
}
