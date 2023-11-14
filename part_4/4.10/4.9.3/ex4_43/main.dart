import 'lib_a.dart';

base class Moderator extends User{
  Moderator(super.name, super.id){
    print('Moderator created');
  }


  @override
  String toString() {
    return 'Moderator($name, $id)';
  }
}


void main() {
  var user = User('Alex', 22); // User created
  var moderator = Moderator('Max', 1); // User created Moderator created

  print(user.publicHello()); // Public Hello!
  print(moderator.publicHello()); // <- здесь будет падение
  print(moderator); // 
}