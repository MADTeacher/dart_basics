base class User{
  final String name;
  final int id;

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