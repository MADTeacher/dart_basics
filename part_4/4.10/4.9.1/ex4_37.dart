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

class Moderator extends User{
  Moderator(super.name, super.age, super.id);

  @override
  String publicHello(){
    return 'Moderator ${super._privateHello()}';
  }

  @override
  String toString() {
    return 'Moderator($name, $_age, $id)';
  }
}

void main() {
  var user = User('Alex', 22, 1);
  var moderator = Moderator('Max', 32, 5);

  print(user.publicHello()); // Public Hello!
  print(moderator.publicHello()); // Moderator Private Hello!
  print(moderator); // Moderator(Max, 32, 5)
}