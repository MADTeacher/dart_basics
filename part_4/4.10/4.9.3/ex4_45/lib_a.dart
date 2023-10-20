base class User{
  final String name;
  final int id;
  int _aa = 0;

  User(this.name, this.id){
    print('User created');
  }

  String publicHello(){
    return 'Public Hello!';
  }

  @override
  String toString() {
    return 'User($name, $id)';
  }
}

void tt(User u){
  print(u._aa);
}