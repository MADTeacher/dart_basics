import 'lib_a.dart';

base class Moderator implements User{
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