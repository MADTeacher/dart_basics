class Animal {
  final String name;
  int age;
  bool sleepState = false;
  
  Animal(this.name, this.age);

  void sleep(){
    if(!sleepState){
      sleepState = true;
      print('$name засыпает: Хр-р-р-р-р...');
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
    print('$name: o_O');
  }

  void currentState(){
    if(sleepState){
      print('$name спит');
    }
    else{
      print('$name бодрствует');  
    }
  }
}
