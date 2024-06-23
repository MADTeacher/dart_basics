augment library 'augment_class.dart';

augment class Batman {
  Batman(this.name,this.age);

  augment void printAge(){
    print(age+1);
  }

  @override
  String toString() {
    return 'Batman{name: $name, age: $age}';
  }
}
