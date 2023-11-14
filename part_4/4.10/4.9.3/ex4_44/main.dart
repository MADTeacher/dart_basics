import 'lib_a.dart';

base class Moderator extends User{
  final int levelAccess;
  
  Moderator(super.name, super.id, this.levelAccess){
    print('Moderator created');
  }
  
  String moderPublicHello(){
    return 'Moderator ${publicHello()}';
  }
  
  @override
  String toString() {
    return 'Moderator($name, $id)';
  }
}


void main() {
  var user = User('Alex', 22); // User created
  var moderator = Moderator('Max', 1, 0); // User created Moderator created

  print(user.publicHello()); // Public Hello!
  print(moderator.publicHello()); // Public Hello!
  print(moderator.moderPublicHello()); // Moderator Public Hello!
  print(moderator); // 
}