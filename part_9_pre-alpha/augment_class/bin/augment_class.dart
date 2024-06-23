import augment 'aug_batman.dart';

class Batman {
  final name;
  final age; 

  void printAge() {
    print(age);
  }
}

void main(List<String> arguments) {
    var batman = Batman("Bruce", 20);
    print(batman.toString());
}
