class SingleCat{
  String _name;
  int age;
  static SingleCat? _singleCat;

  SingleCat._(this._name, this.age); // приватный конструктор

  factory SingleCat([String name='', int age=0]){
    return _singleCat ??= SingleCat._(name, age);
  }
  
  String get name => _name;
}
