import 'lib_a.dart';

class Moderator extends User{
  Moderator(super.name, super.age, super.id);

  @override
  String publicHello(){
    return 'Moderator ${userPrivateHello(this)}';
  }

  @override
  String toString() {
    return 'Moderator($name, ${userAge(this)}, $id)';
  }
}

void main() {
  var user = User('Alex', 22, 1);
  var moderator = Moderator('Max', 32, 5);

  print(user.publicHello()); // Public Hello!
  print(moderator.publicHello()); // Moderator Private Hello!
  print(moderator); // Moderator(Max, 32, 5)
}