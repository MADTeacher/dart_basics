class User{
  final String name;
  int _age;
  final int id;

  User(this.name, this._age, this.id);

  String _privateHello(){
    return 'Private Hello!';
  }

  String publicHello(){
    return 'Public Hello!';
  }
}

int userAge(User user){
  return user._age;
}

String userPrivateHello(User user){
  return user._privateHello();
}
