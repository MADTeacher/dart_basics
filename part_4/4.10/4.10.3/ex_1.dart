class User{
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

class Moderator implements User{
  @override
  int get id => 1;

  @override
  String get name => 'Max';

  @override
  String publicHello() {
    return 'Moderator Public Hello!';
  }

  @override
  String toString() {
    return 'Moderator($name, $id)';
  }
}

void main() {
  var user = User('Alex', 22); // User created
  var moderator = Moderator();

  print(user.publicHello()); // Public Hello!
  print(moderator.publicHello()); // Moderator Private Hello!
  print(moderator); // Moderator(Max, 1)
}