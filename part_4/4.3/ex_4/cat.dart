class Cat {
  late final String name;
  String _address = 'Unknown';
  int age = 0;
  bool _sleepState = false;

  Cat({
    required this.name,
    required bool sleepState,
    this.age = 2,  
    String address = 'Unknown',
  })  : _sleepState = sleepState,
        _address = address;

  bool get isSleep => _sleepState;
  set setSleepState(bool val) => _sleepState = val;

  String get address {
    if (_address == 'Unknown') {
      return 'Default City';
    }
    return _address;
  }

  set address(String val) {
    if (val == '') {
      return;
    }
    _address = val;
  }

  void sleep() {
    if (!_sleepState) {
      _sleepState = true;
      print('Кот засыпает: Хр-р-р-р-р...');
    } else {
      print('Сон во сне... мммм...');
    }
  }

  void wakeUp() {
    if (_sleepState) {
      _sleepState = false;
      print('Лениво потягиваясь, открывает глаза...');
    }
  }

  void helloMaster() {
    if (!_sleepState) {
      print('Мя-я-я-я-у!!!');
    }
  }

  void currentState() {
    if (_sleepState) {
      print('Кот спит');
    } else {
      print('Кот бодрствует');
    }
  }
}
