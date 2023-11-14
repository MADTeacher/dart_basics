class Cat {
  late final int _old;
  late final String _name;
  set old(int old) {
    this._old = old;
  }
  
  set name(String name) {
    this._name = name;
  }
 
  void helloMaster(){
    print("Мяу-у-у-у!!!");
  }
}

void main(List<String> arguments) {
  var cat = Cat()
  ..name = 'Муся'
  ..old = 4
  ..helloMaster();
  // аналогично записи ниже
  var newCat = Cat();
  newCat.name = 'Муся';
  newCat.old = 4;
  newCat.helloMaster();
}
